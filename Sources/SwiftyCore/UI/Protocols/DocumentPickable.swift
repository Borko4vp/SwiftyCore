//
//  DocumentPickable.swift
//  CommonCore
//
//  Created by Borko Tomic on 06/11/2020.
//

import Foundation
import UIKit
import MobileCoreServices

protocol DocumentPickerDelegate where Self: UIViewController {
    func documentPickerDidSelect(file: URL)
}

class DocumentPicker: NSObject {
    
    weak var documentPickerDelegate: DocumentPickerDelegate?
    
    init(delegate: DocumentPickerDelegate) {
        self.documentPickerDelegate = delegate
        super.init()
    }
    
    func show() {
        let types: [String] = ["public.data"]//[kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        documentPickerDelegate?.present(documentPicker, animated: true, completion: nil)
    }
}

extension DocumentPicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard !urls.isEmpty else { return }
        documentPickerDelegate?.documentPickerDidSelect(file: urls[0])
    }
}

protocol DocumentPickerPresentable where Self: DocumentPickerDelegate {
    var documentPicker: DocumentPicker! { get set }
    func configureDocumentPicker()
    func showDocumentPicker()
}

extension DocumentPickerPresentable {
    func configureDocumentPicker() {
        documentPicker = DocumentPicker(delegate: self)
    }
    
    func showDocumentPicker() {
        documentPicker?.show()
    }
}
