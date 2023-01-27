//
//  ViewController.swift
//  InstagramClone
//
//  Created by İbrahim Bayram on 23.01.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        
        
    }
    @IBAction func signInClicked(_ sender: Any) {
        if mailTextField.text != "" && passwordTextField.text != "" {
            if let mail = mailTextField.text , let sifre = passwordTextField.text {
                Auth.auth().signIn(withEmail: mail, password: sifre) { (authdata, error) in
                    if error != nil {
                        self.makeAlert(title: "ERORR", message: error!.localizedDescription)
                    }else {
                        self.performSegue(withIdentifier: "toHome", sender: nil)
                    }
                }
            }
        }else {
            self.makeAlert(title: "ERROR", message: "Please enter your email and password completely.")
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
        if mailTextField.text != "" && passwordTextField.text != "" {
            if let mail = mailTextField.text , let sifre = passwordTextField.text {
                Auth.auth().createUser(withEmail: mail, password: sifre) { (authdata, error) in
                    if error != nil {
                        self.makeAlert(title: "ERROR", message: error!.localizedDescription)
                    }else {
                        self.performSegue(withIdentifier: "toHome", sender: nil)
                    }
                }
            }
        }else {
            self.makeAlert(title: "ERROR", message: "Please enter your email and password completely.")
        }
        
    }
    @IBAction func showPassword(_ sender: Any) {
        if self.passwordTextField.isSecureTextEntry {
            self.passwordTextField.isSecureTextEntry = false
            self.showButton.setImage(UIImage(systemName: "eye.fill"), for: UIControl.State.normal)
            
        }else {
            self.passwordTextField.isSecureTextEntry = true
            self.showButton.setImage(UIImage(systemName: "eye.slash.fill"), for: UIControl.State.normal)
        }
    }
     
    func makeAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    

}

