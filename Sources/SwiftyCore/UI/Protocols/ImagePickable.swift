//
//  ImagePickable.swift
//  CommonCore
//
//  Created by Borko Tomic on 06/11/2020.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate where Self: UIViewController {
    func imagePickerDidSelect(image: UIImage?)
    func imagePickerDidSelect(video url: URL?)
}

public enum ImagePickingType: String {
    case image = "public.image"
    case video = "public.movie"
}

public struct ImagePickerStrings {
    public let title: String
    public let message: String
    public let cameraButtonTitle: String
    public let photoLibraryTitle: String
    public let cancelTitle: String
    
    public init(title: String, message: String, cameraTitle: String, libraryTitle: String, cancel: String) {
        self.title = title
        self.message = message
        cameraButtonTitle = cameraTitle
        photoLibraryTitle = libraryTitle
        cancelTitle = cancel
    }
}

public class ImagePicker: NSObject {
    
    weak var imagePickerDelegate: ImagePickerDelegate?
    private var types: [ImagePickingType]
    private var sourceTypes: [UIImagePickerController.SourceType]
    
    init(delegate: ImagePickerDelegate, types: [ImagePickingType], sources: [UIImagePickerController.SourceType], strings: ImagePickerStrings) {
        self.imagePickerDelegate = delegate
        self.types = types
        self.sourceTypes = sources
        super.init()
    }
    
    func showImagePicker(strings: ImagePickerStrings, types: [ImagePickingType], sources: [UIImagePickerController.SourceType], editing: Bool) {
        showImageSourcePicker(strings: strings, types: types, sources: sources, editing: editing)
    }
    
    private func showImageSourcePicker(strings: ImagePickerStrings, types: [ImagePickingType], sources: [UIImagePickerController.SourceType], editing: Bool) {
        if sources.count == 1 {
            showImagePicker(with: sources[0], and: types, editing: editing)
        } else if sources.count > 1 {
            let title = strings.title
            let message = strings.message
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for source in sources {
                // This is to address ios bug with editing camera captured images
                let editingFinal = source == .camera ? false : editing
                let title = source == .camera ? strings.cameraButtonTitle : strings.photoLibraryTitle
                let handler = { (action: UIAlertAction) in self.showImagePicker(with: source, and: types, editing: editingFinal) }
                alert.addAction(UIAlertAction(title: title, style: .default, handler: handler))
            }
            alert.addAction(UIAlertAction(title: strings.cancelTitle, style: .cancel, handler: nil))
            imagePickerDelegate?.present(alert, animated: true)
        } else {
            fatalError("Source types array empty, cannot proceed")
        }
    }
    
    private func showImagePicker(with source: UIImagePickerController.SourceType, and types: [ImagePickingType], editing: Bool) {
        var mediaTypes = [String]()
        for type in types {
            mediaTypes.append(type.rawValue)
        }
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = editing
        pickerController.mediaTypes = mediaTypes
        pickerController.sourceType = source
        imagePickerDelegate?.present(pickerController, animated: true)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                self.imagePickerDelegate?.imagePickerDidSelect(image: image)
            }
        } else if let videoUrl = info[.mediaURL] as? URL {
            picker.dismiss(animated: true) {
                self.imagePickerDelegate?.imagePickerDidSelect(video: videoUrl)
            }
        }
    }
}

public protocol ImagePickerPresentable where Self: ImagePickerDelegate {
    var imagePickerStrings: ImagePickerStrings { get }
    var mediaTypes: [ImagePickingType] { get }
    var sourceTypes: [UIImagePickerController.SourceType] { get }
    var imagePicker: ImagePicker! { get set }
    var imagePickerEditing: Bool { get }
    func configureImagePicker()
    func showImagePicker()
}

public extension ImagePickerPresentable {
    func configureImagePicker() {
        imagePicker = ImagePicker(delegate: self, types: mediaTypes, sources: sourceTypes, strings: imagePickerStrings)
    }
    
    func showImagePicker() {
        imagePicker.showImagePicker(strings: imagePickerStrings, types: mediaTypes, sources: sourceTypes, editing: imagePickerEditing)
    }
}
