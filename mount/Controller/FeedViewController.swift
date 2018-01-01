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
    var username: String?
    
    @IBOutlet weak var entryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entryTableView.delegate = self
        entryTableView.dataSource = self
        
//        print("logged in as \(username)")
        fetchEntries()
    }
    
    // Mark: - UITableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = entryTableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        let cellTitle = entryArray[indexPath.row].title
        cell.textLabel?.text = cellTitle != "" ? cellTitle : "untitled"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EntryDetail") as? EntryDetailViewController {
            vc.titleString = entryArray[indexPath.row].title
            vc.content = entryArray[indexPath.row].content
            vc.date = entryArray[indexPath.row].date
            vc.dbKey = self.keyArray[indexPath.row]
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
    
    // MARK - DB methods
    
    func fetchEntries() {
        
        let entriesDB = Database.database().reference().child("Entries")
        
        entriesDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let sender = snapshotValue["Sender"]!
            
            if (sender == self.username!) {
                let key = snapshotValue["EntryKey"]!
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
        
        getAllKeys()
        
    }
    
    func getAllKeys() {
        let entriesDB = Database.database().reference().child("Entries")
        entriesDB.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
                
            }
        })
    }
    
    // MARK - UI behaviour
    
    @IBAction func logoutPressed(_ sender: Any) {
       
        do {
            try Auth.auth().signOut()
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") as? WelcomeViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } catch {
            print("error, problem signing out")
        }
        
//        guard (navigationController?.popToRootViewController(animated: true)) != nil else {
//            print("No view controllers to pop off")
//            return
//        }
    }
    
    @IBAction func addEntry(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEntry") as? AddEntryViewController {
            vc.username = username
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
