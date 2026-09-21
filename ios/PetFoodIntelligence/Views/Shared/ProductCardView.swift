import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        NavigationLink(value: product.id) {
            HStack(spacing: 14) {
                ProductImageView(url: product.imageURL)
                    .frame(width: 72, height: 72)
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.primary)
                        Text(product.brandName ?? "Unknown brand")
                            .font(.system(.caption, design: .monospaced).weight(.bold))
                            .foregroundStyle(AppTheme.muted)
                    }
                    Text(product.name ?? "Unnamed food")
                        .font(.system(.headline, design: .rounded).weight(.heavy))
                        .foregroundStyle(AppTheme.ink)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    Text([product.species, product.foodForm].compactMap { $0 }.joined(separator: " / "))
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(AppTheme.muted)
                    Text(AppTheme.scoreLabel(product.completenessScore))
                        .font(.system(.caption, design: .monospaced).weight(.bold))
                        .foregroundStyle(AppTheme.scoreColor(product.completenessScore))
                }
                Spacer()
                ProductScoreBadge(score: product.completenessScore, size: 54)
            }
            .padding()
            .futuristicCard()
        }
        .buttonStyle(.plain)
    }
}

struct ProductImageView: View {
    let url: URL?

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    placeholder
                }
            } else {
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .accessibilityHidden(true)
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppTheme.elevated)
            Image(systemName: "pawprint")
                .font(.title2)
                .foregroundStyle(AppTheme.orange)
        }
    }
}
