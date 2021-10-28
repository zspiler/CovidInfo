import Foundation
import Charts

public struct Chart {
    let title: String
    let datasets: [IChartDataSet]
    let dates: [Date] // dates for X-axis labels
}

