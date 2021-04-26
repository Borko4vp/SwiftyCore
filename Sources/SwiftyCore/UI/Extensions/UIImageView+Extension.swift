//
//  UIImageView+Extension.swift
//  
//
//  Created by Borko Tomic on 13.12.20..
//

import Foundation
import UIKit

public extension UIImageView {
    func getRemoteFetchDataTaskAndSetImage(from url: String?, headers: [String: String]? = nil, placeholderImage: UIImage? = nil) -> URLSessionDataTask? {
        DispatchQueue.main.async() { [weak self] in
            self?.image = placeholderImage
        }
        guard let urlString = url, let imageUrl = URL(string: urlString) else { return nil }
        let dataTask = getImageDataTask(from: imageUrl, headers: headers) { [weak self] remoteImage in
            guard let remoteImage = remoteImage else { return }
            DispatchQueue.main.async() {
                self?.image = remoteImage
            }
        }
        return dataTask
    }
    
    func setRemoteImage(from url: String?, headers: [String: String]? = nil, placeholderImage: UIImage? = nil) {
        DispatchQueue.main.async() { [weak self] in
            self?.image = placeholderImage
        }
        guard let urlString = url, let imageUrl = URL(string: urlString) else { return }
        getImageDataTask(from: imageUrl, headers: headers) { [weak self] remoteImage in
            guard let remoteImage = remoteImage else { return }
            DispatchQueue.main.async() {
                self?.image = remoteImage
            }
        }
    }
    
    @discardableResult
    private func getImageDataTask(from url: URL, headers: [String: String]? = nil, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        if let cachedImage = SwiftyCore.UI.ImageCache.shared.get(url: url.absoluteString) {
            DispatchQueue.main.async() {
                completion(cachedImage)
            }
            return nil
        } else {
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = headers
            let dataTask = self.createImageDownloadTask(from: url, with: headers, completion: completion)
            dataTask.resume()
            return dataTask
        }
    }
    
    private func createImageDownloadTask(from url: URL, with headers: [String: String]? = nil, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        let dataTask = URLSession.shared.dataTask(with: urlRequest,completionHandler: { data, response, error in
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
        })
        return dataTask
    }
}
