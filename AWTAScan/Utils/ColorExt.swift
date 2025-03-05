//
//  ColorExt.swift
//  AWTAScan
//
//  Created by Kevin on 2/13/25.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        // Support both 6-character (RGB) and 8-character (RGBA) hex values
        if formattedHex.count == 6 {
            formattedHex.append("FF") // Assume full opacity if no alpha is provided
        }
        
        guard formattedHex.count == 8 else { return nil }
        
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: formattedHex)
        guard scanner.scanHexInt64(&rgbValue) else { return nil }
        
        let r = CGFloat((rgbValue >> 24) & 0xFF) / 255.0
        let g = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
        let b = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
        let a = CGFloat(rgbValue & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
