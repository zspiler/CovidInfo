import UIKit
import Charts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBOutlet var table: UITableView!

    public var charts = [Chart]()
    var hidden = [false, false, false, false, false, false, false]
    
    let CASES_SWITCH_KEY = "cases"
    let HOSP_SWITCH_KEY = "hospitalizations"
    let VACC_SWITCH_KEY = "vaccinations"
    let DEATHS_SWITCH_KEY = "deaths"
    let REGIONS_SWITCH_KEY = "regions"
    let VACCBYAGE_SWITCH_KEY = "vaccinationsByAge"
    let VACCPOPULARITY_SWITCH_KEY = "vaccinePopularity"
        
    let userDefaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserPreferences()
        self.table.reloadData()
    }
    
    func addLoadingAnimation() {
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.backgroundColor = UIColor(red: 0.07, green: 0.11, blue: 0.20, alpha: 1.00)
        
        addLoadingAnimation()
        checkUserPreferences()

        table.register(LineChartCell.nib(), forCellReuseIdentifier: LineChartCell.identifier)
        table.register(BarChartCell.nib(), forCellReuseIdentifier: BarChartCell.identifier)

        table.delegate = self
        table.dataSource = self


        let placeholder = Chart(title: "", type: ChartType.Line, datasets: [], dates: [], labels:[])

        // placeholder used to maintain chart order
        self.charts = [placeholder, placeholder, placeholder, placeholder, placeholder, placeholder, placeholder]

        var loadedCharts = 0
        
        // Load charts
        getCasesData() { (data) in
            self.charts[0] = data
            self.table.reloadData()
            loadedCharts += 1
            if loadedCharts == self.charts.count {
                self.activityIndicator.stopAnimating()
            }
        }

        getHospitalizationData() { (data) in
            self.charts[1] = data
            self.table.reloadData()
            loadedCharts += 1
            if loadedCharts == self.charts.count {
                self.activityIndicator.stopAnimating()
            }
        }

        getVaccinationsData() { (data) in
            self.charts[2] = data
            self.table.reloadData()
            loadedCharts += 1
            if loadedCharts == self.charts.count {
                self.activityIndicator.stopAnimating()
            }
        }

        getVaccinePopularityData() { (data) in
            self.charts[3] = data
            self.charts[3].type = ChartType.Bar
            self.table.reloadData()
            loadedCharts += 1
            if loadedCharts == self.charts.count {
                self.activityIndicator.stopAnimating()
            }
        }

        getDeathsData() { (data) in
            self.charts[4] = data
            self.table.reloadData()
            loadedCharts += 1
            if loadedCharts == self.charts.count {
                self.activityIndicator.stopAnimating()
            }
        }

        getVaccinationsByAgeData() { (data) in
            self.charts[5] = data
            self.charts[5].type = ChartType.Bar
            self.table.reloadData()
            loadedCharts += 1
            if loadedCharts == self.charts.count {
                self.activityIndicator.stopAnimating()
            }
        }

        getRegionsData() { (data) in
            self.charts[6] = data
            self.table.reloadData()
            loadedCharts += 1
            if loadedCharts == self.charts.count {
                self.activityIndicator.stopAnimating()
            }
        }

            

    }
    
    func checkUserPreferences() {
        hidden[0] = userDefaults.bool(forKey: CASES_SWITCH_KEY) ? false : true
        hidden[1] = userDefaults.bool(forKey: HOSP_SWITCH_KEY) ? false : true
        hidden[2] = userDefaults.bool(forKey: VACC_SWITCH_KEY) ? false : true
        hidden[3] = userDefaults.bool(forKey: DEATHS_SWITCH_KEY) ? false : true
        hidden[4] = userDefaults.bool(forKey: REGIONS_SWITCH_KEY) ? false : true
        hidden[5] = userDefaults.bool(forKey: VACCBYAGE_SWITCH_KEY) ? false : true
        hidden[6] = userDefaults.bool(forKey: VACCPOPULARITY_SWITCH_KEY) ? false : true
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        hidden[indexPath.row] ? (rowHeight = 0.0) : (rowHeight = UITableView.automaticDimension) //(rowHeight = 500.0)
        return rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if charts[indexPath.row].type == ChartType.Line {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineChartCell.identifier, for: indexPath) as! LineChartCell
            cell.configure(with: charts[indexPath.row])
            
            // Hide cell according to user settings
            if (hidden[indexPath.row]) {
                cell.isHidden = true
            }
            
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
