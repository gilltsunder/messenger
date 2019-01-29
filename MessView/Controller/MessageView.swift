//
//  MessageView.swift
//  MessView
//
//  Created by Влад Третьяк on 12/22/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import Lottie

class MessageView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser()
        
        self.tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "ChatLog", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ChatLog")
    }
    
    var messages = [Message]() {
        didSet {
            messages = messages.sorted { $0.timestamp > $1.timestamp }
            refreshUniqueMessages()
        }
    }
    
    var uniqueMessages: [Message] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func refreshUniqueMessages() {
        var chats: [String: Message] = [:]
        for message in messages {
            if chats[message.opponentId] == nil {
                chats[message.opponentId] = message
            }
        }
        uniqueMessages = chats.values.map { $0 }
    }
    
    func currentUser() {
        messages.removeAll()
        tableView.reloadData()
        observeUserMessage()
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let user = dictionary["name"] as? String
                let image = dictionary["profileImageUrl"] as? String
                self.setupNavBar(user: user!, userImage: image!)
            }
        }, withCancel: nil)
    }
    
    func setupNavBar(user: String, userImage: String) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        if let imageURL = URL(string: userImage) {
            profileImage.kf.setImage(with: imageURL)
        }
        titleView.addSubview(profileImage)
        
        profileImage.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        titleView.addSubview(nameLabel)
        nameLabel.text = user
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
        self.navigationItem.titleView = titleView
    }
    
    
    
    func observeUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messagesId = snapshot.key
            let messagesReference = Database.database().reference().child("messages").child(messagesId)
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    do {
                        let message = try Message(from: dict)
                        self.messages.append(message)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError  {
            print (logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "Login")
        self.present(login, animated: true, completion: nil)
    }
}

extension MessageView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLog", for: indexPath) as? ChatLog else {
            fatalError()
        }
        
        let message = uniqueMessages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = uniqueMessages[indexPath.row]
        let ref = Database.database().reference().child("users").child(message.opponentId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            if let user = User(id: snapshot.key, userParameters: dictionary) {
                self.showChatControllerForUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func showChatControllerForUser(user: User) {
        let chatVC = self.storyboard!.instantiateViewController(withIdentifier: "ChatLogController") as! ChatLogController
        chatVC.user = user
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

