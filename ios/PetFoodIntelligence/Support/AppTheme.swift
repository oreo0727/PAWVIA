import SwiftUI

enum AppTheme {
    static let primary = Color(red: 0.05, green: 0.46, blue: 0.42)
    static let secondary = Color(red: 0.10, green: 0.68, blue: 0.70)
    static let orange = Color(red: 0.95, green: 0.47, blue: 0.18)
    static let cream = Color(red: 0.96, green: 0.98, blue: 0.98)
    static let ink = Color(red: 0.06, green: 0.10, blue: 0.15)
    static let muted = Color(red: 0.27, green: 0.34, blue: 0.39)
    static let surface = Color(red: 0.90, green: 0.96, blue: 0.96)
    static let elevated = Color(red: 0.995, green: 1.00, blue: 1.00)
    static let techMint = Color(red: 0.75, green: 0.96, blue: 0.91)
    static let scanLine = Color(red: 0.09, green: 0.68, blue: 0.70).opacity(0.20)
    static let glow = Color(red: 0.13, green: 0.83, blue: 0.78)
    static let violet = Color(red: 0.86, green: 0.90, blue: 1.00)
    static let signal = primary
    static let alert = Color(red: 0.85, green: 0.21, blue: 0.31)
    static let softLine = Color.black.opacity(0.08)

    static let backgroundGradient = LinearGradient(
        colors: [
            cream,
            surface,
            Color(red: 0.91, green: 0.94, blue: 1.00)
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

struct BrandMark: View {
    var compact = false

    var body: some View {
        HStack(spacing: compact ? 8 : 10) {
            ZStack {
                RoundedRectangle(cornerRadius: compact ? 10 : 12, style: .continuous)
                    .fill(AppTheme.primary)
                Image(systemName: "pawprint.fill")
                    .font(.system(size: compact ? 14 : 18, weight: .black))
                    .foregroundStyle(.white)
            }
            .frame(width: compact ? 30 : 38, height: compact ? 30 : 38)
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(AppTheme.orange)
                    .frame(width: compact ? 8 : 10, height: compact ? 8 : 10)
                    .offset(x: 2, y: -2)
            }

            if !compact {
                VStack(alignment: .leading, spacing: 0) {
                    Text("PAWVIA")
                        .font(.system(.headline, design: .rounded).weight(.black))
                    Text("BOWL INTEL")
                        .font(.system(.caption2, design: .monospaced).weight(.bold))
                        .foregroundStyle(AppTheme.muted)
                }
                .foregroundStyle(AppTheme.ink)
            }
        }
        .accessibilityLabel("PAWVIA Bowl Intel")
    }
}

struct SignalPill: View {
    let text: String
    let icon: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(.caption, design: .monospaced).weight(.bold))
            .foregroundStyle(AppTheme.primary)
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .background(AppTheme.techMint.opacity(0.72), in: Capsule())
            .overlay {
                Capsule().stroke(AppTheme.primary.opacity(0.14))
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
            .foregroundStyle(AppTheme.ink)
            .background(AppTheme.elevated.opacity(0.96), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AppTheme.softLine)
            }
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(AppTheme.scanLine)
                    .frame(height: 1)
                    .padding(.horizontal, 18)
            }
            .shadow(color: AppTheme.primary.opacity(0.12), radius: 18, y: 10)
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
