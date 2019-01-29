//
//  Loggin.swift
//  MessView
//
//  Created by Влад Третьяк on 12/22/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class Login: UIViewController {
    
    @IBOutlet var textFieldCollection: [UITextField]!{
        didSet {
            textFieldCollection.forEach {
                $0.backgroundColor = .black
                $0.tintColor = .white
                $0.textColor = .white
                $0.attributedPlaceholder = NSAttributedString(string: $0.placeholder!,
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0,
                                                                                                                           alpha: 0.6)])
                let buttonlLayer = CALayer()
                buttonlLayer.frame = CGRect(x: 0, y: 27, width: 300, height: 0.6)
                buttonlLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
                $0.layer.addSublayer(buttonlLayer)
                
            }
        }
    }
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!{
        didSet{
            loginOutlet.layer.cornerRadius = 12
            loginOutlet.backgroundColor = .white
            loginOutlet.tintColor = .black
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MessageView = storyboard.instantiateViewController(withIdentifier: "MessageView")
            self.present(MessageView, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startedAnima()
        
    }
    
    
    func startedAnima() {
        let animationView = LOTAnimationView(name: "amazing_anima")
        animationView.frame = CGRect (x: 0, y: 100, width: self.view.frame.size.width, height: 250)
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        self.view.addSubview(animationView)
        animationView.play()
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTF.text!, password: passwordTF.text!) { (authResult, error) in
            if error != nil {
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let MessageView = storyboard.instantiateViewController(withIdentifier: "MessageView")
                self.present(MessageView, animated: true, completion: nil)
            }
            
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}
