//
//  EntryDetailViewController.swift
//  mount
//
//  Created by Dave Gumba on 2017-12-29.
//  Copyright © 2017 Dave's Organization. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var titleString: String?
    var content: String?
    var date: String?
    
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var entryContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryTitle.text = titleString ?? "no title available"
        entryContent.text = content ?? "no content available"
        entryDate.text = date ?? "no date"
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
