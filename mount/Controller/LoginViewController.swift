//
//  LoginViewController.swift
//  mount
//
//  Created by Dave Gumba on 2017-12-28.
//  Copyright © 2017 Dave's Organization. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let keyboardDownGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(keyboardDownGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        loginButton.isEnabled = false
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Log in successful")
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedView") as? FeedViewController {
                    vc.username = username
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }
    
}
