//
//  DynamicMultiplier.swift
//  AWTAScan
//
//  Created by Kevin on 3/8/25.
//

import UIKit

class DynamicMultiplier {
    
    static let baseScreenWidth: CGFloat = 375  // Reference width (iPhone 11)
    static let baseScreenHeight: CGFloat = 812 // Reference height (iPhone 11)
    
    static var screenWidthMultiplier: CGFloat {
        return UIScreen.main.bounds.width / baseScreenWidth
    }
    
    static var screenHeightMultiplier: CGFloat {
        return UIScreen.main.bounds.height / baseScreenHeight
    }
    
    static func fontSize(_ baseSize: CGFloat) -> CGFloat {
        return baseSize * screenWidthMultiplier
    }
    
    static func width(_ baseWidth: CGFloat) -> CGFloat {
        return baseWidth * screenWidthMultiplier
    }
    
    static func height(_ baseHeight: CGFloat) -> CGFloat {
        return baseHeight * screenHeightMultiplier
    }
}
