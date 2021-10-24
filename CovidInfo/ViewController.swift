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

        URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/hospitals/")!, completionHandler: { [self] (data, response, error) in
            guard let data = data, error == nil else {
                // TODO - display error
                return
            }
            
            do {
                let res = try! JSONDecoder().decode([HospitalData].self, from: data)

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
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)

        lineChart.center = view.center
        view.addSubview(lineChart)

        var entries = [ChartDataEntry]()

        for (i, el) in data.enumerated() {
            entries.append(ChartDataEntry(x: Double(i), y: Double(el.overall.icu.occupied)))
        }

        let set = LineChartDataSet(entries:entries)
        set.colors = ChartColorTemplates.material()

        lineChart.data = LineChartData(dataSet: set)
        print("updated data")
    }
    
}

struct HospitalData: Codable {
    let year: Int
    let month: Int
    let day: Int
    let overall: OverallData
}

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



