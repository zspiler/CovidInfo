//
//  ViewController.swift
//  CovidInfo
//
//  Created by Zan Spiler on 24/10/2021.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate {
    
    // Delegate - if user interacts with chart
    
    var lineChart = LineChartView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
                
        getData { (data) in
            self.draw(data: data)
        }
    }
    
    private func getData(completion: @escaping ([HospitalData]) -> ()) {

        URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/hospitals/")!, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                // TODO - display error
                return
            }
            
            do {
                let res = try JSONDecoder().decode([HospitalData].self, from: data)

                DispatchQueue.main.async {
                    completion(res)
                }
                
            } catch {
                print("error: \(error.localizedDescription)")
                // TODO: display error
            }
        }).resume()
    }
    
    
    override func viewDidLayoutSubviews() {
//        self.draw(data)
    }
    
    
    private func draw(data: [HospitalData]) {
        
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

        // 'Hospitalizirani' data
        var hospiralizedData = [ChartDataEntry]()
        for (i, el) in data.enumerated() {
            let hospitalized = Double(el.overall.icu.occupied + el.overall.beds.occupied)
            hospiralizedData.append(ChartDataEntry(x: Double(i), y: hospitalized))
        }
    
        let set = LineChartDataSet(entries: hospiralizedData)
        set.label = "Hospitalizirani"
        set.mode = .cubicBezier
        set.cubicIntensity = 1
        set.lineWidth = 2
        set.drawCirclesEnabled = false
        set.setColor(.systemBlue)

        set.fillColor = .systemBlue
        set.fillAlpha = 0.3
        set.drawFilledEnabled = true;
        set.drawHorizontalHighlightIndicatorEnabled = false

        
        // 'Intenzivna terapija' data
        var icuData = [ChartDataEntry]()
        for (i, el) in data.enumerated() {
            icuData.append(ChartDataEntry(x: Double(i), y: Double(el.overall.icu.occupied)))
        }

        let set2 = LineChartDataSet(entries: icuData)
        set2.mode = .cubicBezier
        set2.label = "Intenzivna terapija"
        set2.cubicIntensity = 1
        set2.lineWidth = 2
        set2.drawCirclesEnabled = false
        set2.setColor(.systemRed)

        set2.fillColor = .systemRed
        set2.fillAlpha = 0.7
        set2.drawFilledEnabled = true;
        set2.drawHorizontalHighlightIndicatorEnabled = false

        lineChart.data = LineChartData(dataSets: [set, set2])
        
    
        // X-axis
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelCount = set.count
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
    
    struct HospitalData: Codable {
        let year: Int
        let month: Int
        let day: Int
        let overall: OverallData
        
        struct OverallData: Codable {
            let beds: AmountData
            let icu: AmountData
            let vents: AmountData
        }
        
        struct AmountData: Codable {
            let total: Int
            let max: Int
            let occupied: Int
            let free: Int
        }

    }


    
    
}




