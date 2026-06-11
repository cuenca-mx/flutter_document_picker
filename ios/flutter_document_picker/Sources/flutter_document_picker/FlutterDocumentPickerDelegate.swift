import Flutter
import UIKit

class FlutterDocumentPickerDelegate: NSObject {
    private var flutterResult: FlutterResult?
    private var params: FlutterDocumentPickerParams?

    func pickDocument(_ params: FlutterDocumentPickerParams?, result: @escaping FlutterResult) {
        flutterResult = result
        self.params = params

        guard let viewController = Self.topViewController() else {
            result(FlutterError(
                code: "error",
                message: "Unable to get view controller!",
                details: nil
            ))
            return
        }

        var documentTypes = ["public.data"]

        if let allowedUtiTypes = params?.allowedUtiTypes, !allowedUtiTypes.isEmpty {
            documentTypes = allowedUtiTypes
        }

        let documentPickerViewController = UIDocumentPickerViewController(
            documentTypes: documentTypes,
            in: .import
        )

        documentPickerViewController.delegate = self
        if params?.isMultipleSelection == true {
            documentPickerViewController.allowsMultipleSelection = true
        }

        viewController.present(documentPickerViewController, animated: true, completion: nil)
    }

    private static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return keyWindow?.rootViewController
    }

    private func sanitizeFileName(_ fileName: String) -> String {
        var sanitizedFileName = fileName

        if let invalidSymbols = params?.invalidFileNameSymbols {
            invalidSymbols.forEach { symbol in
                sanitizedFileName = sanitizedFileName.replacingOccurrences(of: symbol, with: "_")
            }
        }

        return sanitizedFileName
    }
}

extension FlutterDocumentPickerDelegate: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var arrayResult: [String?] = []
        for url in urls {
            let fileExtension = url.pathExtension

            if let allowedFileExtensions = params?.allowedFileExtensions {
                if !allowedFileExtensions.contains(where: { $0 == fileExtension }) {
                    flutterResult?(FlutterError(
                        code: "extension_mismatch",
                        message: "Picked file extension mismatch!",
                        details: fileExtension
                    ))
                    return
                }
            }

            let fileName = sanitizeFileName(url.lastPathComponent)

            var tempUrl = URL(fileURLWithPath: NSTemporaryDirectory())
            tempUrl.appendPathComponent(fileName)
            do {
                if FileManager.default.fileExists(atPath: tempUrl.path) {
                    try FileManager.default.removeItem(atPath: tempUrl.path)
                }
                try FileManager.default.moveItem(atPath: url.path, toPath: tempUrl.path)
                arrayResult.append(tempUrl.path)
            } catch {
                print(error.localizedDescription)
                arrayResult.append(nil)
            }
        }

        if arrayResult.isEmpty {
            flutterResult?(nil)
        } else {
            flutterResult?(arrayResult)
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        flutterResult?(nil)
    }
}
