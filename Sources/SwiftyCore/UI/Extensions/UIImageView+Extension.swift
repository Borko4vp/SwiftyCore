//
//  UIImageView+Extension.swift
//  
//
//  Created by Borko Tomic on 13.12.20..
//

import Foundation
import UIKit

public extension UIImageView {
    func setRemoteImage(from url: String?, headers: [String: String]? = nil, placeholderImage: UIImage? = nil) {
        DispatchQueue.main.async() { [weak self] in
            self?.image = placeholderImage
        }
        guard let urlString = url, let imageUrl = URL(string: urlString) else { return }
        getImage(from: imageUrl, headers: headers) { remoteImage in
            guard let remoteImage = remoteImage else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = remoteImage
            }
        }
    }
    
    private func getImage(from url: URL, headers: [String: String]? = nil, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = SwiftyCore.UI.ImageCache.shared.get(url: url.absoluteString) {
            DispatchQueue.main.async() {
                completion(cachedImage)
            }
            return
        } else {
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = headers
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    //let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                    DispatchQueue.main.async() {
                        completion(nil)
                    }
                    return
                }
                SwiftyCore.UI.ImageCache.shared.add(url: url.absoluteString, image: image)
                DispatchQueue.main.async() {
                    completion(image)
                }
            }.resume()
        }
    }
}
