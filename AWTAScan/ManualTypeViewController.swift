//
//  ManualTypeViewController.swift
//  AWTAScan
//
//  Created by Kevin Lloyd Tud on 12/8/23.
//

import UIKit
import Network

class ManualTypeViewController: UIViewController, UITextFieldDelegate {
    
    var fetchedData: [String: Any]?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "AWTA-2024-App")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "2024icon")
        imageView.contentMode = .scaleAspectFit // Change to fit image better
        imageView.clipsToBounds = true
        return imageView
    }()
    private let lampIdTextFeild: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = textField.frame.width * 0.03
        textField.placeholder = "Enter LAMPID #"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    // Example Label
    private let exampleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        let attributedText = NSMutableAttributedString(
            string: "Example:\n",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]
        )
        attributedText.append(NSAttributedString(
            string: "LAMP00001 for Member\n",
            attributes: [.foregroundColor: UIColor.yellow, .font: UIFont.systemFont(ofSize: 14)]
        ))
        attributedText.append(NSAttributedString(
            string: "GUEST0001 for Guest",
            attributes: [.foregroundColor: UIColor.yellow, .font: UIFont.systemFont(ofSize: 14)]
        ))
        label.attributedText = attributedText
        return label
    }()
    
    private let submitIdBtn: CustomButton = {
        let button = CustomButton()
        button.setTitle("Submit ID", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 69/255, green: 171/255, blue: 168/255, alpha: 1)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = button.frame.width * 0.03
        button.addTarget(self, action: #selector (submitIdBtnClicked), for: .touchUpInside)
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        submitIdBtn.isEnabled = false
        
        // Set up text field placeholder color
        if let placeholder = lampIdTextFeild.placeholder {
            lampIdTextFeild.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
        
        // Add target for text field changes
        lampIdTextFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSubmitButtonState()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateSubmitButtonState()
    }
    
    
    //MARK: Private Function
    
    func setUpUI(){
        view.addSubview(backgroundImageView)
        view.addSubview(logoImageView)
        view.addSubview(lampIdTextFeild)
        view.addSubview(exampleLabel)
        view.addSubview(submitIdBtn)
        lampIdTextFeild.delegate = self
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            lampIdTextFeild.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            lampIdTextFeild.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lampIdTextFeild.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            lampIdTextFeild.heightAnchor.constraint(equalToConstant: 60),
            
            exampleLabel.topAnchor.constraint(equalTo: lampIdTextFeild.bottomAnchor, constant: 10),
            exampleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            exampleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            exampleLabel.heightAnchor.constraint(equalToConstant: 80),
            
            // Submit Button Constraints
            submitIdBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            submitIdBtn.topAnchor.constraint(equalTo: exampleLabel.bottomAnchor, constant: 30),
            submitIdBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            submitIdBtn.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    func updateSubmitButtonState() {
        // Check if the current text could be valid (e.g., starts with LAMP or GUEST and has numbers)
        if let text = lampIdTextFeild.text, isPartialValidLampID(text) {
            submitIdBtn.isEnabled = true
            submitIdBtn.backgroundColor = UIColor(red: 43/255, green: 125/255, blue: 151/255, alpha: 1.0)  // #2B7D97
        } else {
            submitIdBtn.isEnabled = false
            //            submitIdBtn.backgroundColor = .lightGray
        }
    }
    
    
    @IBAction func submitIdBtnClicked(_ sender: UIButton) {
        submitIdBtn.isEnabled = false
        
        //uncomment if there is a api ready
        
        //        if let id = lampIdTextFeild.text {
        //            let formattedID = formatLampID(id)
        //            if isValidLampID(formattedID) {
        //                fetchData(delegateID: formattedID)
        //            } else {
        //                print("Error")
        //                submitIdBtn.isEnabled = true  // Enable the button in case of an error
        //            }
        //        }
        
        ///Comment if api is ready
        if let id = lampIdTextFeild.text {
            let formattedID = formatLampID(id)
            if isValidLampID(formattedID) {
                // Use mock data directly
                let mockData: [String: Any] = [
                    "uuid": "12345-ABCDE",
                    "fullname": "Kevin",
                    "local_church": "Muntinlupa",
                    "registration_type": formattedID.hasPrefix("LAMP") ? "Member" : "Guest",
                    "cluster_group": "SP4"
                ]
                
                // Assign mock data
                self.fetchedData = mockData
                let profileVC = ProfileViewController()
                profileVC.fetchedData = fetchedData
                self.navigationController?.pushViewController(profileVC, animated: true)
            } else {
                print("Invalid ID format")
                submitIdBtn.isEnabled = true  // Re-enable the button
            }
        }
        
    }
    
    // This function checks if the text partially matches a valid LAMP or GUEST ID
    func isPartialValidLampID(_ lampID: String) -> Bool {
        let partialLampIDRegex = "^(lamp\\d*)|(guest\\d*)$"
        let partialLampIDTest = NSPredicate(format: "SELF MATCHES[c] %@", partialLampIDRegex)
        return partialLampIDTest.evaluate(with: lampID)
    }
    
    func isValidLampID(_ lampID: String) -> Bool {
        // Validate if the formatted string starts with LAMP or GUEST and has the correct number format
        let lampIDRegex = "(LAMP\\d{5}$)|(GUEST\\d{4}$)"
        let lampIDTest = NSPredicate(format: "SELF MATCHES %@", lampIDRegex)
        return lampIDTest.evaluate(with: lampID)
    }
    
    func formatLampID(_ id: String) -> String {
        // Separate numeric and non-numeric parts
        let components = id.components(separatedBy: CharacterSet.decimalDigits.inverted)
        guard let numberPart = components.last, let number = Int(numberPart) else {
            return id.uppercased()  // Return uppercased input if no number is found
        }
        
        let formattedNumber: String
        var prefix = ""
        
        // Detect and format based on prefix (LAMP or GUEST)
        if id.lowercased().hasPrefix("lamp") {
            formattedNumber = String(format: "%05d", number)  // 5 digits for "LAMP"
            prefix = "LAMP"
        } else if id.lowercased().hasPrefix("guest") {
            formattedNumber = String(format: "%04d", number)  // 4 digits for "GUEST"
            prefix = "GUEST"
        } else {
            return id.uppercased()  // Return uppercased input if neither prefix is valid
        }
        
        // Return formatted ID with correct prefix and padded number
        return prefix + formattedNumber
    }
    
    func fetchData(delegateID: String) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Network is available, proceed with API call
                DispatchQueue.main.async {
                    self.makeApiCall(delegateID: delegateID)
                }
            } else {
                // No internet connection, show an alert
                DispatchQueue.main.async {
                    self.showNoInternetAlert()
                }
            }
            monitor.cancel()
        }
    }
    
    func makeApiCall(delegateID: String) {
        let baseURL = "https://lampawta.com/api/delegate/"
        let apiKey = "bdf0bf18-54cf-4aca-86ec-a03b77c02264"
        
        guard let url = URL(string: "\(baseURL)\(delegateID)?api_key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Store the fetched data
                        self?.fetchedData = json
                        
                        // Trigger the segue to navigate to ProfileViewController
                        DispatchQueue.main.async {
                            self?.performSegue(withIdentifier: "showProfileViewManual", sender: nil)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func showNoInternetAlert() {
        let alertController = UIAlertController(title: "No Internet", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

