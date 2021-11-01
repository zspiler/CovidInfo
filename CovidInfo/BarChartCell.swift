import UIKit
import Charts

class BarChartCell: UITableViewCell {

    @IBOutlet var chartTitle: UILabel!
    @IBOutlet var chartContainerView: UIView!

    let barChart = HorizontalBarChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartContainerView.addSubview(barChart)
    }
    
    static let identifier = "BarChartCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        selectionStyle = .none
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with chart: Chart) {
                
        barChart.frame = CGRect(x: 0, y: 0, width: 375, height: 400)
        chartTitle.text = chart.title
        
        let data = BarChartData(dataSet: chart.datasets[0])
        data.setDrawValues(true)
        data.setValueTextColor(.white)
        barChart.data = data
        
        barChart.legend.enabled = false

        barChart.isUserInteractionEnabled = false
        barChart.backgroundColor = UIColor(red: 0.9569, green: 0.9451, blue: 0.8706, alpha: 1.0)
        
        barChart.rightAxis.enabled = false
        
        // X axis
        barChart.xAxis.labelTextColor = .black
        barChart.xAxis.labelPosition = .bottom
        
        
        barChart.xAxis.drawAxisLineEnabled = true
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.granularityEnabled = false
        barChart.xAxis.setLabelCount(chart.labels.count, force: false)
        barChart.xAxis.axisMaximum = Double(chart.labels.count)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: chart.labels)
        
        barChart.leftAxis.setLabelCount(6, force: false)
        barChart.leftAxis.labelTextColor = .black
        barChart.leftAxis.axisLineColor = .black
        barChart.leftAxis.labelPosition = .outsideChart
                
        
        barChart.drawGridBackgroundEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.xAxis.drawGridLinesEnabled = false
    
    }
    
}
