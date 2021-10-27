//
//  FeedViewController.swift
//  CovidInfo
//
//  Created by Zan Spiler on 27/10/2021.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    var models = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        models.append(1); // kao en chart
        models.append(2); // kao en chart
        models.append(3); // kao en chart

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return models.count
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
//        cell.configure(with: models[indexPath.row])
//        return UITableViewCell()
  
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell

        
        cell.configure(with: models[indexPath.row]) // setChart
        return cell

    }
    
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

}
//
//struct InstagramPost {
//    let chartTitle: String
//
//}
