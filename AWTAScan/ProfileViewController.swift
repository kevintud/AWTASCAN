//
//  ProfileViewController.swift
//  AWTAScan
//
//  Created by Kevin Lloyd Tud on 10/17/23.
//

import UIKit

class ProfileViewController: UIViewController {
    var fetchedData: [String: Any]?
    
    var sampleInt:Int?
    
    private lazy var wallpaperImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wallpaper")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var uuIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var localChurchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clusterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var registrationTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var dateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var pickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to Select a Day"
        label.textColor = .gray
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var altarWorkerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Specify the name of the altar worker or witnesses"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(submitBtnClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bgView, detailView, dateView])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add tap gesture recognizer to dismiss the picker view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    private let choices1 = ["Day 1", "Day 2", "Day 3", "Day 4"]
    
    var pickerView1 = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        displayFetchedData()
        setupPickerView()
        
        
        //MARK: - dismisskeyboard
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        
        let tapGesturePicker = UITapGestureRecognizer(target: self, action: #selector(pickerLabelTapped))
        pickerLabel.isUserInteractionEnabled = true
        pickerLabel.addGestureRecognizer(tapGesturePicker)
        
       
    }
    
    
    private func setupUI() {
        view.addSubview(stackView)
        bgView.addSubview(wallpaperImageView)
        detailView.addSubview(fullNameLabel)
        detailView.addSubview(uuIdLabel)
        detailView.addSubview(localChurchLabel)
        detailView.addSubview(clusterLabel)
        detailView.addSubview(registrationTypeLabel)
        dateView.addSubview(pickerLabel)
        dateView.addSubview(altarWorkerTextField)
        dateView.addSubview(submitButton)
        view.addSubview(overlayView)
        view.bringSubviewToFront(overlayView)
          NSLayoutConstraint.activate([
              overlayView.topAnchor.constraint(equalTo: view.topAnchor),
              overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
              stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
              stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
              stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
              
              wallpaperImageView.topAnchor.constraint(equalTo: bgView.topAnchor),
              wallpaperImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
              wallpaperImageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
              wallpaperImageView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
              
              pickerLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 10),
              pickerLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 10),
              pickerLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -10),
              pickerLabel.heightAnchor.constraint(equalToConstant: 40),
              
              altarWorkerTextField.topAnchor.constraint(equalTo: pickerLabel.bottomAnchor, constant: 10),
              altarWorkerTextField.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 10),
              altarWorkerTextField.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -10),
              altarWorkerTextField.heightAnchor.constraint(equalToConstant: 40),
              
              submitButton.topAnchor.constraint(equalTo: altarWorkerTextField.bottomAnchor, constant: 20),
              submitButton.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
              submitButton.widthAnchor.constraint(equalToConstant: 150),
              submitButton.heightAnchor.constraint(equalToConstant: 40)
              
              
          ])
          
            
        // Detail View Labels Constraints
        let labels = [fullNameLabel, uuIdLabel, localChurchLabel, clusterLabel, registrationTypeLabel]
        for (index, label) in labels.enumerated() {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -10),
                label.topAnchor.constraint(equalTo: index == 0 ? detailView.topAnchor : labels[index - 1].bottomAnchor, constant: 5)
            ])
        }
    }
    
    private func setupPickerView() {
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView1.translatesAutoresizingMaskIntoConstraints = false
        pickerView1.isHidden = true
        
        view.addSubview(pickerView1)
        
        
        NSLayoutConstraint.activate([
            pickerView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickerView1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView1.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func checkConditionsAndUpdateSubmitButton() {
        // Check the conditions and enable or disable the submit button accordingly
        submitButton.isEnabled = !(altarWorkerTextField.text ?? "").isEmpty && choices1.contains(pickerLabel.text ?? "")
    }
    
    @objc func dismissPickerView() {
        pickerView1.isHidden = true
        overlayView.isHidden = true
    }
    
    @objc func pickerLabelTapped() {
        pickerView1.isHidden .toggle()
        overlayView.isHidden = pickerView1.isHidden
        if !pickerView1.isHidden {
            NSLayoutConstraint.activate([
                pickerView1.centerXAnchor.constraint(equalTo: pickerLabel.centerXAnchor),
                pickerView1.topAnchor.constraint(equalTo: pickerLabel.bottomAnchor, constant: 10),
                pickerView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                pickerView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
            ])
        }
        self.view.endEditing(true)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        // Present the confirmation alert
        let alert = UIAlertController(title: "Confirm Action", message: "Are you sure you want to proceed?", preferredStyle: .alert)
        
        // Add "OK" action, which will proceed with the submit logic
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.proceedWithSubmission()
        }))
        
        // Add "Cancel" action, which will dismiss the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func proceedWithSubmission() {
        if let altarWorkerText = altarWorkerTextField.text, !altarWorkerText.isEmpty,
           let selectedDay = pickerLabel.text, choices1.contains(selectedDay) {
            // All conditions are met, enable the submit button
            submitButton.isEnabled = true
            
            if let uuIdText = uuIdLabel.text {
                // Replace spaces and special characters in the uuIdText to make it URL-safe
                if let encodedUuid = uuIdText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    let urlString = "https://lampawta.com/api/delegate/hg/\(encodedUuid)?api_key=bdf0bf18-54cf-4aca-86ec-a03b77c02264&fbclid=IwAR2GaXP92ajc8Swyo_SQGYHj9Jx6uR87LyjlFSELi5EDTJOhZYOIdwmexn0"
                    
                    if let url = URL(string: urlString) {
                        // Create your request
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        // Your parameters
                        let parameters = ["day": selectedDay, "notes": altarWorkerText]
                        do {
                            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                        } catch let error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        // Create data task
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data, error == nil else {
                                print(error?.localizedDescription ?? "No data")
                                DispatchQueue.main.async {
                                    self.showAlert(title: "Error", message: "Failed to make the request")
                                }
                                return
                            }
                            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let responseJSON = responseJSON as? [String: Any] {
                                print(responseJSON)
                                DispatchQueue.main.async {
                                    if responseJSON["error"] is String {
                                        self.showAlert(title: "Duplicate Entry", message: "Delegate has already\n received the Holy Ghost." )
                                    } else {
                                        self.showAlert(title: "Success", message: "Record has been updated.")
                                    }
                                }
                            }
                        }
                        
                        task.resume()
                        
                    } else {
                        print("Invalid URL")
                    }
                } else {
                    print("Failed to encode UUID for URL")
                }
            } else {
                print("uuIdLabel text is nil")
            }
        } else {
            // Conditions not met, disable the submit button
            submitButton.isEnabled = false
            print("Submit button disabled")
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    
    
    
    
    @objc func keyboardWillShow(notification: Notification) {
        if altarWorkerTextField != nil {
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info [UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            // Calculate the position of the text field in the main view
            let textFieldFrameInSuperview = self.view.convert(self.altarWorkerTextField.frame, from: self.altarWorkerTextField.superview)
            
            let bottom = textFieldFrameInSuperview.origin.y + textFieldFrameInSuperview.size.height
            let top = self.view.frame.size.height - keyboardFrame.size.height
            
            let offset = textFieldFrameInSuperview.size.height / 2
            
            if bottom > top {
                self.view.frame.origin.y = 0 - (bottom - top + offset)
            }
        }
    }
    
    
    //MARK: - dismisskeyboard
    
    
    @objc func keyBoardWillHide(notification: Notification){
        self.view.frame.origin.y = 0
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func displayFetchedData() {
        if let data = fetchedData {
            fullNameLabel.text = "Full Name: \(data["fullname"] as? String ?? "N/A")"
            //            uuidLabel.text = "UUID: \(data["uuid"] as? String ?? "N/A")"
            localChurchLabel.text = "Local Church: \(data["local_church"] as? String ?? "N/A")"
            clusterLabel.text = "Cluster Group: \(data["cluster_group"] as? String ?? "N/A")"
            registrationTypeLabel.text = "Registration Type: \(data["registration_type"] as? String ?? "N/A")"
        }
    }
    
    
    //MARK: - de alloc
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Update your condition with updatedText
        submitButton.isEnabled = !updatedText.isEmpty && choices1.contains(pickerLabel.text ?? "")
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.altarWorkerTextField = textField
        //        checkConditionsAndUpdateSubmitButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: choices1[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerLabel.text = choices1[row]
        pickerView1.isHidden = true
        overlayView.isHidden = true
        checkConditionsAndUpdateSubmitButton()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices1[row]
    }
    
}

extension ProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices1.count
    }
}



//        if let data = fetchedData {
//            uuIdLabel.text = data["uuid"] as? String
//            fullNameLabel.text = data["fullname"] as? String
//            localChurchLabel.text = data["local_church"] as? String
//            registrationTypeLabel.text = data["registration_type"] as? String
//            clusterLabel.text = data["cluster_group"] as? String
//            print(fetchedData)
//
//        }
//        fullNameLabel.text = "\(fullNameLabel.text ?? "")\n\(registrationTypeLabel.text ?? "")"
//
//        bgView.layer.cornerRadius = 10
//        bgView.layer.cornerRadius = 10
//        detailView.layer.cornerRadius = 10
//
//        //TextField Adjusting Keyboard
//        self.altarWorkerTextField.delegate = self
//        altarWorkerTextField.layer.borderWidth = 1
//        altarWorkerTextField.layer.borderColor = UIColor.lightGray.cgColor
//        altarWorkerTextField.layer.cornerRadius = 5
//        altarWorkerTextField.placeholder = "Specify the name of the altar worker or witnesses"
//
//        // Change placeholder text color to black
//        altarWorkerTextField.attributedPlaceholder = NSAttributedString(string: altarWorkerTextField.placeholder != nil ? altarWorkerTextField.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//
//        //MARK: - PickerView
//
//        pickerView1.delegate = self
//        pickerView1.dataSource = self
//        pickerView1.isHidden = true
//        pickerView1.backgroundColor = .white
//        self.view.addSubview(pickerView1)
//
//        // Set up constraints for the picker (replace these with your desired constraints)
//        pickerView1.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            pickerView1.centerXAnchor.constraint(equalTo: self.pickerLabel.centerXAnchor),
//            pickerView1.centerYAnchor.constraint(equalTo: self.pickerLabel.centerYAnchor)
//        ])
//
//                pickerView.layer.borderWidth = 1
//                pickerView.layer.borderColor = UIColor.lightGray.cgColor
//                pickerView.layer.cornerRadius = 5
//                dateView.layer.cornerRadius = 5
//                submitBtn.setTitleColor(UIColor.white, for: .normal)
//                //        submitBtn.layer.borderWidth = 1
//                submitBtn.layer.cornerRadius = 5
//                submitBtn.layer.borderColor = UIColor.darkGray.cgColor
//
