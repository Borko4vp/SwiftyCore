//
//  ImagePickable.swift
//  CommonCore
//
//  Created by Borko Tomic on 06/11/2020.
//

import Foundation
import UIKit

protocol ImagePickerDelegate where Self: UIViewController {
    func imagePickerDidSelect(image: UIImage?)
    func imagePickerDidSelect(video url: URL?)
}

enum ImagePickingType: String {
    case image = "public.image"
    case video = "public.movie"
}

struct ImagePickerStrings {
    var title: String
    var message: String
    var cameraButtonTitle: String
    var photoLibraryTitle: String
    var cancelTitle: String
    
}

class ImagePicker: NSObject {
    
    weak var imagePickerDelegate: ImagePickerDelegate?
    private var types: [ImagePickingType]
    
    init(delegate: ImagePickerDelegate, types: [ImagePickingType], strings: ImagePickerStrings) {
        self.imagePickerDelegate = delegate
        self.types = types
        super.init()
    }
    
    func showImagePicker(strings: ImagePickerStrings, types: [ImagePickingType], editing: Bool) {
        showImageSourcePicker(strings: strings, types: types, editing: editing)
    }
    
    private func showImageSourcePicker(strings: ImagePickerStrings, types: [ImagePickingType], editing: Bool) {
        let title = strings.title
        let message = strings.message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cameraHandler = { (action: UIAlertAction) in self.showImagePicker(with: .camera, and: types, editing: editing) }
        let photosHandler = { (action: UIAlertAction) in self.showImagePicker(with: .photoLibrary, and: types, editing: editing)}
        alert.addAction(UIAlertAction(title: strings.cameraButtonTitle, style: .default, handler: cameraHandler))
        alert.addAction(UIAlertAction(title: strings.photoLibraryTitle, style: .default, handler: photosHandler))
        alert.addAction(UIAlertAction(title: strings.cancelTitle, style: .cancel, handler: nil))
        imagePickerDelegate?.present(alert, animated: true)
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

protocol ImagePickerPresentable where Self: ImagePickerDelegate {
    var imagePickerStrings: ImagePickerStrings { get }
    var mediaTypes: [ImagePickingType] { get }
    var imagePicker: ImagePicker! { get set }
    var imagePickerEditing: Bool { get set }
    func configureImagePicker()
    func showImagePicker()
}

extension ImagePickerPresentable {
    func configureImagePicker() {
        imagePicker = ImagePicker(delegate: self, types: mediaTypes, strings: imagePickerStrings)
    }
    
    func showImagePicker() {
        imagePicker.showImagePicker(strings: imagePickerStrings, types: mediaTypes, editing: imagePickerEditing)
    }
}
