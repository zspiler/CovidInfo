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
        selectionStyle = .none
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with chart: Chart) {
        
        chartTitle.text = chart.title
        
        lineChart.frame = CGRect(x: 0, y: 0, width: 375, height: 400)
        lineChart.data = LineChartData(dataSets: chart.datasets)
        
        lineChart.isUserInteractionEnabled = false
        
        lineChart.backgroundColor = UIColor(red: 0.9569, green: 0.9451, blue: 0.8706, alpha: 1.0)
        
        
        //        lineChart.animate(xAxisDuration: 1.5)
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.setLabelCount(6, force: true)
//        lineChart.xAxis.labelTextColor = .white
        lineChart.xAxis.labelTextColor = .black

        lineChart.leftAxis.setLabelCount(6, force: false)
//        lineChart.leftAxis.labelTextColor = .white
//        lineChart.leftAxis.axisLineColor = .white
        lineChart.leftAxis.labelTextColor = .black
        lineChart.leftAxis.axisLineColor = .black
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
      
        lineChart.legend.textColor = .black
        
    }
    
}
