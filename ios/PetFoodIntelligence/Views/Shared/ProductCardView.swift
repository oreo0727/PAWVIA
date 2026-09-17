import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        NavigationLink(value: product.id) {
            HStack(spacing: 14) {
                ProductImageView(url: product.imageURL)
                    .frame(width: 72, height: 72)
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.brandName ?? "Unknown brand")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(product.name ?? "Unnamed food")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text([product.species, product.foodForm].compactMap { $0 }.joined(separator: " / "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ConfidenceBadge(status: product.verificationStatus)
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
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
                .fill(.teal.opacity(0.12))
            Image(systemName: "pawprint")
                .font(.title2)
                .foregroundStyle(.teal)
        }
    }
}
