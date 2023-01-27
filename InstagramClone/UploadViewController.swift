//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by İbrahim Bayram on 24.01.2023.
//

import UIKit
import Firebase
import FirebaseStorage
class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imagereference = mediaFolder.child("\(uuid).jpg")
            imagereference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "ERROR", message: error!.localizedDescription)
                    print(error!.localizedDescription)
                }else {
                    imagereference.downloadURL { (url, erorr) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }else {
                            let imageUrl = url?.absoluteString
                            
                            //Database Part
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference
                            let firestorePost = ["imageURL" : imageUrl!, "Posted By" : Auth.auth().currentUser?.email, "Comment" : self.commentTextField.text!, "Date" : FieldValue.serverTimestamp(), "likes" : 0] as [String:Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(title: "ERROR", message: erorr?.localizedDescription ?? "Error")
                                }else {
                                    self.imageView.image = UIImage(named: "add-image")
                                    self.commentTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    func makeAlert(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}
