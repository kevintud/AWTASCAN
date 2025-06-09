//
//  LogInViewController.swift
//  AWTAScan
//
//  Created by Kevin on 2/3/25.
//

import UIKit

class LogInViewController: UIViewController, KeyboardHandlerDelegate {

    private var keyboardHandler: KeyboardHandler?
    private var errorLabel: ErrorLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#dedcdc")
        keyboardHandler = KeyboardHandler(delegate: self)
        
        setupUI()
        setupTapToDismissKeyboard()
        
        // Set text field delegate to remove error when editing begins.
        usernameTextField.delegate = self
    }
    
    // Reset button state when the view appears (e.g., after logout).
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.isEnabled = true
        loginButton.backgroundColor = .systemBlue
    }
    
    lazy var titleLabel: CustomLabel = {
        let label = CustomLabel(text: "SCAN APP", fontSize: DynamicMultiplier.fontSize(24))
        label.textColor = .black
        return label
    }()
    
    lazy var usernameLabel: CustomLabel = {
        let label = CustomLabel(text: "USERNAME", fontSize: DynamicMultiplier.fontSize(18))
        label.textAlignment = .left
        label.textColor = .darkGray
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let button = CustomButton(backgroudColor: .systemBlue, title: "LOG IN")
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DynamicMultiplier.fontSize(16), weight: .bold)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.cornerRadius = DynamicMultiplier.height(40) / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var usernameTextField: CustomTextField = {
        let textfield = CustomTextField(placeHolder: "")
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
    
    private func showError(message: String, type: ErrorLabel.ErrorType) {
        DispatchQueue.main.async {
            // Update text if an error label already exists; otherwise, create one.
            if let existingError = self.errorLabel {
                existingError.text = message
            } else {
                let errorLabel = ErrorLabel(text: message, type: type)
                self.errorLabel = errorLabel
                self.view.addSubview(errorLabel)
                
                NSLayoutConstraint.activate([
                    errorLabel.bottomAnchor.constraint(equalTo: self.usernameLabel.topAnchor, constant: -5),
                    errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    errorLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
                    errorLabel.heightAnchor.constraint(equalToConstant: 30)
                ])
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func removeErrorLabel() {
        DispatchQueue.main.async {
            self.errorLabel?.removeFromSuperview()
            self.errorLabel = nil
        }
    }
    
    @objc func handleLogin() {
        // Disable the button immediately to prevent duplicate taps.
        loginButton.isEnabled = false
        loginButton.backgroundColor = .lightGray
        
        guard let userName = usernameTextField.text, !userName.isEmpty else {
            showError(message: "Username is empty", type: .error)
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemBlue
            return
        }
        
        guard let apiKey = APIKeysManager.apiKey(for: "login_api_key") else {
            showError(message: "API key not found", type: .error)
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemBlue
            return
        }
        
        let urlString = "https://lampawta.com/api/login?api_key=\(apiKey)"
        let parameters: [String: Any] = ["username": userName]
        
        API.post(urlString: urlString, parameters: parameters) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw API response: \(rawResponse)")
                }
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = jsonObject["status"] as? String,
                   status == "found" {
                   
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.removeErrorLabel()
                            let homeVC = HomeViewController()
                            homeVC.loginResponse = loginResponse
                            self.navigationController?.pushViewController(homeVC, animated: true)
                           
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.showError(message: "Error decoding data", type: .error)
                            self.loginButton.isEnabled = true
                            self.loginButton.backgroundColor = .systemBlue
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showError(message: "USERNAME NOT VALID", type: .error)
                        self.loginButton.isEnabled = true
                        self.loginButton.backgroundColor = .systemBlue
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showError(message: "Network error", type: .error)
                    self.loginButton.isEnabled = true
                    self.loginButton.backgroundColor = .systemBlue
                }
            }
        }

    }
    
    // MARK: Keyboard Handling
    
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func keyboardWillShow(height: CGFloat) {
        guard let activeTextField = view.findFirstResponder() as? UITextField else { return }
        let textFieldBottom = activeTextField.convert(activeTextField.bounds, to: view).maxY
        let keyboardTop = view.frame.height - height
        let overlap = textFieldBottom - keyboardTop
        if overlap > 0 {
            view.frame.origin.y = CGFloat(-overlap - 20)
        }
    }
    
    // MARK: Dismiss Keyboard
    
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
    
    // Remove error label when the user starts editing.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        removeErrorLabel()
    }
}

// MARK: - Extension to Find First Responder

extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        for subview in subviews {
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
