//
//  Encodable+Extension.swift
//  CommonCore
//
//  Created by Borko Tomic on 01/06/2020.
//

import Foundation

public extension Encodable {
    func createDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return nil }
        let dictionary = json as? [String: Any]
        return dictionary
    }
}
