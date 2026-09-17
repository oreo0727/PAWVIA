import SwiftUI

struct ConfidenceBadge: View {
    let status: VerificationStatus?
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            Text((status ?? .community).label)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(tint.opacity(0.16), in: Capsule())
        }
        .foregroundStyle(tint)
        .sheet(isPresented: $showingDetail) {
            NavigationStack {
                List {
                    Section("Data confidence") {
                        Text("Package Verified: information checked against a physical package label.")
                        Text("Manufacturer Verified: information checked against manufacturer information.")
                        Text("Community Data: information currently comes from community/open sources and has not yet been manufacturer verified.")
                    }
                    Section {
                        Text("This is about confidence in our data. It is not a judgment about the food.")
                    }
                }
                .navigationTitle("Data Confidence")
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { showingDetail = false } } }
            }
            .presentationDetents([.medium, .large])
        }
    }

    private var tint: Color {
        switch status {
        case .packageVerified: .blue
        case .manufacturerVerified: .teal
        default: .orange
        }
    }
}
