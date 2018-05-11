//
//  EditEntryViewController.swift
//  mount
//
//  Created by Dave Gumba on 2017-12-29.
//  Copyright © 2017 Dave's Organization. All rights reserved.
//

import UIKit
import Firebase

class EditEntryViewController: UIViewController {
    
    var entryTitle: String?
    var content: String?
    var dbURL: DatabaseReference!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = entryTitle ?? ""
        contentTextField.text = content ?? ""
        print(dbURL)
        
        let keyboardDownGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(keyboardDownGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func saveEntry(_ sender: Any) {
        
        let newTitle = titleTextField.text ?? ""
        let newContent = contentTextField.text ?? ""
        
        dbURL.updateChildValues([
            "EntryTitle": newTitle,
            "EntryBody": newContent
        ])
        
        dbURL.observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let username = snapshotValue["Sender"]!
            print("saved as \(username)")
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedView") as? FeedViewController {
                vc.username = username
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}
