//
//  SecondViewController.swift
//  CovidInfo
//
//  Created by Zan Spiler on 24/10/2021.
//

import UIKit
import Charts

class PreferencesViewController: UIViewController, ChartViewDelegate {

    var lineChart = LineChartView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
                
        getData { (data) in
            self.draw(data: data)
        }
    }
    
    private func getData(completion: @escaping ([Vaccination]) -> ()) {

        URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/vaccinations/")!, completionHandler: { (data, response, error) in
        
            
            guard let data = data, error == nil else {
                // TODO - display error
                return
            }
          
            do {
                let res = try JSONDecoder().decode([Vaccination].self, from: data)

                DispatchQueue.main.async {
                    completion(res)
                }
                
            } catch {
                print("error: \(error.localizedDescription)")
                print(error)
                // TODO: display error
            }
        }).resume()
    }
    
    
    override func viewDidLayoutSubviews() {
//        self.draw(data)
    }
    
    
    private func draw(data: [Vaccination]) {
        // Init chart
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        lineChart.center = view.center
        view.addSubview(lineChart)
        

        lineChart.backgroundColor = .lightGray

        lineChart.animate(xAxisDuration: 1.5)
        
        lineChart.rightAxis.enabled = false
        
        lineChart.xAxis.setLabelCount(6, force: true)
        lineChart.xAxis.labelTextColor = .white
        
        lineChart.leftAxis.setLabelCount(6, force: false)
        lineChart.leftAxis.labelTextColor = .white
        lineChart.leftAxis.axisLineColor = .white
        lineChart.leftAxis.labelPosition = .outsideChart

        
        // 'deliveredToDate' data
//        var deliveredToDateData = [ChartDataEntry]()
//        for (i, el) in data.enumerated() {
//            deliveredToDateData.append(ChartDataEntry(x: Double(i), y: Double(el.deliveredToDate)))
//        }
//
//        let set = LineChartDataSet(entries: deliveredToDateData)
//        set.label = "Št. dostavljenih doz"
//        set.mode = .cubicBezier
//        set.cubicIntensity = 1
//        set.lineWidth = 2
//        set.drawCirclesEnabled = false
//        set.setColor(.systemBlue)
//
//        set.fillColor = .systemBlue
//        set.fillAlpha = 0.3
//        set.drawFilledEnabled = true;
//        set.drawHorizontalHighlightIndicatorEnabled = false

        
        
        // RAZLIKA MED USED TO DATE & ADMINISTERED TO DATE?
        
        // 'used to-date' data
//        var usedToDateData = [ChartDataEntry]()
//        for (i, el) in data.enumerated() {
//            usedToDateData.append(ChartDataEntry(x: Double(i), y: Double(el.usedToDate ?? 0)))
//        }
//
//        let set2 = LineChartDataSet(entries: usedToDateData)
//        set2.label = "Used doses to date"
//        set2.mode = .cubicBezier
//        set2.cubicIntensity = 1
//        set2.lineWidth = 2
//        set2.drawCirclesEnabled = false
//        set2.setColor(.systemBlue)
//
//        set2.fillColor = .systemBlue
//        set2.fillAlpha = 0.3
//        set2.drawFilledEnabled = true;
//        set2.drawHorizontalHighlightIndicatorEnabled = false
        
        
        // MODERNA used
        var usedModerna = [ChartDataEntry]()
        for (i, el) in data.enumerated() {
            usedModerna.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.moderna ?? 0)))
        }

        let set3 = LineChartDataSet(entries: usedModerna)
        set3.label = "used Moderna"
        set3.mode = .cubicBezier
        set3.cubicIntensity = 1
        set3.lineWidth = 2
        set3.drawCirclesEnabled = false
        set3.setColor(.systemGreen)

        set3.fillColor = .systemGreen
        set3.fillAlpha = 0.0
        set3.drawFilledEnabled = true;
        set3.drawHorizontalHighlightIndicatorEnabled = false
        
        
        // AZ used
        var usedAz = [ChartDataEntry]()
        for (i, el) in data.enumerated() {
            usedAz.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.az ?? 0)))
        }

        let set4 = LineChartDataSet(entries: usedAz)
        set4.label = "used AstraZeneca"
        set4.mode = .cubicBezier
        set4.cubicIntensity = 1
        set4.lineWidth = 2
        set4.drawCirclesEnabled = false
        set4.setColor(.systemRed)

        set4.fillColor = .systemRed
        set4.fillAlpha = 0.0
        set4.drawFilledEnabled = true;
        set4.drawHorizontalHighlightIndicatorEnabled = false
        
        // Pfizer used
        var usedPfizer = [ChartDataEntry]()
        for (i, el) in data.enumerated() {
            usedPfizer.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.pfizer ?? 0)))
        }

        let set5 = LineChartDataSet(entries: usedPfizer)
        set5.label = "used Pfizer"
        set5.mode = .cubicBezier
        set5.cubicIntensity = 1
        set5.lineWidth = 2
        set5.drawCirclesEnabled = false
        set5.setColor(.systemBlue)

        set5.fillColor = .systemBlue
        set5.fillAlpha = 0.0
        set5.drawFilledEnabled = true;
        set5.drawHorizontalHighlightIndicatorEnabled = false
        
        
        // Janssen used
        var usedJanssen = [ChartDataEntry]()
        for (i, el) in data.enumerated() {
            usedJanssen.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.janssen ?? 0)))
        }

        let set6 = LineChartDataSet(entries: usedJanssen)
        set6.label = "used Janssen"
        set6.mode = .cubicBezier
        set6.cubicIntensity = 1
        set6.lineWidth = 2
        set6.drawCirclesEnabled = false
        set6.setColor(.systemTeal)

        set6.fillColor = .systemTeal
        set6.fillAlpha = 0.0
        set6.drawFilledEnabled = true;
        set6.drawHorizontalHighlightIndicatorEnabled = false
        
    

        lineChart.data = LineChartData(dataSets: [set3, set4, set5, set6])

    
        // X-axis
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelCount = set3.count
        lineChart.xAxis.drawLabelsEnabled = true
        lineChart.xAxis.drawLimitLinesBehindDataEnabled = true
        lineChart.xAxis.avoidFirstLastClippingEnabled = true
       
        var dates: [Date] = []
        for el in data {
            dates.append(createDate(day: el.day, month: el.month, year: el.year))
        }
                
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "sl")
        dateFormatter.dateFormat = "dd MMM"
        
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates.map { dateFormatter.string(from: $0) })
        lineChart.xAxis.setLabelCount(6, force: false)
        
        
        lineChart.legend.textColor = .white
        
        
    }
    
    private func createDate(day: Int, month: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+1")
        
        let userCalendar = Calendar(identifier: .gregorian)
        return userCalendar.date(from: dateComponents)!
    }
    

}



struct Vaccination: Codable {
    let year: Int
    let month: Int
    let day: Int
    
    let administered: Administered
    let administered2nd: Administered
    let administered3rd: Administered

    let usedToDate: Int?
    let deliveredToDate: Int
    
    let usedByManufacturer: Manufacturer
    
    struct Administered: Codable {
        let today: Int?
        let toDate: Int?
    }
    
    struct Manufacturer: Codable {
        let moderna: Int?
        let az: Int?
        let pfizer: Int?
        let janssen: Int?
    }
}
