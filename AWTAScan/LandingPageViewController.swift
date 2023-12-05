//
//  LandingPageViewController.swift
//  AWTAScan
//
//  Created by Klaudine Allyanna Laureano on 10/21/23.
//

import UIKit

class LandingPageViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func scanBUttonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "showCamera", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
