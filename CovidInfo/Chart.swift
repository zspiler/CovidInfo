import Foundation
import Charts

public struct Chart {
    var title: String
    var datasets: [IChartDataSet]
    var dates: [Date] // dates for X-axis labels
    var type: ChartType
}

enum ChartType {
    case Line
    case Bar
}

