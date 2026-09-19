import SwiftUI

struct ScannerHostView: View {
    @Environment(AppModel.self) private var model
    @State private var manualBarcode = ""
    @State private var isLookingUp = false
    @State private var foundProductID: String?
    @State private var error: Error?

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                BarcodeScannerView(isScanning: !isLookingUp) { code in
                    Task { await lookup(code) }
                }
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.85), lineWidth: 3)
                    .frame(width: 260, height: 170)
                    .shadow(radius: 8)
                if isLookingUp {
                    ProgressView("Looking up food...")
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

            VStack(alignment: .leading) {
                Text("Manual Barcode Entry")
                    .font(.headline)
                HStack {
                    TextField("UPC / EAN / GTIN", text: $manualBarcode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    Button("Look Up") { Task { await lookup(manualBarcode) } }
                        .buttonStyle(.borderedProminent)
                        .disabled(manualBarcode.normalizedBarcode.isEmpty)
                }
            }
        }
        .padding()
        .navigationTitle("Scan")
        .navigationDestination(item: $foundProductID) { ProductSnapshotView(productID: $0) }
        .alert("We don't have this food yet.", isPresented: .constant(error != nil)) {
            Button("Scan Another") { error = nil }
        } message: {
            Text(error?.localizedDescription ?? "")
        }
    }

    @MainActor
    private func lookup(_ raw: String) async {
        let barcode = raw.normalizedBarcode
        guard !barcode.isEmpty, !isLookingUp else { return }
        isLookingUp = true
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        do {
            let product = try await model.api.productByBarcode(barcode)
            model.historyStore.add(product: product)
            foundProductID = product.id
        } catch {
            self.error = error
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        isLookingUp = false
    }
}
