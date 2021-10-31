import UIKit
import Charts


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!

    var charts = [Chart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(LineChartCell.nib(), forCellReuseIdentifier: LineChartCell.identifier)
        table.register(BarChartCell.nib(), forCellReuseIdentifier: BarChartCell.identifier)

        table.delegate = self
        table.dataSource = self
    
        let placeholder = Chart(title: "", type: ChartType.Line, datasets: [], dates: [], labels:[])
        
        // TODO: display loading animtion in placeholders
        self.charts = [placeholder, placeholder, placeholder, placeholder, placeholder]
        
        
        // Display charts
        getCasesData() { (data) in
            self.charts[0] = data
            self.table.reloadData()
        }

        getHospitalizationData() { (data) in
            self.charts[1] = data
            self.table.reloadData()
        }

        getVaccinationsData() { (data) in
            self.charts[2] = data
            self.table.reloadData()
        }

        getVaccinePopularityData() { (data) in
            self.charts[3] = data
            self.charts[3].type = ChartType.Bar
            self.table.reloadData()
        }
        
        getDeathsData() { (data) in
            self.charts[4] = data
            self.table.reloadData()
        }

    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if charts[indexPath.row].type == ChartType.Line {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineChartCell.identifier, for: indexPath) as! LineChartCell
            cell.configure(with: charts[indexPath.row])
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: BarChartCell.identifier, for: indexPath) as! BarChartCell
            cell.configure(with: charts[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
