//
//  File.swift
//  
//
//  Created by Borko Tomic on 25.12.20..
//

import Foundation

struct FileHelper {
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func move(from source: URL, to destination: URL) -> Bool  {
        return (try? FileManager.default.moveItem(at: source, to: destination)) != nil
    }
    
    static func getLocalUrl(for messageId: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent("message_\(messageId).m4a")
    }
    
    static func recordingExists(for messageId: String) -> Bool {
        return FileManager.default.fileExists(atPath: FileHelper.getLocalUrl(for: messageId).path)
    }
    
    static var dateformatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH-mm-ss-MM-dd-yyyy"
        return dateFormatter
    }
}
