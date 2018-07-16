//
//  RegisterController.swift
//  NoteTours
//
//  Created by NgọcAnh on 7/12/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
class RegisterController: UIViewController{
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    var users: [UserName] = []
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        nameText.text = UserDefaults.standard.object(forKey: "name") as? String
        dateText.text = UserDefaults.standard.object(forKey: "ngaysinh") as? String
        emailText.text = UserDefaults.standard.object(forKey: "email") as? String
        passText.text = UserDefaults.standard.object(forKey: "pass") as? String
        hideKeyboardWhenTappedAround()
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: Any){
        // hien thi thong bao khi khong du thong tin
        if nameText.text == "" || dateText.text == "" || emailText.text == "" || passText.text == "" {
            let alert = UIAlertController(title: "Cập nhật đầy đủ thông tin", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (Void)  in })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            ref.child("name").setValue(nameText.text)
            ref.child("ngaysinh").setValue(dateText.text)
            ref.child("email").setValue(emailText.text)
            ref.child("pass").setValue(passText.text)
            UserDefaults.standard.set(nameText.text, forKey: "name")
            UserDefaults.standard.set(dateText.text, forKey: "ngaysinh")
            UserDefaults.standard.set(emailText.text, forKey: "email")
            UserDefaults.standard.set(passText.text, forKey: "pass")
        }
        self.loadViewController()
        
    }
 
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func loadViewController() {
        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let tabBarControllrt = storyboar.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        present(tabBarControllrt, animated: true, completion: nil)
    }
}
