import SwiftUI

enum AppTheme {
    static let orange = Color(red: 0.98, green: 0.48, blue: 0.12)
    static let cream = Color(red: 1.0, green: 0.97, blue: 0.93)
    static let ink = Color(red: 0.10, green: 0.10, blue: 0.09)
    static let softLine = Color.black.opacity(0.07)

    static func scoreColor(_ score: Int?) -> Color {
        guard let score else { return .gray }
        switch score {
        case 75...100: return Color(red: 0.06, green: 0.63, blue: 0.30)
        case 50..<75: return Color(red: 0.48, green: 0.72, blue: 0.20)
        case 25..<50: return Color(red: 0.96, green: 0.58, blue: 0.12)
        default: return Color(red: 0.86, green: 0.18, blue: 0.15)
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
