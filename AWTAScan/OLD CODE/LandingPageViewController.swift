//
//  LandingPageViewController.swift
//  AWTAScan
//
//  Created by Klaudine Allyanna Laureano on 10/21/23.
//

import UIKit

class LandingPageViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var typeIdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @IBAction func scanBUttonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "showCamera", sender: nil)
    }
    
    
    @IBAction func typeManualBnClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "showManualTyping", sender: nil)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
