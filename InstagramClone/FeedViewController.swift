//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by İbrahim Bayram on 24.01.2023.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController {
    var postArray = [Post]()
    var documentIDArray = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    func getData() {
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Posts").order(by: "Date",descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.postArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        if let postedBy = document.get("Posted By") as? String {
                            if let comment = document.get("Comment") as? String {
                                if let like = document.get("likes") as? Int {
                                    if let imageURL = document.get("imageURL") as? String {
                                        let post = Post(documentID: documentID, imageURL: imageURL, userComment: comment, userMail: postedBy, like: like)
                                        self.postArray.append(post)
                                    }
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
extension FeedViewController : UITableViewDelegate, UITableViewDataSource, deleteProtocol {
    func deletePost(indexPath: IndexPath) {
        let db = Firestore.firestore()
        db.collection("Posts").document(postArray[indexPath.row].documentID).delete { (error) in
            if error != nil {
                self.callAlert(title: "ERROR", message: "Something wrong during deleting this post")
            }else {
                self.callAlert(title: "Successful", message: "Post successfully deleted.")
            }
        }
        self.tableView.reloadData()
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return postArray.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
            cell.userEmailLabel.text = postArray[indexPath.row].userMail
            cell.userCommentLabel.text = postArray[indexPath.row].userComment
            cell.likeLabel.text = String(postArray[indexPath.row].like)
            cell.userImageView.sd_setImage(with: URL(string: postArray[indexPath.row].imageURL))
            cell.hiddenIDLabel.text = postArray[indexPath.row].documentID
            cell.cellProtocol = self
            cell.indexPath = indexPath
            if let currentMail = Auth.auth().currentUser?.email {
                if currentMail == postArray[indexPath.row].userMail {
                    cell.deleteButton.isHidden = false
                }else {
                    cell.deleteButton.isHidden = true
                }
            }
            return cell
        }
    func callAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    }

