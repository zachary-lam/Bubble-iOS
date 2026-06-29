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
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        loadMessages()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        // Source - https://stackoverflow.com/a/78750754
        // Posted by JeremyP
        // Retrieved 2026-06-17, License - CC BY-SA 4.0
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringDate = formatter.string(from: today)
        let formattedDate = formatter.date(from: stringDate)
        
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            Task {
                // Add a new document with a generated ID
                do {
                    let _ = try await db.collection(K.FireStore.collectionName).addDocument(data: [
                        K.FireStore.senderField: messageSender,
                        K.FireStore.bodyField: messageBody,
                        K.FireStore.dateField: formattedDate!
                    ])
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
    
    func loadMessages() {
        db.collection(K.FireStore.collectionName)
            .order(by: "date")
            .addSnapshotListener { querySnapshot, error in
                
                self.messages = []
                
                if let snapshot = querySnapshot?.documents {
                    for doc in snapshot {
                        let data = doc.data()
                        if let sender = data[K.FireStore.senderField] as? String, let body = data[K.FireStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: body)
                            
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                } else {
                    if let error = error {
                        print(error)
                        return
                    }
                }
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
