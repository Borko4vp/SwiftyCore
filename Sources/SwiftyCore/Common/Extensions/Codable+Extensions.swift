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
        guard let jsonData = try? JSONEncoder().encode(self), let string = String(data: jsonData, encoding: .utf8) else { return nil }
        return string
    }
}

extension Decodable {
    public init?(with dictionary: Any?) {
        guard let dictionary = dictionary else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else { return nil }
        do {
            let initialized = try JSONDecoder().decode(Self.self, from: data)
            self = initialized
        } catch {
            let stringData = String(data: data, encoding: .utf8)
            print(stringData ?? "")
            print("JSON serialization failed: ", error)
            return nil
        }
    }
    
    public init?(with data: Data?) {
        guard let data = data else { return nil }
        do {
            let initialized = try JSONDecoder().decode(Self.self, from: data)
            self = initialized
        } catch {
            print("JSON serialization failed: ", error)
            return nil
        }
        
    }
}

// Helper
class DictionaryDecoder {
    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T? where T: Decodable {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let result = try JSONDecoder().decode(type, from: jsonData)
            return result
        } catch {
            print("JSON serialization failed: ", error)
            return nil
        }
    }
}
