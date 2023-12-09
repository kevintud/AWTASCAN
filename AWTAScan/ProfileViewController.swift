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
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var uuIdLabel: UILabel!
    @IBOutlet weak var localChurchLabel: UILabel!
    @IBOutlet weak var clusterLabel: UILabel!
    @IBOutlet weak var registrationTypeLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var pickerLabel: UILabel!
    let choices1 = ["Day 1", "Day 2", "Day 3", "Day 4"]
    var pickerView1 = UIPickerView()
    
    @IBOutlet weak var altarWorkerTextField: UITextField! = nil
    
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = fetchedData {
            uuIdLabel.text = data["uuid"] as? String
            fullNameLabel.text = data["fullname"] as? String
            localChurchLabel.text = data["local_church"] as? String
            registrationTypeLabel.text = data["registration_type"] as? String
            clusterLabel.text = data["cluster_group"] as? String
        }
        fullNameLabel.text = "\(fullNameLabel.text ?? "")\n\(registrationTypeLabel.text ?? "")"
        
        bgView.layer.cornerRadius = 10
        bgView.layer.cornerRadius = 10
        detailView.layer.cornerRadius = 10
        
        //TextField Adjusting Keyboard
        self.altarWorkerTextField.delegate = self
        altarWorkerTextField.layer.borderWidth = 1
        altarWorkerTextField.layer.borderColor = UIColor.lightGray.cgColor
        altarWorkerTextField.layer.cornerRadius = 5
        altarWorkerTextField.placeholder = "Specify the name of the altar worker or witnesses"
        
        // Change placeholder text color to black
        altarWorkerTextField.attributedPlaceholder = NSAttributedString(string: altarWorkerTextField.placeholder != nil ? altarWorkerTextField.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //MARK: - dismisskeyboard
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        //MARK: - PickerView
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView1.isHidden = true
        self.view.addSubview(pickerView1)
        
        // Set up constraints for the picker (replace these with your desired constraints)
        pickerView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView1.centerXAnchor.constraint(equalTo: self.pickerLabel.centerXAnchor),
            pickerView1.centerYAnchor.constraint(equalTo: self.pickerLabel.centerYAnchor)
        ])
        
        let tapGesturePicker = UITapGestureRecognizer(target: self, action: #selector(pickerLabelTapped))
        pickerLabel.isUserInteractionEnabled = true
        pickerLabel.addGestureRecognizer(tapGesturePicker)
        
        pickerView.layer.borderWidth = 1
        pickerView.layer.borderColor = UIColor.lightGray.cgColor
        pickerView.layer.cornerRadius = 5
        dateView.layer.cornerRadius = 5
        submitBtn.setTitleColor(UIColor.white, for: .normal)
//        submitBtn.layer.borderWidth = 1
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func checkConditionsAndUpdateSubmitButton() {
        // Check the conditions and enable or disable the submit button accordingly
        submitBtn.isEnabled = !(altarWorkerTextField.text ?? "").isEmpty && choices1.contains(pickerLabel.text ?? "")
    }
    
    
    
    @objc func pickerLabelTapped() {
        pickerView1.isHidden = false // Show the picker when the label is tapped
        self.view.endEditing(true)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if let altarWorkerText = altarWorkerTextField.text, !altarWorkerText.isEmpty,
           let selectedDay = pickerLabel.text, choices1.contains(selectedDay) {
            // All conditions are met, enable the submit button
            submitBtn.isEnabled = true
            
            if let uuIdText = uuIdLabel.text {
                // Replace spaces and special characters in the uuIdText to make it URL-safe
                if let encodedUuid = uuIdText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    let urlString = "https://online.lampawta.com/api/delegate/hg/\(encodedUuid)?api_key=bdf0bf18-54cf-4aca-86ec-a03b77c02264&fbclid=IwAR2GaXP92ajc8Swyo_SQGYHj9Jx6uR87LyjlFSELi5EDTJOhZYOIdwmexn0"
                    
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
                                    if let errorMessage = responseJSON["error"] as? String {
                                        self.showAlert(title: "Error", message: errorMessage)
                                    } else {
                                        self.showAlert(title: "Success", message: "Record Updated")
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
            submitBtn.isEnabled = false
            print("Submit button disabled")
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
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
        submitBtn.isEnabled = !updatedText.isEmpty && choices1.contains(pickerLabel.text ?? "")
        
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
        pickerView1.isHidden = true // Hide the picker after a choice is selected
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

