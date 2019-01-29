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
    
    @IBOutlet weak var ttableView: UITableView! {
        didSet {
            let nib = UINib(nibName: String(describing: UserListCell.self), bundle: nil)
            self.ttableView.register(nib, forCellReuseIdentifier: UserListCell.reuseIdentifier)
        }
    }
    
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.ttableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        Database.database().reference().child("users").observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            guard let parameters = snapshot.value as? [String: Any],
                let user = User(id: snapshot.key, userParameters: parameters) else {
                    print("Fail to represent snapshot as [String: AnyObject]")
                    return
            }
            self.users.append(user)
        }
    }
    var NewView : MessageView?
}

extension NewMessage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ttableView.dequeueReusableCell(withIdentifier: UserListCell.reuseIdentifier,
                                                        for: indexPath) as? UserListCell else {
                                                            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        cell.setup(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserListCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        nextStep(user: user)
    }
    
    func nextStep(user: User) {
        let NewV = ChatLogController.makeFromStoryBoard()
        NewV.user = user
        navigationController?.pushViewController(NewV, animated: true)
    }
}
