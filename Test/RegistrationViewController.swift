//
//  ViewController.swift
//  Test
//
//  Created by GG on 24.08.2018.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    var User:LoginedUser?
  
    @IBAction func Registration(_ sender: Any) {
        guard let email = Email.text, let pass = Password.text, let name = Name.text, name != "",  email != "", pass != "" else {
            displayStatusLable(text: "Incorrect info")
            return
        }
        let emailString = Email.text!
        let nameString = Name.text!
        let passString = Password.text!
        print(emailString,nameString,passString)
        registration(email:"\(emailString)", name: "\(nameString)", password: "\(passString)")
    }
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var UserInfoLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserInfoLable.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayStatusLable(text:String){
        UserInfoLable.text = text
        
        UIView.animate(withDuration: 7, delay: 0, options: .curveEaseInOut, animations: {[weak self] in
            self?.UserInfoLable.alpha = 1
        }) { [weak self] complete in
            self?.UserInfoLable.alpha = 0
        }
    }
    
    func registration(email:String, name:String, password:String){
        guard let url = URL(string: "https://apiecho.cf/api/signup/") else {return}
        var request  = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "name=\(name)&email=\(email)&password=\(password)".data(using: .utf8)
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
}

