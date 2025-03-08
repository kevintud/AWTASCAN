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
            
            setupUI()
        }
        
        //MARK: Setter & Getter
        
        //uncomment if need to use the
        //    private lazy var backgroundImageView: UIImageView = {
        //        let imageView = UIImageView()
        //        imageView.image = UIImage(named: "AWTA-2024-App")
        //        imageView.contentMode = .scaleAspectFill
        //        imageView.clipsToBounds = true
        //        return imageView
        //    }()
        
        
        
        private lazy var greetingLabel: CustomLabel = {
            let label = CustomLabel(text: "Hi Jamie Birot!", fontSize: DynamicMultiplier.fontSize(16))
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
//            label.font  = .boldSystemFont(ofSize: 32)
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
            let textField = CustomTextField(placeHolder: "Visitor ID Number" )
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
            
            // Set icon
            let image = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            
            // Set text below icon
            button.setTitle("UPLOAD", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: DynamicMultiplier.fontSize(14), weight: .medium)
            button.titleLabel?.textAlignment = .center
            
            // Styling
            button.tintColor = .darkGray // Icon color
            button.setTitleColor(.darkGray, for: .normal) // Text color
            
            // StackView-like behavior
            button.imageEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: -40)
            button.titleEdgeInsets = UIEdgeInsets(top: 20, left: -40, bottom: 0, right: 0)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        
        //MARK: Private method
        func setupUI() {
            view.backgroundColor = UIColor(hex: "#dedcdc")
            //        view.
            view.addSubview(greetingLabel)
            view.addSubview(logoutButton)
            view.addSubview(titleLabel)
            view.addSubview(scanView)
            view.addSubview(scanLabel)
            view.addSubview(visitorIDTextField)
            view.addSubview(submitButton)
            view.addSubview(uploadButton)
            
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
                
                visitorIDTextField.topAnchor.constraint(equalTo: scanLabel.bottomAnchor, constant: 0.025 * view.frame.height),
                visitorIDTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                visitorIDTextField.widthAnchor.constraint(equalToConstant: 0.7 * view.frame.width),
                visitorIDTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height),
                
                submitButton.topAnchor.constraint(equalTo: visitorIDTextField.bottomAnchor, constant: 0.03 * view.frame.height),
                submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                submitButton.widthAnchor.constraint(equalToConstant: 0.5 * view.frame.width),
                submitButton.heightAnchor.constraint(equalToConstant: 0.06 * view.frame.height),
                
                uploadButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 0.03 * view.frame.height),
                uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                uploadButton.widthAnchor.constraint(equalToConstant: 0.25 * view.frame.width),
                uploadButton.heightAnchor.constraint(equalToConstant: 0.1 * view.frame.height),
                
                
            ])
            
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
        
        @objc private func logoutButtonTapped() {
            navigationController?.popViewController(animated: true)
        }
        
        @objc private func submitButtonTapped() {
            print("submit")
        }
        @objc private func uploadBUttonTapped() {
            print("submit")
        }
        
    }
