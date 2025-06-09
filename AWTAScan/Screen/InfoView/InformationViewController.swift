//
//  InformationViewController.swift
//  AWTAScan
//
//  Created by Kevin on 3/10/25.
//

import UIKit

class InformationViewController: UIViewController {
    
    var delegateData: DelegateData? {
        didSet {
            updateDelegateInfo()
        }
    }
    
    var loginResponse: LoginResponse? {
        didSet {
            if let name = loginResponse?.details.name {
                greetingLabel.text = "Hi \(name)!"
            }
        }
    }
    
    // Choices for the picker.
    private let choices1 = ["Day 1", "Day 2", "Day 3", "Day 4"]
    
    // MARK: - UI Elements
    
    private let greetingLabel: CustomLabel = {
        let label = CustomLabel(text: "Hi Jamie Birot!", fontSize: DynamicMultiplier.fontSize(16))
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        button.setImage(image, for: .normal)
        button.setTitle(" Log out", for: .normal)
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: CustomLabel = {
        let label = CustomLabel(text: "Erwin Sta. Rosa", fontSize: DynamicMultiplier.fontSize(14))
        label.textAlignment = .center
        label.textColor = .darkGray
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let visitorIDLabel: CustomLabel = {
        let label = CustomLabel(text: "Visitor ID Number", fontSize: DynamicMultiplier.fontSize(14))
        label.textAlignment = .center
        label.textColor = .darkGray
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Additional delegate info labels.
    private lazy var registrationTypeLabel: CustomLabel = {
        let label = CustomLabel(text: "Registration Type: ", fontSize: DynamicMultiplier.fontSize(14))
        label.textAlignment = .center
        label.textColor = .darkGray
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var localChurchLabel: CustomLabel = {
        let label = CustomLabel(text: "Local Church: ", fontSize: DynamicMultiplier.fontSize(14))
        label.textAlignment = .center
        label.textColor = .darkGray
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clusterGroupLabel: CustomLabel = {
        let label = CustomLabel(text: "Cluster Group: ", fontSize: DynamicMultiplier.fontSize(14))
        label.textAlignment = .center
        label.textColor = .darkGray
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var attendingOptionLabel: CustomLabel = {
        let label = CustomLabel(text: "Attending Option: ", fontSize: DynamicMultiplier.fontSize(14))
        label.textAlignment = .center
        label.textColor = .darkGray
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // New: Instruction label for day selection.
    private let instructionLabel: CustomLabel = {
        let label = CustomLabel(text: "Tap below to select the day", fontSize: DynamicMultiplier.fontSize(18))
        label.font = UIFont.boldSystemFont(ofSize: DynamicMultiplier.fontSize(18))
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Instead, we only use the daySelectionButton and dayPicker.
    private lazy var daySelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap to Select a Day", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: DynamicMultiplier.fontSize(14))
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(daySelectionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dayPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        return picker
    }()
    
    private let confirmButton: CustomButton = {
        let button = CustomButton(backgroudColor: .systemBlue, title: "Confirm")
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let backButton: CustomButton = {
        let button = CustomButton(backgroudColor: .systemRed, title: "Back")
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
    
    // Activity indicator to show loading.
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayPicker.delegate = self
        dayPicker.dataSource = self
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#dedcdc")
        view.addSubview(greetingLabel)
        view.addSubview(logoutButton)
        view.addSubview(titleLabel)

        view.addSubview(nameLabel)
        view.addSubview(visitorIDLabel)
        
        view.addSubview(registrationTypeLabel)
        view.addSubview(localChurchLabel)
        view.addSubview(clusterGroupLabel)
        view.addSubview(attendingOptionLabel)
        
        
        view.addSubview(instructionLabel)
        view.addSubview(daySelectionButton)
        view.addSubview(dayPicker)
        
        view.addSubview(confirmButton)
        view.addSubview(backButton)
        view.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            // Greeting and logout.
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.05 * view.frame.width),
            greetingLabel.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor),
            greetingLabel.heightAnchor.constraint(equalToConstant: DynamicMultiplier.height(20)),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0.05 * view.frame.width),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.02 * view.frame.height),
            
            // Title.
            titleLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 0.02 * view.frame.height),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            // Name label.
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0.08 * view.frame.height),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            nameLabel.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            // Visitor ID label.
            visitorIDLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0.015 * view.frame.height),
            visitorIDLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            visitorIDLabel.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            visitorIDLabel.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            // Additional delegate info labels.
            registrationTypeLabel.topAnchor.constraint(equalTo: visitorIDLabel.bottomAnchor, constant: 0.015 * view.frame.height),
            registrationTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationTypeLabel.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            registrationTypeLabel.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            localChurchLabel.topAnchor.constraint(equalTo: registrationTypeLabel.bottomAnchor, constant: 0.015 * view.frame.height),
            localChurchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            localChurchLabel.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            localChurchLabel.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            clusterGroupLabel.topAnchor.constraint(equalTo: localChurchLabel.bottomAnchor, constant: 0.015 * view.frame.height),
            clusterGroupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clusterGroupLabel.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            clusterGroupLabel.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            attendingOptionLabel.topAnchor.constraint(equalTo: clusterGroupLabel.bottomAnchor, constant: 0.015 * view.frame.height),
            attendingOptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attendingOptionLabel.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            attendingOptionLabel.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            instructionLabel.topAnchor.constraint(equalTo: attendingOptionLabel.bottomAnchor, constant: 0.015 * view.frame.height),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            instructionLabel.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            // Day selection button below the dateReceivedLabel (or directly below attendingOptionLabel if dateReceivedLabel is not shown).
            daySelectionButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 0.02 * view.frame.height),
            daySelectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            daySelectionButton.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            daySelectionButton.heightAnchor.constraint(equalToConstant: 0.04 * view.frame.height),
            
            // UIPickerView below the day selection button.
            dayPicker.topAnchor.constraint(equalTo: daySelectionButton.bottomAnchor, constant: 0.005 * view.frame.height),
            dayPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayPicker.widthAnchor.constraint(equalToConstant: 0.88 * view.frame.width),
            dayPicker.heightAnchor.constraint(equalToConstant: 0.1 * view.frame.height),
            
            // Confirm button below the picker.
            confirmButton.topAnchor.constraint(equalTo: dayPicker.bottomAnchor, constant: 0.03 * view.frame.height),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 0.5 * view.frame.width),
            confirmButton.heightAnchor.constraint(equalToConstant: 0.03 * view.frame.height),
            
            // Back button below confirm.
            backButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 0.015 * view.frame.height),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 0.5 * view.frame.width),
            backButton.heightAnchor.constraint(equalToConstant: 0.03 * view.frame.height),
            
            // Upload button below back.
            uploadButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0.03 * view.frame.height),
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButton.widthAnchor.constraint(equalToConstant: 0.25 * view.frame.width),
            uploadButton.heightAnchor.constraint(equalToConstant: 0.1 * view.frame.height)
        ])
    }
    
    private func updateDelegateInfo() {
        guard let delegate = delegateData else { return }
        nameLabel.text = delegate.fullname
        registrationTypeLabel.text = "Registration Type: \(delegate.registrationType)"
        localChurchLabel.text = "Local Church: \(delegate.localChurch)"
        clusterGroupLabel.text = "Cluster Group: \(delegate.clusterGroup)"
        attendingOptionLabel.text = "Attending Option: \(delegate.attendingOption)"
        visitorIDLabel.text = "ID#: \(delegate.uuid)"
    }
    
    @objc private func logoutButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func daySelectionButtonTapped() {
        dayPicker.isHidden = !dayPicker.isHidden
    }
    
    @objc private func confirmButtonTapped() {
        guard let selectedDay = daySelectionButton.title(for: .normal),
              selectedDay != "Tap to Select a Day" else {
            return
        }
        
        guard let name = loginResponse?.details.name else {
            print("Login name not available")
            return
        }
        
        // Retrieve the delegate UUID used for the URL path.
        guard let uuid = delegateData?.uuid else {
            print("Delegate UUID not available")
            return
        }
        
        // URL encode the UUID.
        guard let encodedUuid = uuid.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("Error encoding UUID")
            return
        }
        
        // Build the URL string.
        guard let apiKey = APIKeysManager.apiKey(for: "login_api_key") else {
            return
        }
        let urlString = "https://lampawta.com/api/delegate/hg/\(encodedUuid)?api_key=\(apiKey)"
        
        // Build the parameters.
        let parameters = ["day": selectedDay, "notes": name]
        
        API.post(urlString: urlString, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                // Attempt to parse the JSON response.
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let errorMessage = jsonObject["error"] as? String,
                           errorMessage == "This delegate has record already." {
                            self.showMessageLabel(text: "Already Recorded!", type: .error)
                            self.confirmButton.isEnabled = false
                            self.confirmButton.backgroundColor = .lightGray
                        } else if let successMessage = jsonObject["success"] as? String,
                                  successMessage == "Successfully Recorded!" {
   
                            self.showMessageLabel(text: "QR Counted!", type: .success)
                            self.confirmButton.isEnabled = false
                            self.confirmButton.backgroundColor = .lightGray
                        } else {
                            print("Unexpected response: \(jsonObject)")
                        }
                    }

                } else {
                    print("Error parsing JSON response")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showMessageLabel(text: String, type: ErrorLabel.ErrorType) {
        let messageLabel = ErrorLabel(text: text, type: type)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.layer.cornerRadius = 5
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 0.02 * self.view.frame.height),
            messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            messageLabel.widthAnchor.constraint(equalToConstant: 0.5 * self.view.frame.width),
            messageLabel.heightAnchor.constraint(equalToConstant: 0.04 * self.view.frame.height)
        ])
    }

}

extension InformationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices1.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = choices1[row]
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        daySelectionButton.setTitle(choices1[row], for: .normal)
        pickerView.isHidden = true
    }
}
