//
//  ExtensionString.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import Foundation

extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }

    func getPhoneFormat() -> String {
        return self.filter("+0123456789".contains)
    }
 }
