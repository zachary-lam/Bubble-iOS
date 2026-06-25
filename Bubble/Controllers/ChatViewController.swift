//
//  ChatViewController.swift
//  Bubble
//
//  Created by Zachary Lam on 2026-06-22.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            // Source - https://stackoverflow.com/a/34325813
            // Posted by Rene Ramirez
            // Retrieved 2026-06-25, License - CC BY-SA 3.0
            self.navigationController?.popToRootViewController(animated: true)

        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
