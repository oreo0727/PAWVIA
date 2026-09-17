import SwiftUI
import VisionKit

struct BarcodeScannerView: UIViewControllerRepresentable {
    let isScanning: Bool
    let onCode: (String) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        guard DataScannerViewController.isSupported, DataScannerViewController.isAvailable else {
            return ScannerUnavailableViewController()
        }
        let controller = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: true
        )
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: UIViewController, context: Context) {
        guard let scanner = controller as? DataScannerViewController else { return }
        if isScanning {
            try? scanner.startScanning()
        } else {
            scanner.stopScanning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onCode: onCode)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onCode: (String) -> Void
        private var lastCode: String?

        init(onCode: @escaping (String) -> Void) {
            self.onCode = onCode
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            guard case let .barcode(barcode) = addedItems.first, let payload = barcode.payloadStringValue, payload != lastCode else { return }
            lastCode = payload
            onCode(payload)
        }
    }
}

final class ScannerUnavailableViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        let label = UILabel()
        label.text = "Camera scanning is unavailable here. Enter the barcode manually."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
