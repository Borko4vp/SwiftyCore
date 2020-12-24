//
//  File.swift
//  
//
//  Created by Borko Tomic on 21.12.20..
//

import Foundation

public extension Encodable {
    func createDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return nil }
        let dictionary = json as? [String: Any]
        return dictionary
    }
    
    var jsonString: String? {
        guard let jsonData = try? JSONEncoder().encode(self), let string = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return string
    }
}

extension Decodable {
  public init?(with dictionary: Any?) {
    guard let dictionary = dictionary else { return nil }
    guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else { return nil }
    let decoder = JSONDecoder()
    guard let initialized = try? decoder.decode(Self.self, from: data) else { return nil }
    self = initialized
  }
}
