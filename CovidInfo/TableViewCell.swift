//
//  TableViewCell.swift
//  CovidInfo
//
//  Created by Zan Spiler on 27/10/2021.
//

import UIKit
import Charts

class TableViewCell: UITableViewCell {

    @IBOutlet var chartTitle: UILabel!
    
    @IBOutlet var chartContainer: UIView!

    let lineChart = LineChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartContainer.addSubview(lineChart)
    }
    
    static let identifier = "TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Int) {
        
        print("configure: ")
        print(model)
//        self.chartTitle.text = model.chartTitle
//        lineChart = LineChartView()
//
////        self.v = lineChart
//
////        v.addSubview(lineChart)
//
//        // Init chart
//        lineChart.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
////        lineChart.center = view.center
////        self.view.addSubview(lineChart)
//
//        lineChart.backgroundColor = .red
//
//        var icuData = [ChartDataEntry]()
//        for i in 1...10 {
//            icuData.append(ChartDataEntry(x: Double(i), y: Double(i)))
//        }
//
//        let set2 = LineChartDataSet(entries: icuData)
//        set2.mode = .cubicBezier
//        set2.label = "Intenzivna terapija"
//        set2.cubicIntensity = 1
//        set2.lineWidth = 2
//        set2.drawCirclesEnabled = false
//        set2.setColor(.systemRed)
//
//        set2.fillColor = .systemRed
//        set2.fillAlpha = 0.7
//        set2.drawFilledEnabled = true;
//        set2.drawHorizontalHighlightIndicatorEnabled = false
//
//        lineChart.data = LineChartData(dataSets: [set2])
        
        lineChart.frame = CGRect(x: 0, y: 0, width: 335, height: 409)

        var icuData = [ChartDataEntry]()
        for i in 1...10 {
            icuData.append(ChartDataEntry(x: Double(i), y: Double(i)))
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

        lineChart.data = LineChartData(dataSets: [set2])

        
    }
    


    
}
