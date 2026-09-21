import SwiftUI

struct HomeView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Spacer()
                        BrandDogView(size: 108)
                    }
                    .padding(.bottom, 2)

                    Label("Happy Healthy Together", systemImage: "pawprint.fill")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppTheme.surface, in: Capsule())

                    Text("Know What's in Their Bowl.")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Scan. Learn. Compare. For a healthier tomorrow.")
                        .font(.callout.weight(.medium))
                        .foregroundStyle(AppTheme.muted)
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
                .background(AppTheme.primary, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: AppTheme.primary.opacity(0.18), radius: 18, y: 10)

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
                    .foregroundStyle(AppTheme.primary)
                    .padding()
                    .futuristicCard(cornerRadius: 16)
                }
                .buttonStyle(.plain)

                SectionHeader("Recent Scans")
                if model.historyStore.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(AppTheme.muted)
                        Text("Your scans will appear here.")
                            .font(.title3.bold())
                            .foregroundStyle(AppTheme.ink)
                        Text("Start with a barcode scan while shopping.")
                            .font(.body)
                            .foregroundStyle(AppTheme.muted)
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
            .padding(.bottom, 150)
        }
        .background(AppTheme.backgroundGradient)
        .navigationDestination(for: String.self) { ProductSnapshotView(productID: $0) }
    }
}

struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        Text(title)
            .font(.title2.bold())
            .foregroundStyle(AppTheme.ink)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MiniScore: View {
    let score: Int

    var body: some View {
        ProductScoreBadge(score: score, size: 52)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .futuristicCard(cornerRadius: 16)
    }
}
