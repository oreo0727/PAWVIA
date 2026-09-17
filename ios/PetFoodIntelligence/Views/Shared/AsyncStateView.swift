import SwiftUI

struct AsyncStateView<Content: View>: View {
    let isLoading: Bool
    let error: Error?
    @ViewBuilder var content: Content

    var body: some View {
        if isLoading {
            ProgressView("Looking up food...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error {
            ContentUnavailableView("Something needs attention", systemImage: "exclamationmark.triangle", description: Text(error.localizedDescription))
        } else {
            content
        }
    }
}
