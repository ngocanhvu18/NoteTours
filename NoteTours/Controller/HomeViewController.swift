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

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    // Login FaceBook.
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    print(result)
                    if let userData = result as? DICT {
                        if  let email = userData["email"] as? String,
                            let name = userData["name"] as? String,
                            let picture = userData["picture"] as? DICT,
                            let data = picture["data"] as? DICT,
                            let url = data["url"] as? String {
                            print(email, name, url)
                            
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
