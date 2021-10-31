import Foundation
import Charts

public struct Chart {
    var title: String
    var type: ChartType
    var datasets: [IChartDataSet]
    var dates: [Date] // dates for X-axis labels
    var labels: [String]
}

enum ChartType {
    case Line
    case Bar
}

