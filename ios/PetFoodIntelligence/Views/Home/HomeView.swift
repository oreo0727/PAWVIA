import SwiftUI

struct HomeView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Scan. Score. Decide.")
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Instantly decode pet food labels with a simple score, ingredient snapshot, and nutrition context.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 18)

                HStack(spacing: 12) {
                    MiniScore(score: 82)
                    MiniScore(score: 64)
                    MiniScore(score: 18)
                }

                NavigationLink {
                    ScannerHostView()
                } label: {
                    Label("Scan a product", systemImage: "barcode.viewfinder")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(AppTheme.orange, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: AppTheme.orange.opacity(0.25), radius: 16, y: 8)

                NavigationLink {
                    SearchView()
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search foods instead")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                    }
                    .font(.headline)
                    .foregroundStyle(AppTheme.orange)
                    .padding()
                    .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppTheme.softLine)
                    }
                }
                .buttonStyle(.plain)

                SectionHeader("Recent Scans")
                if model.historyStore.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text("Your scans will appear here.")
                            .font(.title3.bold())
                        Text("Start with a barcode scan while shopping or at home.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    ForEach(model.historyStore.items.prefix(5)) { item in
                        NavigationLink(item.productName, value: item.productID)
                    }
                }
            }
            .padding()
            .padding(.bottom, 90)
        }
        .background(AppTheme.cream)
        .navigationDestination(for: String.self) { ProductSnapshotView(productID: $0) }
    }
}

struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MiniScore: View {
    let score: Int

    var body: some View {
        ProductScoreBadge(score: score, size: 52)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
