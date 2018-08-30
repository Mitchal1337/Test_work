//
//  LoginViewController.swift
//  Test
//
//  Created by GG on 28.08.2018.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var UserStatusLable: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBAction func LoginBut(_ sender: Any) {
        guard let email = EmailTextField.text, let pass = PasswordTextField.text, email != "", pass != "" else {
            displayStatusLable(text: "Incorrect info")
            return
        }
        let emailString:String = EmailTextField.text!
        let passwordString:String = PasswordTextField.text!
        Auth(email: emailString, password: passwordString)

    }
    @IBAction func RegistrationBut(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        UserStatusLable.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    @objc func kbDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIKeyboardFrameEndUserInfoKey]as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
    }
    @objc func kbDidHide(){
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Auth(email:String, password:String){
        guard let url = URL(string: "https://apiecho.cf/api/login/") else {return}
        var request  = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "email=\(email)&password=\(password)".data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print(response)
            }
            
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(LoginedUser.self, from: data)
                if json.success == true {
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TextView") as! TextViewController
                        let navController = UINavigationController(rootViewController: vc)
                        vc.token = json.data.access_token
                        self.present(navController, animated: true, completion: nil)
                    }
                }
            } catch{
                print(error)
            }
            }.resume()
    }
    
    func displayStatusLable(text:String){
        UserStatusLable.text = text
        
        UIView.animate(withDuration: 7, delay: 0, options: .curveEaseInOut, animations: {[weak self] in
            self?.UserStatusLable.alpha = 1
        }) { [weak self] complete in
            self?.UserStatusLable.alpha = 0
        }
    }

   

}
