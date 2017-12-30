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
        print("content: \(content)")
        print(dbURL)
        
    }

    @IBAction func saveEntry(_ sender: Any) {
        
        let newTitle = titleTextField.text ?? ""
        let newContent = contentTextField.text ?? ""
        
        dbURL.updateChildValues([
            "EntryTitle": newTitle,
            "EntryBody": newContent
        ])
        
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
