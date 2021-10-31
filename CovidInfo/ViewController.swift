import UIKit
import Charts


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!

    var charts = [Chart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(LineChartCell.nib(), forCellReuseIdentifier: LineChartCell.identifier)
        table.delegate = self
        table.dataSource = self
        
    
        let placeholderChart = Chart(title: "", datasets: [], dates: [], type: ChartType.Line)
        
        // TODO: display loading animtion in placeholders
        self.charts = [placeholderChart, placeholderChart, placeholderChart, placeholderChart]
        
        
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

//        getVaccinePopularityData() { (data) in
//            self.charts[3] = data
//            self.charts[3].type = ChartType.Bar
//            self.table.reloadData()
//        }

    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: LineChartCell.identifier, for: indexPath) as! LineChartCell
        
        cell.configure(with: charts[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
