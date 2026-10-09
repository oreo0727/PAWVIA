import SwiftUI

struct ScannerHostView: View {
    @Environment(AppModel.self) private var model
    @State private var manualBarcode = ""
    @State private var lastScannedBarcode = ""
    @State private var isLookingUp = false
    @State private var foundProductID: String?
    @State private var fallbackSearch: BarcodeSearch?
    @State private var error: Error?
    @State private var scanState: ScanResultState = .idle

    var body: some View {
        ScrollView {
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
                        .stroke(scanState.tint.opacity(0.92), lineWidth: 3)
                        .frame(width: 260, height: 170)
                        .shadow(color: scanState.tint.opacity(0.55), radius: 12)
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
                .frame(height: 380)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

                ScanResultCard(state: scanState, barcode: lastScannedBarcode) {
                    fallbackSearch = BarcodeSearch(query: lastScannedBarcode)
                    error = nil
                } onReport: {
                    scanState = .reported
                    error = nil
                }

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
            .padding(.bottom, 100)
        }
        .background(AppTheme.backgroundGradient)
        .navigationTitle("Scan")
        .navigationDestination(item: $foundProductID) { ProductSnapshotView(productID: $0) }
        .navigationDestination(item: $fallbackSearch) { SearchView(initialQuery: $0.query) }
    }

    @MainActor
    private func lookup(_ raw: String) async {
        let barcode = raw.normalizedBarcode
        guard !barcode.isEmpty, !isLookingUp else { return }
        lastScannedBarcode = barcode
        isLookingUp = true
        scanState = .searching
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        do {
            let product = try await lookupProduct(barcode)
            model.historyStore.add(product: product)
            scanState = .matched(product.name ?? "Matched food")
            foundProductID = product.id
        } catch {
            self.error = error
            scanState = .notFound
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

private enum ScanResultState: Equatable {
    case idle
    case searching
    case matched(String)
    case notFound
    case reported

    var tint: Color {
        switch self {
        case .idle, .searching: AppTheme.orange
        case .matched: AppTheme.primary
        case .notFound, .reported: AppTheme.alert
        }
    }

    var title: String {
        switch self {
        case .idle: "Ready to scan"
        case .searching: "Checking barcode"
        case .matched: "Exact match found"
        case .notFound: "No barcode match yet"
        case .reported: "Barcode queued for review"
        }
    }

    var message: String {
        switch self {
        case .idle: "Point the camera at a UPC, EAN, or GTIN. PAWVIA will verify the package against the product index."
        case .searching: "Looking for an exact barcode match, then a fallback product search."
        case .matched(let name): "Matched \(name). Opening the food snapshot."
        case .notFound: "This barcode is not in the index yet. Search by code or mark it for the backend data queue."
        case .reported: "Thanks. This barcode can be connected to the future product correction workflow."
        }
    }

    var icon: String {
        switch self {
        case .idle: "barcode.viewfinder"
        case .searching: "waveform.path.ecg"
        case .matched: "checkmark.seal.fill"
        case .notFound: "questionmark.folder.fill"
        case .reported: "tray.and.arrow.up.fill"
        }
    }
}

private struct ScanResultCard: View {
    let state: ScanResultState
    let barcode: String
    let onSearch: () -> Void
    let onReport: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: state.icon)
                    .font(.title2.weight(.black))
                    .foregroundStyle(state.tint)
                    .frame(width: 42, height: 42)
                    .background(AppTheme.techMint.opacity(0.74), in: Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(state.title)
                        .font(.system(.headline, design: .rounded).weight(.black))
                        .foregroundStyle(AppTheme.ink)
                    if !barcode.isEmpty {
                        Text(barcode)
                            .font(.system(.caption, design: .monospaced).weight(.bold))
                            .foregroundStyle(AppTheme.muted)
                    }
                }
                Spacer()
            }

            Text(state.message)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(AppTheme.muted)
                .fixedSize(horizontal: false, vertical: true)

            if state == .notFound {
                HStack(spacing: 10) {
                    Button(action: onSearch) {
                        Label("Search by code", systemImage: "magnifyingglass")
                    }
                    .buttonStyle(.borderedProminent)

                    Button(action: onReport) {
                        Label("Report miss", systemImage: "tray.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                }
                .font(.system(.subheadline, design: .rounded).weight(.bold))
            }
        }
        .padding()
        .futuristicCard()
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
