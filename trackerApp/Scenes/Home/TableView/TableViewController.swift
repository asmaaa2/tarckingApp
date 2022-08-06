//
//  TableViewController.swift
//  trackerApp
//
//  Created by Asmaa on 04/08/2022.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tripsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    

    func setUp(){
        tripsView.delegate = self
        tripsView.dataSource = self
        navigationItem.title = "Simple Table View"
    }


}
extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = "This is Your Trip Number "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hi smsm")
    }
}
