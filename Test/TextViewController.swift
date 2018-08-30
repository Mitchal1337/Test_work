//
//  TextViewController.swift
//  Test
//
//  Created by GG on 29.08.2018.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBAction func countChar(_ sender: Any) {
        occurrence = OccurrenceOfCharacters(text: textExample)
        occurrenceCount = occurrence?.count
        TableViewOfCharacters.reloadData()
    }
    @IBAction func Get_text(_ sender: Any) {
        getText()
        occurrence?.removeAll()
        TableViewOfCharacters.reloadData()
        Text.text = textExample
    }
    @IBOutlet weak var Text: UITextView!
    @IBOutlet weak var TableViewOfCharacters: UITableView!
    
    var token = " "
    var occurrence: [String:Int]?
    var occurrenceCount:Int?
    var textExample = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewOfCharacters.delegate = self
        TableViewOfCharacters.dataSource = self
        Text.isEditable = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getText()
       Text.text = textExample
    }
    
    func OccurrenceOfCharacters(text: String) -> [String:Int]{
        var letters:[String : Int] = [" ":0]
        var character_count = 0
        
        for character in text {
            let letter = "\(character)"
            character_count = 1
            for (char, char_count) in letters{
                if  letter != char  {
                    letters[letter] = character_count
                } else if char == letter  {
                    character_count = char_count
                    character_count += 1
                    letters[char] = character_count
                }
            }
        }
        
        for (char, char_count) in letters{
            if char == " "{
                letters["space"] = char_count
                letters.removeValue(forKey: char)
            }
        }
        return letters
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if occurrenceCount == nil{
        return  1
        } else {
            return occurrenceCount!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if occurrence?.isEmpty == false{
            let arrOfKeys = Array(occurrence!.keys).sorted(by: <)
            cell.textLabel?.text = arrOfKeys[indexPath.row]
            let detailText = occurrence![arrOfKeys[indexPath.row]]
            cell.detailTextLabel?.text = "\(detailText!)"
        }
        return cell
    }
    
    func getText() {
        guard let url = URL(string: "https://apiecho.cf/api/get/text/") else {return}
        var request  = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print(response)
            }
    
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(GetText.self, from: data)
                self.textExample = json.data
            } catch{
                print(error)
            }
            }.resume()
    }

}
