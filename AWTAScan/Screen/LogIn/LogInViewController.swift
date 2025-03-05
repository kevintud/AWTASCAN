//
//  LogInViewController.swift
//  AWTAScan
//
//  Created by Kevin on 2/3/25.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#dedcdc")

        setupUI()
    }
    
    
    lazy var titleLabel: CustomLabel =  {
        let label = CustomLabel(text: "SCAN APP", fontSize: 24)
        return label
    }()
    
    lazy var usernameLabel: CustomLabel = {
        let username = CustomLabel(text: "Username", fontSize: 18)
        username.textAlignment = .left
        return username
    }()
    
    lazy var loginButton: UIButton = {
        let button = CustomButton(backgroudColor: .systemBlue, title: "Login")
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    lazy var usernameTextField: CustomTextField = {
        let textfield = CustomTextField(placeHolder: "Enter your username" )
        return textfield
    }()
   
    private func setupUI() {

        view.addSubview(titleLabel)
        view.addSubview(usernameLabel)
        view.addSubview(loginButton)
        view.addSubview(usernameTextField)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalToConstant: 250),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    @objc func handleLogin() {
        let landingVC = HomeViewController()
        navigationController?.pushViewController(landingVC, animated: true)
    }
    
    
}
