import SwiftUI

enum AppTheme {
    static let primary = Color(red: 0.18, green: 0.49, blue: 0.20)
    static let secondary = Color(red: 0.40, green: 0.73, blue: 0.42)
    static let orange = Color(red: 1.00, green: 0.54, blue: 0.24)
    static let cream = Color(red: 0.98, green: 0.98, blue: 0.97)
    static let ink = Color(red: 0.12, green: 0.16, blue: 0.22)
    static let muted = Color(red: 0.42, green: 0.45, blue: 0.50)
    static let surface = Color(red: 0.95, green: 0.96, blue: 0.95)
    static let elevated = Color.white
    static let violet = Color(red: 0.99, green: 0.89, blue: 0.89)
    static let signal = primary
    static let alert = Color(red: 0.85, green: 0.21, blue: 0.31)
    static let softLine = Color.black.opacity(0.08)

    static let backgroundGradient = LinearGradient(
        colors: [
            cream,
            surface,
            Color(red: 1.00, green: 0.95, blue: 0.91)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func scoreColor(_ score: Int?) -> Color {
        guard let score else { return .gray }
        switch score {
        case 75...100: return signal
        case 50..<75: return secondary
        case 25..<50: return orange
        default: return alert
        }
    }

    static func scoreLabel(_ score: Int?) -> String {
        guard let score else { return "Unrated" }
        switch score {
        case 75...100: return "Excellent"
        case 50..<75: return "Good"
        case 25..<50: return "Limited"
        default: return "Sparse"
        }
    }
}

struct ProductScoreBadge: View {
    let score: Int?
    var size: CGFloat = 62

    var body: some View {
        let tint = AppTheme.scoreColor(score)
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .stroke(tint.opacity(0.18), lineWidth: 7)
                Circle()
                    .trim(from: 0, to: CGFloat(score ?? 0) / 100)
                    .stroke(tint, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(score.map(String.init) ?? "-")
                    .font(.system(size: size * 0.32, weight: .bold, design: .rounded))
                    .foregroundStyle(tint)
            }
            .frame(width: size, height: size)

            Text(AppTheme.scoreLabel(score))
                .font(.caption2.weight(.bold))
                .foregroundStyle(tint)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Food data score \(score.map(String.init) ?? "unrated"), \(AppTheme.scoreLabel(score))")
    }
}

struct FuturisticCard: ViewModifier {
    var cornerRadius: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .background(AppTheme.elevated.opacity(0.96), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AppTheme.softLine)
            }
            .shadow(color: AppTheme.primary.opacity(0.08), radius: 18, y: 10)
    }
}

extension View {
    func futuristicCard(cornerRadius: CGFloat = 18) -> some View {
        modifier(FuturisticCard(cornerRadius: cornerRadius))
    }
}

struct BrandDogView: View {
    var size: CGFloat = 118

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.surface, AppTheme.cream],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image("Dog")
                .resizable()
                .scaledToFit()
                .padding(8)
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(AppTheme.softLine)
        }
        .shadow(color: AppTheme.primary.opacity(0.10), radius: 14, y: 8)
        .accessibilityLabel("Illustration of a happy dog")
    }
}
