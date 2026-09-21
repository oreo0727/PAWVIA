import SwiftUI

struct ScannerHostView: View {
    @Environment(AppModel.self) private var model
    @State private var manualBarcode = ""
    @State private var lastScannedBarcode = ""
    @State private var isLookingUp = false
    @State private var foundProductID: String?
    @State private var fallbackSearch: BarcodeSearch?
    @State private var error: Error?

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                BrandMark()
                Spacer()
                SignalPill(text: "PAWVIA SCAN", icon: "viewfinder")
            }

            ZStack {
                BarcodeScannerView(isScanning: !isLookingUp) { code in
                    Task { await lookup(code) }
                }
                RoundedRectangle(cornerRadius: 28)
                    .stroke(AppTheme.orange.opacity(0.92), lineWidth: 3)
                    .frame(width: 260, height: 170)
                    .shadow(color: AppTheme.orange.opacity(0.55), radius: 12)
                VStack {
                    Spacer()
                    HStack {
                        SignalPill(text: "ALIGN BARCODE", icon: "barcode")
                        Spacer()
                        SignalPill(text: "VERIFY DATA", icon: "bolt.fill")
                    }
                    .padding()
                }
                if isLookingUp {
                    ProgressView("Looking up food...")
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

            VStack(alignment: .leading, spacing: 12) {
                Text("Manual Barcode Entry")
                    .font(.system(.headline, design: .rounded).weight(.black))
                    .foregroundStyle(AppTheme.ink)
                Text("Use this when packaging glare or curved labels block the PAWVIA lens.")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
                HStack {
                    TextField("UPC / EAN / GTIN", text: $manualBarcode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    Button("Look Up") { Task { await lookup(manualBarcode) } }
                        .buttonStyle(.borderedProminent)
                        .disabled(manualBarcode.normalizedBarcode.isEmpty)
                }
            }
            .padding()
            .futuristicCard()
        }
        .padding()
        .background(AppTheme.backgroundGradient)
        .navigationTitle("Scan")
        .navigationDestination(item: $foundProductID) { ProductSnapshotView(productID: $0) }
        .navigationDestination(item: $fallbackSearch) { SearchView(initialQuery: $0.query) }
        .alert("We don't have this food yet.", isPresented: .constant(error != nil)) {
            Button("Search by code") {
                fallbackSearch = BarcodeSearch(query: lastScannedBarcode)
                error = nil
            }
            Button("Scan Another") { error = nil }
        } message: {
            Text(error?.localizedDescription ?? "")
        }
    }

    @MainActor
    private func lookup(_ raw: String) async {
        let barcode = raw.normalizedBarcode
        guard !barcode.isEmpty, !isLookingUp else { return }
        lastScannedBarcode = barcode
        isLookingUp = true
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        do {
            let product = try await lookupProduct(barcode)
            model.historyStore.add(product: product)
            foundProductID = product.id
        } catch {
            self.error = error
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        isLookingUp = false
    }

    private func lookupProduct(_ barcode: String) async throws -> Product {
        do {
            return try await model.api.productByBarcode(barcode)
        } catch PetFoodAPIError.notFound {
            if let product = try await lookupProductByBarcodeSearch(barcode) {
                return product
            }
            throw PetFoodAPIError.notFound
        } catch PetFoodAPIError.decoding {
            if let product = try await lookupProductByBarcodeSearch(barcode) {
                return product
            }
            throw PetFoodAPIError.decoding
        }
    }

    private func lookupProductByBarcodeSearch(_ barcode: String) async throws -> Product? {
        for query in barcode.searchVariants {
            let products = try await model.api.products(ProductQuery(q: query, pageSize: 5))
            if let exact = products.first(where: { $0.barcode?.normalizedBarcode == barcode }) {
                return exact
            }
            if products.count == 1 {
                return products[0]
            }
        }
        return nil
    }
}

private struct BarcodeSearch: Identifiable, Hashable {
    let query: String
    var id: String { query }
}

private extension String {
    var searchVariants: [String] {
        var values = [normalizedBarcode]
        if values[0].hasPrefix("0") {
            values.append(String(values[0].drop { $0 == "0" }))
        }
        return Array(Set(values)).filter { !$0.isEmpty }
    }
}
