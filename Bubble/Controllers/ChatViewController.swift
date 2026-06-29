//
//  ChatViewController.swift
//  Bubble
//
//  Created by Zachary Lam on 2026-06-22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "user1@email.com", body: "lorem ipsum"),
        Message(sender: "user2@email.com", body: "another lorem ipsum"),
        Message(sender: "user2@email.com", body: "the third lorem ipsum")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            Task {
                // Add a new document with a generated ID
                do {
                    let ref = try await db.collection(K.FireStore.collectionName).addDocument(data: [
                        K.FireStore.senderField: messageSender,
                        K.FireStore.bodyField: messageBody,
                    ])
                    print("Document added with ID: \(ref.documentID)")
                } catch {
                    print("Error adding document: \(error)")
                }
            }
            
        }
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

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        cell.label.text = String(messages[indexPath.row].body)
        
        return cell
    }
}
