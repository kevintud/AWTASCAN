//
//  HomeViewController.swift
//  AWTAScan
//
//  Created by Kevin on 12/31/24.
//

import UIKit

class HomeViewController: UIViewController {
    var loginResponse: LoginResponse? {
        didSet {
            // Update greeting text when loginResponse is set
            if let name = loginResponse?.details.name {
                greetingLabel.text = "Hi \(name)!"
            }
        }
    }
    
    private var errorLabel: ErrorLabel?
    private var isLoading: Bool = false
    private var isSubmitting: Bool = false  // Prevent duplicate submit pushes

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scanView.delegate = self
        setupTapToDismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        scanView.restartScanning()
    }
    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // So other interactions aren't blocked.
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: - UI Elements
    
    private lazy var greetingLabel: CustomLabel = {
        let label = CustomLabel(text: "Hi User!", fontSize: DynamicMultiplier.fontSize(16))
        label.textColor = .darkGray
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        button.setImage(image, for: .normal)
        button.setTitle("Log out", for: .normal)
        button.tintColor = .darkGray
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: DynamicMultiplier.fontSize(16))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(text: "SCAN APP", fontSize: DynamicMultiplier.fontSize(32))
        label.textColor = .black
        return label
    }()
    
    private let scanView: QRScannerView = {
        let view = QRScannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scanLabel: CustomLabel = {
        let label = CustomLabel(text: "SCAN QR CODE", fontSize: DynamicMultiplier.fontSize(16))
        label.textColor = .black
        return label
    }()
    
    private let visitorIDTextField: CustomTextField = {
        let textField = CustomTextField(placeHolder: "Visitor ID Number")
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let submitButton: CustomButton = {
        let button = CustomButton(backgroudColor: .systemBlue, title: "SUBMIT")
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitle("UPLOAD", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DynamicMultiplier.fontSize(14), weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.tintColor = .darkGray
        button.setTitleColor(.darkGray, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: -40)
        button.titleEdgeInsets = UIEdgeInsets(top: 20, left: -40, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Activity indicator to show loading while scanning.
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#dedcdc")
        view.addSubview(greetingLabel)
        view.addSubview(logoutButton)
        view.addSubview(titleLabel)
        view.addSubview(scanView)
        view.addSubview(scanLabel)
        view.addSubview(visitorIDTextField)
        view.addSubview(submitButton)
//        view.addSubview(uploadButton)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DynamicMultiplier.width(15)),
            greetingLabel.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor),
            greetingLabel.heightAnchor.constraint(equalToConstant: DynamicMultiplier.height(20)),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0.05 * view.frame.width),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.02 * view.frame.height),
            logoutButton.heightAnchor.constraint(equalToConstant: 0.03 * view.frame.height),
            
            titleLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 0.03 * view.frame.height),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scanView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0.05 * view.frame.height),
            scanView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanView.widthAnchor.constraint(equalToConstant: 0.5 * view.frame.width),
            scanView.heightAnchor.constraint(equalTo: scanView.widthAnchor),
            
            scanLabel.topAnchor.constraint(equalTo: scanView.bottomAnchor, constant: 0.015 * view.frame.height),
            scanLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            visitorIDTextField.topAnchor.constraint(equalTo: scanLabel.bottomAnchor, constant: 0.05 * view.frame.height),
            visitorIDTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            visitorIDTextField.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            visitorIDTextField.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            submitButton.topAnchor.constraint(equalTo: visitorIDTextField.bottomAnchor, constant: 0.01 * view.frame.height),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 0.5 * view.frame.width),
            submitButton.heightAnchor.constraint(equalToConstant: 0.03 * view.frame.height),
            
//            uploadButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 0.03 * view.frame.height),
//            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            uploadButton.widthAnchor.constraint(equalToConstant: 0.25 * view.frame.width),
//            uploadButton.heightAnchor.constraint(equalToConstant: 0.1 * view.frame.height),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func logoutButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func submitButtonTapped() {
        // Prevent duplicate pushes
        guard !isLoading else { return }
        // Get the delegate ID from the text field.
        guard let delegateID = visitorIDTextField.text, !delegateID.isEmpty else {
            showError(message: "Visitor ID cannot be empty", type: .error)
            return
        }
        isLoading = true
        loadingIndicator.startAnimating()
        handleDelegate(delegateID: delegateID)
    }
    
    @objc private func uploadBUttonTapped() {
        print("submit")
    }
    
    func handleDelegate(delegateID: String) {
        let baseURL = "https://lampawta.com/api/delegate/"
        guard let apiKey = APIKeysManager.apiKey(for: "login_api_key") else {
            print("API key not found")
            return
        }
        
        guard let url = URL(string: "\(baseURL)\(delegateID)?api_key=\(apiKey)") else {
            print("Invalid URL")
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.showError(message: "Delegate not found", type: .error)
                self.isLoading = false
            }
            return
        }
        
        API.get(urlString: url.absoluteString) { [weak self] result in
        guard let self = self else { return }
            switch result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response String:\n\(jsonString)")
                }
                do {
                    let delegateData = try JSONDecoder().decode(DelegateData.self, from: data)
                    print("Decoded Delegate Data:\n\(delegateData)")
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.isLoading = false
                        let infoVC = InformationViewController()
                        infoVC.delegateData = delegateData
                        infoVC.loginResponse = self.loginResponse
                        self.navigationController?.pushViewController(infoVC, animated: true)
                    }
                } catch {
                    print("Error decoding delegate data: \(error)")
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.showError(message: "Delegate not found", type: .error)
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Error fetching delegate data: \(error)")
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.showError(message: "Network error", type: .error)
                    self.isLoading = false
                }
            }
        }
    }
    
    private func showError(message: String, type: ErrorLabel.ErrorType) {
        DispatchQueue.main.async {
            self.errorLabel?.removeFromSuperview()
            self.errorLabel = nil
            
            let errorLabel = ErrorLabel(text: message, type: type)
            self.errorLabel = errorLabel
            self.view.addSubview(errorLabel)
            
            NSLayoutConstraint.activate([
                errorLabel.bottomAnchor.constraint(equalTo: self.visitorIDTextField.topAnchor, constant: -5),
                errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                errorLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
                errorLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func removeErrorLabel() {
        DispatchQueue.main.async {
            self.errorLabel?.removeFromSuperview()
            self.errorLabel = nil
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanView.stopScanning()
    }

    deinit {
        scanView.stopScanning()   // extra safety
    }
    
}

extension HomeViewController: QRScannerViewDelegate {
    func didScan(code qrCode: String) {
        print("Scanned: \(qrCode)")
        handleDelegate(delegateID: qrCode)
    }
}
