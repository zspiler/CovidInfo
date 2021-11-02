import UIKit
import Charts

class LineChartCell: UITableViewCell {

    @IBOutlet var chartTitle: UILabel!
    @IBOutlet var chartContainerView: UIView!

    let lineChart = LineChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartContainerView.addSubview(lineChart)
    }
    
    static let identifier = "LineChartCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        selectionStyle = .none
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with chart: Chart) {
    
        lineChart.frame = CGRect(x: 0, y: 0, width: 375, height: 400)
        chartTitle.text = chart.title
        
        lineChart.data = LineChartData(dataSets: chart.datasets)
        
        lineChart.isUserInteractionEnabled = false
        
        
        lineChart.backgroundColor = UIColor(red: 0.118, green: 0.153, blue: 0.271, alpha: 1.0)
        
        lineChart.legend.textColor = .white
        
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
        
    }
    
}
