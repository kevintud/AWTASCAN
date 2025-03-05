//
//  HomeViewController.swift
//  AWTAScan
//
//  Created by Kevin on 12/31/24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        setupUI()
    }
    
    //MARK: Setter & Getter
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AWTA-2024-App")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    private lazy var scanQRButton: CustomButton = {
        let button = CustomButton(backgroudColor: .white, title: "Scan QR Code")
        button.addTarget(self, action: #selector(scanQRButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var enterIDButton: CustomButton = {
        let button = CustomButton(backgroudColor: .white, title: "Enter ID#")
        button.addTarget(self, action: #selector(enterIDButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    //MARK: Private method
    func setupUI() {
//        view.addSubview(backgroundImageView)
//        
//        backgroundImageView.isUserInteractionEnabled = false
//        view.addSubview(scanQRButton)
//        view.addSubview(enterIDButton)
//        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
//        scanQRButton.translatesAutoresizingMaskIntoConstraints = false
//        enterIDButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        let buttonWidth = view.frame.width * 0.6
//        let buttonHeight = view.frame.height * 0.1
//        
//        //Set up contraints
//        
//        NSLayoutConstraint.activate([
//            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            scanQRButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            scanQRButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            scanQRButton.widthAnchor.constraint(equalToConstant: buttonWidth),
//            scanQRButton.heightAnchor.constraint(equalToConstant: buttonHeight),
//            
//            
//            enterIDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            enterIDButton.topAnchor.constraint(equalTo: scanQRButton.bottomAnchor, constant: 20),
//            enterIDButton.widthAnchor.constraint(equalToConstant: buttonWidth),
//            enterIDButton.heightAnchor.constraint(equalToConstant: buttonHeight)
//            
//        ])
    }
    
    @objc private func scanQRButtonTapped() {
        let scannerVC = ViewController()
        navigationController?.pushViewController(scannerVC, animated: true)
    }
    
    @objc private func enterIDButtonTapped() {
        print("push")
        let scannerVC = ManualTypeViewController()
        self.navigationController?.pushViewController(scannerVC, animated: true)
//        present(scannerVC, animated: true)
    }
    

}
