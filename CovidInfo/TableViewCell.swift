import UIKit
import Charts

class TableViewCell: UITableViewCell {

    @IBOutlet var chartTitle: UILabel!
    
    
    @IBOutlet var chartContainerView: UIView!
    

    let lineChart = LineChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartContainerView.addSubview(lineChart)
        
        
    }
    
    static let identifier = "TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func configure(with chart: Chart) {
        
        lineChart.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        lineChart.data = LineChartData(dataSets: chart.datasets)
        
//        lineChart.center = self.center
        lineChart.backgroundColor = .gray
        lineChart.animate(xAxisDuration: 1.5)
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.setLabelCount(6, force: true)
        lineChart.xAxis.labelTextColor = .white
        lineChart.leftAxis.setLabelCount(6, force: false)
        lineChart.leftAxis.labelTextColor = .white
        lineChart.leftAxis.axisLineColor = .white
        lineChart.leftAxis.labelPosition = .outsideChart
                
        // X-axis
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawLabelsEnabled = true
        lineChart.xAxis.drawLimitLinesBehindDataEnabled = true
        lineChart.xAxis.avoidFirstLastClippingEnabled = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "sl")
        dateFormatter.dateFormat = "dd MMM"
        
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: chart.dates.map { dateFormatter.string(from: $0) })
        lineChart.xAxis.setLabelCount(6, force: false)
      
        lineChart.legend.textColor = .white
        
    }
    
}
