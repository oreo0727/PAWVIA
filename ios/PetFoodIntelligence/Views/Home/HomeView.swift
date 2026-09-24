import SwiftUI

struct HomeView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        BrandMark()
                        Spacer()
                        BrandDogView(size: 108)
                    }
                    .padding(.bottom, 2)

                    HStack(spacing: 8) {
                        SignalPill(text: "LIVE LABEL SCAN", icon: "dot.radiowaves.left.and.right")
                        SignalPill(text: "PET-SAFE DATA", icon: "checkmark.shield.fill")
                    }

                    Text("Know What's in Their Bowl.")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Scan ingredients, nutrition, recalls, and verification before it reaches their bowl.")
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
                    HStack(spacing: 14) {
                        Image(systemName: "barcode.viewfinder")
                            .font(.title2.weight(.black))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Scan a product")
                                .font(.system(.title3, design: .rounded).weight(.black))
                            Text("Open the bowl intelligence lens")
                                .font(.system(.caption, design: .monospaced).weight(.bold))
                                .opacity(0.82)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.headline.weight(.black))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        colors: [AppTheme.primary, Color(red: 0.10, green: 0.38, blue: 0.18)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                )
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(AppTheme.glow.opacity(0.36))
                        .frame(height: 1)
                        .padding(.horizontal, 18)
                }
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

                PawviaFeatureGrid()

                SectionHeader("Food History")
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

private enum HomeFeature: String, CaseIterable, Identifiable {
    case scan = "Scan"
    case ingredients = "Ingredients"
    case nutrition = "Nutrition"
    case compare = "Compare"
    case pets = "Pets"
    case favorites = "Favorites"
    case foodHistory = "Food History"
    case recalls = "Recalls"
    case manufacturerVerification = "Manufacturer Verification"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .scan: "barcode.viewfinder"
        case .ingredients: "leaf.fill"
        case .nutrition: "chart.bar.fill"
        case .compare: "rectangle.split.3x1.fill"
        case .pets: "pawprint.fill"
        case .favorites: "heart.fill"
        case .foodHistory: "clock.arrow.circlepath"
        case .recalls: "exclamationmark.shield.fill"
        case .manufacturerVerification: "checkmark.seal.fill"
        }
    }

    var destination: HomeFeatureDestination? {
        switch self {
        case .scan: .scan
        case .ingredients, .nutrition: .search
        case .compare: .compare
        case .foodHistory: .history
        case .manufacturerVerification: .ingredients
        case .pets: .pets
        case .favorites, .recalls: nil
        }
    }
}

private enum HomeFeatureDestination: Hashable {
    case scan
    case search
    case compare
    case history
    case ingredients
    case pets
}

private struct PawviaFeatureGrid: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(HomeFeature.allCases) { feature in
                if let destination = feature.destination {
                    NavigationLink(value: destination) {
                        HomeFeatureTile(feature: feature, isEnabled: true)
                    }
                    .buttonStyle(.plain)
                } else {
                    HomeFeatureTile(feature: feature, isEnabled: false)
                        .accessibilityHint("Coming soon")
                }
            }
        }
        .navigationDestination(for: HomeFeatureDestination.self) { destination in
            switch destination {
            case .scan:
                ScannerHostView()
            case .search:
                SearchView()
            case .compare:
                CompareView()
            case .history:
                HistoryView()
            case .ingredients:
                IngredientExplorerView()
            case .pets:
                PetsView()
            }
        }
    }
}

private struct HomeFeatureTile: View {
    let feature: HomeFeature
    let isEnabled: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: feature.icon)
                .font(.caption.weight(.black))
                .foregroundStyle(isEnabled ? AppTheme.primary : AppTheme.muted)
                .frame(width: 24, height: 24)
                .background((isEnabled ? AppTheme.techMint : AppTheme.surface).opacity(0.90), in: Circle())
            Text(feature.rawValue)
                .font(.system(.caption, design: .rounded).weight(.heavy))
                .foregroundStyle(isEnabled ? AppTheme.ink : AppTheme.muted)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
            Spacer(minLength: 0)
            if isEnabled {
                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.black))
                    .foregroundStyle(AppTheme.primary)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
        .background((isEnabled ? AppTheme.elevated : AppTheme.surface).opacity(0.90), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.softLine)
        }
        .opacity(isEnabled ? 1 : 0.72)
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
