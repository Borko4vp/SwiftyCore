//
//  UIImageView+Extension.swift
//  
//
//  Created by Borko Tomic on 13.12.20..
//

import Foundation
import UIKit

public extension UIImageView {
    func setRemoteImage(from url: String, placeholderImage: UIImage? = nil) {
        image = placeholderImage
        guard let imageUrl = URL(string: url) else { return }
        getImage(from: imageUrl) { remoteImage in
            guard let remoteImage = remoteImage else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = remoteImage
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = SwiftyCore.UI.ImageCache.shared.get(url: url.absoluteString) {
            completion(cachedImage)
            return
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                    completion(nil)
                    return
                }
                SwiftyCore.UI.ImageCache.shared.add(url: url.absoluteString, image: image)
                completion(image)
            }.resume()
        }
    }
}
