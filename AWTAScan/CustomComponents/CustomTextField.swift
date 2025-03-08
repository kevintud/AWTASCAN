//
//  CustomTextField.swift
//  LAMP APP
//
//  Created by Goin-Keivn on 3/26/24.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        self.placeholder = placeHolder
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .roundedRect
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        textColor = .black
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .white
        autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: DynamicMultiplier.fontSize(14))
            
            ]
            
        )
    }
    
}
