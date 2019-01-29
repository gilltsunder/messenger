//
//  Registration.swift
//  MessView
//
//  Created by Влад Третьяк on 12/22/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Firebase

class Registration: UIViewController {

    @IBOutlet var textFieldCollection: [UITextField]!{
        didSet{
            textFieldCollection.forEach {
                $0.backgroundColor = .black
                $0.tintColor = .white
                $0.textColor = .white
                $0.attributedPlaceholder = NSAttributedString(string: $0.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:  UIColor(white: 1.0, alpha: 0.6)])
                let buttonlLayer = CALayer()
                buttonlLayer.frame = CGRect(x: 0, y: 27, width: 300, height: 0.6)
                buttonlLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
                $0.layer.addSublayer(buttonlLayer)
                
            }
        }
    }
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            profileImage.layer.cornerRadius = 40
            profileImage.clipsToBounds = true
            let tapGusture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
            profileImage.addGestureRecognizer(tapGusture)
            profileImage.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var registerOutlet: UIButton!{
        didSet{
            registerOutlet.layer.cornerRadius = 12
            registerOutlet.backgroundColor = .white
            registerOutlet.tintColor = .black
        }
    }
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func registrationButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if error != nil {
                print(error!)
                return
            } else {
                if let imageData = self.selectedImage?.jpegData(compressionQuality: 0.1) {
                    let uid = authResult?.user.uid
                    
                    let storaeRef = Storage.storage().reference(forURL: "gs://messview-83c6a.appspot.com").child("profile_image").child(uid!)
                    storaeRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        guard metadata != nil else {
                            return
                        }
                        storaeRef.downloadURL(completion: { (url, error) in
                            guard (url?.absoluteString) != nil else {
                                return
                            }
                            let profileImageUrl = url?.absoluteString
                            SetUserInformation(profileImageUrl: profileImageUrl!, username: self.username.text!, email: self.email.text!, uid: uid!)
                        })
                    })
                    
                    func SetUserInformation(profileImageUrl: String, username: String, email: String, uid: String)  {
                        _ = Database.database().reference().child("users").child(uid).setValue(["name": username, "email": email, "profileImageUrl":profileImageUrl])
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let MessageView = storyboard.instantiateViewController(withIdentifier: "MessageView")
                    self.present(MessageView, animated: true, completion: nil)
                }
                
            }
        }
    }
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension Registration: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
