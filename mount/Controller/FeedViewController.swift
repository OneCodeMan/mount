//
//  FeedViewController.swift
//  mount
//
//  Created by Dave Gumba on 2017-12-28.
//  Copyright © 2017 Dave's Organization. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var entryArray: [Entry] = [Entry]()
    var keyArray: [String] = [String]()
    
    @IBOutlet weak var entryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryTableView.delegate = self
        entryTableView.dataSource = self
        
        fetchEntries()
    }
    
    // Mark: - TableView DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = entryTableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        cell.textLabel?.text = entryArray[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EntryDetail") as? EntryDetailViewController {
            vc.titleString = entryArray[indexPath.row].title
            vc.content = entryArray[indexPath.row].content
            vc.date = entryArray[indexPath.row].date
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entriesDB = Database.database().reference().child("Entries")
            
            getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                entriesDB.child(self.keyArray[indexPath.row]).removeValue()
            })
            
            entryArray.remove(at: indexPath.row)
            entryTableView.deleteRows(at: [indexPath], with: .fade)
        

        }
    }
    
    func fetchEntries() {
        
        let entriesDB = Database.database().reference().child("Entries")
        
        entriesDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let key = snapshotValue["EntryKey"]!
            let sender = snapshotValue["Sender"]!
            let title = snapshotValue["EntryTitle"]!
            let content = snapshotValue["EntryBody"]!
            let date = snapshotValue["EntryDate"]!
            
            let entry = Entry()
            entry.key = key
            entry.sender = sender
            entry.title = title
            entry.date = date
            entry.content = content
            
            self.entryArray.append(entry)
            self.entryTableView.reloadData()

        }
        
    }
    
    func getAllKeys() {
        let entriesDB = Database.database().reference().child("Entries")
        entriesDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
                print(self.keyArray)
                
            }
        })
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
       
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error, problem signing out")
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil else {
            print("No view controllers to pop off")
            return
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
