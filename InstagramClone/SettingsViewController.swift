//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by İbrahim Bayram on 24.01.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signOutClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                performSegue(withIdentifier: "toLogin", sender: nil)
            }catch {
                print("error")
            }
        }
    }
    

}
