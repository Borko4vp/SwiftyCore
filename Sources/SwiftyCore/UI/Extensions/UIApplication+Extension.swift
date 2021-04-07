//
//  File.swift
//  
//
//  Created by Borko Tomic on 30.3.21..
//

import UIKit

public extension UIApplication {
    static let softwareVersion: String = {
        return "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")"
    }()
}
