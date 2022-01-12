//
//  File.swift
//  
//
//  Created by Borko Tomic on 30.3.21..
//

import UIKit

public extension UIApplication {
    static var softwareVersion: String {
        guard let infoDict = Bundle.main.infoDictionary,
            let versionString = infoDict["CFBundleShortVersionString"] as? String,
            let buildNumber = infoDict["CFBundleVersion"] as? String else { return "" }
        return versionString + buildNumber
    }
}
