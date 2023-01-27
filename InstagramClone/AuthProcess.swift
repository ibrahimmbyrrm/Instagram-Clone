//
//  LoginViewModel.swift
//  InstagramClone
//
//  Created by İbrahim Bayram on 26.01.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit

struct AuthProcess {
    func signIn(mail: String, password : String) -> Bool{
        var result = false
        Auth.auth().signIn(withEmail: mail, password: password) { (authdata, error) in
            if error != nil {
                AuthAlerts().makeAlert(title: "ERROR", message: error!.localizedDescription)
                result = false
                
            }else {
               result = true
            }
        }
        return result
    }
}
struct AuthAlerts {
    func makeAlert(title : String, message : String) -> UIAlertController {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        return alert
    }
}
