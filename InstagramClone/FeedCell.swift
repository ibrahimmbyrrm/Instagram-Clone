//
//  FeedCell.swift
//  InstagramClone
//
//  Created by İbrahim Bayram on 27.01.2023.
//

import UIKit
import Firebase
import FirebaseAuth

protocol deleteProtocol {
    func deletePost(indexPath : IndexPath)
}

class FeedCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hiddenIDLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    var cellProtocol : deleteProtocol?
    var indexPath : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteClicked(_ sender: Any) {
        cellProtocol?.deletePost(indexPath: indexPath!)

        
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            firestoreDatabase.collection("Posts").document(hiddenIDLabel.text!).setData(likeStore, merge: true)
        }
        
    }
}
