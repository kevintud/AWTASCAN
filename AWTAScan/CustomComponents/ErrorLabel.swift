//
//  ErrorLabel.swift
//  AWTAScan
//
//  Created by Kevin on 3/14/25.
//

import UIKit

class ErrorLabel: UILabel {
    
    enum ErrorType {
        case error
        case success
        case warning
        case info
    }
    
    init(text: String, type: ErrorType) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: DynamicMultiplier.fontSize(12))
        self.textColor = .white
        self.textAlignment = .center
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        
        // Set background color based on error type
        switch type {
        case .error:
            self.backgroundColor = .systemRed
        case .success:
            self.backgroundColor = .systemGreen
        case .warning:
            self.backgroundColor = .systemOrange
        case .info:
            self.backgroundColor = .systemBlue
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

