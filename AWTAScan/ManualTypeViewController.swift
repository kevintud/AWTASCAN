//
//  ManualTypeViewController.swift
//  AWTAScan
//
//  Created by Kevin Lloyd Tud on 12/8/23.
//

import UIKit

class ManualTypeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lampIdTextFeild: UITextField!
    
    @IBOutlet weak var submitIdBtn: UIButton!
    var fetchedData: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lampIdTextFeild.delegate = self
        lampIdTextFeild.layer.borderWidth = 1.0
        lampIdTextFeild.layer.borderColor = UIColor.black.cgColor
        lampIdTextFeild.layer.cornerRadius = lampIdTextFeild.frame.width * 0.03
        
        submitIdBtn.layer.borderWidth = 1.0
        submitIdBtn.layer.borderColor = UIColor.black.cgColor
        submitIdBtn.layer.cornerRadius = submitIdBtn.frame.width * 0.03
        
        if let placeholder = lampIdTextFeild.placeholder {
            lampIdTextFeild.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
    }
    
    @IBAction func submitIdBtnClicked(_ sender: UIButton) {
        submitIdBtn.isEnabled = false
        if let id = lampIdTextFeild.text {
            let formattedID = formatLampID(id)
            if isValidLampID(formattedID) {
                fetchData(delegateID: formattedID)
            } else {
                print("Error")
                submitIdBtn.isEnabled = true  // Enable the button in case of an error
            }
        }
    }
    
    func isValidLampID(_ lampID: String) -> Bool {
        let lampIDRegex = "(LAMP\\d{5}$)|(GUEST\\d{4}$)"
        let lampIDTest = NSPredicate(format:"SELF MATCHES[c] %@", lampIDRegex)
        return lampIDTest.evaluate(with: lampID)
    }
    
    func formatLampID(_ id: String) -> String {
        let components = id.components(separatedBy: CharacterSet.decimalDigits.inverted)
        guard let numberPart = components.last, let number = Int(numberPart) else {
            return id
        }
        
        let formattedNumber: String
        if id.lowercased().hasPrefix("lamp") {
            formattedNumber = String(format: "%05d", number)  // 5 digits for "lamp"
        } else if id.lowercased().hasPrefix("guest") {
            formattedNumber = String(format: "%04d", number)  // 4 digits for "guest"
        } else {
            return id
        }
        
        let range = id.range(of: numberPart)!
        var formattedID = id
        formattedID.replaceSubrange(range, with: formattedNumber)
        
        return formattedID
    }
    
    func fetchData(delegateID: String) {
        // Construct the URL with the delegateID
        let baseURL = "https://online.lampawta.com/api/delegate/"
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
                            self?.submitIdBtn.isEnabled = true
                            self?.performSegue(withIdentifier: "showProfileViewManual", sender: nil)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileViewManual" {
            if let profileVC = segue.destination as? ProfileViewController {
                profileVC.fetchedData = self.fetchedData
            }
        }
    }
}
