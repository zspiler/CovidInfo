import UIKit
import Charts


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!

    var models = [Chart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        // Display charts
        getHospitalizationData() { (data) in
            self.models.append(data)
            self.table.reloadData()
        }
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell

        cell.configure(with: models[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}



public struct Chart {
    let title: String
    let datasets: [IChartDataSet]
    let dates: [Date] // dates for X-axis labels
}

