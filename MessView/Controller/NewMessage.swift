//
//  NewMessage.swift
//  MessView
//
//  Created by Влад Третьяк on 12/23/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class NewMessage: UIViewController {
    
    @IBOutlet weak var ttableView: UITableView!

    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "UserListCell", bundle: nil)
        self.ttableView.register(nib, forCellReuseIdentifier: "UsersListCustomCell")
        
        loadData()
    }
    
    
    func loadData() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                
                let user = User(dictionary: dict)
                user.id = snapshot.key
                 self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.ttableView.reloadData()
                })
            }
        }
    }
    var NewView : MessageView?
}

extension NewMessage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UserListCell = self.ttableView.dequeueReusableCell(withIdentifier: "UsersListCustomCell", for: indexPath) as? UserListCell else {
            fatalError()
        }
        
        let data = users[indexPath.row]
        let imgURL = URL(string: data.profileImageUrl!)
        
        cell.name.text = data.name
        cell.caption.text = data.email
        cell.userImg.kf.setImage(with: imgURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let user = self.users[indexPath.row]
        nextStep(user: user)
        
    }
    func nextStep(user : User) {
        let NewV = ChatLogController.makeFromStoryBoard()
        NewV.user = user
        navigationController?.pushViewController(NewV, animated: true)

    }
}
