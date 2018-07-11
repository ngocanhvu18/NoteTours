//
//  LogInViewController.swift
//  NoteTours
//
//  Created by Ngọc Anh on 6/29/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin

class HomeViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loginView: UIView!

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let email = UserDefaults.standard.value(forKey: "email") as? String {
            loading.startAnimating()
            if email == "ngocanhvu18ict@gmail.com" {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.loadViewController()
                }
                
            } else {
                containerView.isHidden = false
                  loading.stopAnimating()
            }
        } else {
            containerView.isHidden = false
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Login FaceBook.
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    if let userData = result as? DIC {
                        if  let email = userData["email"] as? String,
                            let name = userData["name"] as? String,
                            let picture = userData["picture"] as? DIC,
                            let data = picture["data"] as? DIC,
                            let url = data["url"] as? String {
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.set(url, forKey: "url")
                            UserDefaults.standard.set(false, forKey: "FirstLogin")
                            self.loadViewController()
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error == nil {
                if let loginResult = result {
                    if loginResult.grantedPermissions != nil {
                        print("Login thanh cong")
                        self.getFBUserData()
                    }
                }
                
            } else {
                print("Login that bai")
            }
        }
    }
    
    func loadViewController() {
        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let tabBarControllrt = storyboar.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        present(tabBarControllrt, animated: true, completion: nil)
    }

}
