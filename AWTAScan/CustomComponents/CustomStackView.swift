//
//  CustomStackView.swift
//  LAMP APP
//
//  Created by Goin-Kevin on 4/27/24.
//

import Foundation
import UIKit

class CustomStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        distribution = .fill
        axis = .vertical
        alignment = .center
        spacing = 5
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
