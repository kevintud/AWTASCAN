//
//  Untitled.swift
//  AWTAScan
//
//  Created by Kevin on 2/3/25.
//


import UIKit
class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.text = text
        self.textAlignment = .center
        self.font = UIFont(name: "Avenir", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
}
