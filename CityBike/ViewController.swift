//
//  ViewController.swift
//  CityBike
//
//  Created by Святослав Спорыхин on 27.04.2018.
//  Copyright © 2018 Worksolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var heightListStreet: NSLayoutConstraint!
    @IBOutlet weak var heightFieldStreet: NSLayoutConstraint!
    
    @IBOutlet weak var listView: UIView!
    
    var heightOpenList: CGFloat = 0.0
    var heightOpenField: CGFloat = 90.0
    
    let arrayCity: Array<String> = ["Москва", "Питер", "Воронеж"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customCell
        cell.nameStreet.text = arrayCity[indexPath.row]
        return cell
    }
    
    @IBAction func search(_ sender: UIButton) {
        heightListStreet.constant = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        heightOpenList = self.view.frame.height - 110.0
        heightListStreet.constant = 0.0
        listView.isHidden = false
    }
    
    @IBAction func startEdit(_ sender: UITextField) {
        heightListStreet.constant = heightOpenList
    }
    
    @IBAction func exit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

}

class customCell: UITableViewCell {
    @IBOutlet weak var nameStreet: UILabel!
}
//20
