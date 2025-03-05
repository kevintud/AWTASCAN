//
//  CustomButton.swift
//  LAMP APP
//
//  Created by Goin-Keivn on 3/30/24.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroudColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroudColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        layer.cornerRadius = 8
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
    }
    
    func set(backGroungColor: UIColor, title: String) {
        self.backgroundColor = backGroungColor
        setTitle(title, for: .normal)
    }
}
