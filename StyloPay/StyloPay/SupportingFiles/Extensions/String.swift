//
//  String.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 09/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import Foundation
import UIKit

public extension String{
    
    var length: Int {
        return self.count
    }

    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func makeURL() -> URL? {
        let trimmed = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: trimmed ?? "") else {
            return nil
        }
        return url
    }
    
    func toDateString( inputDateFormat inputFormat  : String,  ouputDateFormat outputFormat  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date!)
    }
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    static func random(length: Int = 10) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }

}
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        if #available(iOS 10.2, *) {
            return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
        } else {
            return false
            // Fallback on earlier versions
        }
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { if #available(iOS 10.2, *) {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    } else {
        return false
        // Fallback on earlier versions
        }
        return false
    }



    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}
