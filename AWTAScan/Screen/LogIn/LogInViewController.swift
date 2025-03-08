//
//  LogInViewController.swift
//  AWTAScan
//
//  Created by Kevin on 2/3/25.
//

import UIKit

class LogInViewController: UIViewController, KeyboardHandlerDelegate {
    
    private var keyboardHandler: KeyboardHandler?

    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#dedcdc")
        keyboardHandler = KeyboardHandler(delegate: self)

        setupUI()
        setupTapToDismissKeyboard()
    }
    
    
    lazy var titleLabel: CustomLabel =  {
        let label = CustomLabel(text: "SCAN APP", fontSize: DynamicMultiplier.fontSize(24))
        label.textColor = .black
        return label
    }()
    
    lazy var usernameLabel: CustomLabel = {
        let username = CustomLabel(text: "USERNAME", fontSize: DynamicMultiplier.fontSize(18))
        username.textAlignment = .left
        username.textColor = .darkGray
        return username
    }()
    
    lazy var loginButton: UIButton = {
        let button = CustomButton(backgroudColor: .systemBlue, title: "LOG IN")
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DynamicMultiplier.fontSize(16), weight: .bold)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.cornerRadius = DynamicMultiplier.height(40)/2
        button.layer.masksToBounds = true
        return button
    }()
    lazy var usernameTextField: CustomTextField = {
        let textfield = CustomTextField(placeHolder: "" )
        textfield.font = UIFont.systemFont(ofSize: DynamicMultiplier.fontSize(16))
        return textfield
    }()
   
    private func setupUI() {

        view.addSubview(titleLabel)
        view.addSubview(usernameLabel)
        view.addSubview(loginButton)
        view.addSubview(usernameTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DynamicMultiplier.height(40)),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -DynamicMultiplier.height(40)),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: DynamicMultiplier.height(10)),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalToConstant: DynamicMultiplier.width(250)),
            usernameTextField.heightAnchor.constraint(equalToConstant: DynamicMultiplier.height(40)),
            
            loginButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: DynamicMultiplier.height(20)),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: DynamicMultiplier.width(250)),
            loginButton.heightAnchor.constraint(equalToConstant: DynamicMultiplier.height(40))
        ])
    }
    
    
    @objc func handleLogin() {
        let landingVC = HomeViewController()
        navigationController?.pushViewController(landingVC, animated: true)
    }
    //MARK: Keyboard
    
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func keyboardWillShow(height: CGFloat) {
        guard let activeTextField = view.findFirstResponder() as? UITextField else { return }
        
        let textFieldBottom = activeTextField.convert(activeTextField.bounds, to: view).maxY
        let keyboardTop = view.frame.height - height
        let overlap = textFieldBottom - keyboardTop
        
        if overlap > 0 {
            view.frame.origin.y = CGFloat(-overlap - 20) // Move up with padding
        }
    }

    // MARK: - Dismiss Keyboard on Tap
    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Extension to Find First Responder
extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
