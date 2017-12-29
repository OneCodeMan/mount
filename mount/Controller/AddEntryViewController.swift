//
//  AddEntryViewController.swift
//  mount
//
//  Created by Dave Gumba on 2017-12-29.
//  Copyright © 2017 Dave's Organization. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddEntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addEntry(_ sender: Any) {
        
        let entriesDB = Database.database().reference().child("Entries")
        let entryText = contentTextField.text ?? ""
        
        let entryDictionary = ["Sender": Auth.auth().currentUser?.email,
                               "EntryBody": entryText]
        
        entriesDB.childByAutoId().setValue(entryDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error)
            } else {
                print("entry saved")
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
