//
//  EntryDetailViewController.swift
//  mount
//
//  Created by Dave Gumba on 2017-12-29.
//  Copyright © 2017 Dave's Organization. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EntryDetailViewController: UIViewController {
    
    var titleString: String?
    var content: String?
    var date: String?
    var dbKey: String?
    
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var entryContent: UITextView!
    
    var dbURL: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryTitle.text = titleString != "" ? titleString : "untitled"
        entryContent.text = content ?? "no content available"
        entryDate.text = date ?? "no date"
        
        let entriesDB = Database.database().reference().child("Entries")
        
        dbURL = entriesDB.child(dbKey!)
//        print(dbURL)
    }

    @IBAction func editPressed(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditEntry") as? EditEntryViewController {
            vc.entryTitle = titleString
            vc.content = content
            vc.dbURL = dbURL
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}
