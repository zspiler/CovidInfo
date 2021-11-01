import Foundation
import Charts

private let title = "Po regijah"

private func createDatasets(data: [RegionsData]) -> [IChartDataSet] {
    
    var po = [ChartDataEntry]()
    var za = [ChartDataEntry]()
    var kr = [ChartDataEntry]()
    var sg = [ChartDataEntry]()
    var ce = [ChartDataEntry]()
    var nm = [ChartDataEntry]()
    var ms = [ChartDataEntry]()
    var mb = [ChartDataEntry]()
    var ng = [ChartDataEntry]()
    var kp = [ChartDataEntry]()
    var lj = [ChartDataEntry]()
    var kk = [ChartDataEntry]()

    for (i, el) in data.enumerated() {
        // display every 5th data
        if (i % 10 != 0) {
            continue
        }
        po.append(ChartDataEntry(x: Double(i), y: Double(el.regions.po.activeCases ?? 0)))
        za.append(ChartDataEntry(x: Double(i), y: Double(el.regions.za.activeCases ?? 0)))
        kr.append(ChartDataEntry(x: Double(i), y: Double(el.regions.kr.activeCases ?? 0)))
        sg.append(ChartDataEntry(x: Double(i), y: Double(el.regions.sg.activeCases ?? 0)))
        ce.append(ChartDataEntry(x: Double(i), y: Double(el.regions.ce.activeCases ?? 0)))
        nm.append(ChartDataEntry(x: Double(i), y: Double(el.regions.nm.activeCases ?? 0)))
        ms.append(ChartDataEntry(x: Double(i), y: Double(el.regions.ms.activeCases ?? 0)))
        mb.append(ChartDataEntry(x: Double(i), y: Double(el.regions.mb.activeCases ?? 0)))
        ng.append(ChartDataEntry(x: Double(i), y: Double(el.regions.ng.activeCases ?? 0)))
        kp.append(ChartDataEntry(x: Double(i), y: Double(el.regions.kp.activeCases ?? 0)))
        lj.append(ChartDataEntry(x: Double(i), y: Double(el.regions.lj.activeCases ?? 0)))
        kk.append(ChartDataEntry(x: Double(i), y: Double(el.regions.kk.activeCases ?? 0)))
    }
    
    let poSet = LineChartDataSet(entries: po)
    styleSet(set: poSet, label: "PO", color: .systemGreen)

    let zaSet = LineChartDataSet(entries: za)
    styleSet(set: zaSet, label: "ZA", color: .systemRed)
    
    let krSet = LineChartDataSet(entries: kr)
    styleSet(set: krSet, label: "KR", color: .systemTeal)

    let sgSet = LineChartDataSet(entries: sg)
    styleSet(set: sgSet, label: "SG", color: .systemBlue)

    let ceSet = LineChartDataSet(entries: ce)
    styleSet(set: ceSet, label: "CE", color: .systemIndigo)

    let nmSet = LineChartDataSet(entries: nm)
    styleSet(set: nmSet, label: "NM", color: .systemPink)

    let msSet = LineChartDataSet(entries: ms)
    styleSet(set: msSet, label: "MS", color: .systemGray)

    let mbSet = LineChartDataSet(entries: mb)
    styleSet(set: mbSet, label: "MB", color: .systemOrange)

    let ngSet = LineChartDataSet(entries: ng)
    styleSet(set: ngSet, label: "NG", color: .systemPurple)

    let kpSet = LineChartDataSet(entries: kp)
    styleSet(set: kpSet, label: "KP", color: .systemYellow)

    let ljSet = LineChartDataSet(entries: lj)
    styleSet(set: ljSet, label: "LJ", color: .brown)

    let kkSet = LineChartDataSet(entries: ng)
    styleSet(set: kkSet, label: "KK", color: .magenta)
    
    return [poSet, zaSet, krSet, sgSet, ceSet, nmSet, msSet, mbSet, ngSet, kpSet, ljSet, kkSet]
}

private func styleSet(set: LineChartDataSet, label: String, color: UIColor) {
    set.label = label
    set.mode = .cubicBezier
    set.lineWidth = 2
    set.drawCirclesEnabled = false
    set.setColor(color)
    set.fillColor = color
    set.fillAlpha = 0.0
    set.drawFilledEnabled = true;
    set.drawHorizontalHighlightIndicatorEnabled = false
}


public func getRegionsData(completion: @escaping (Chart) -> ()) {

    URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/regions/")!, completionHandler: { (data, response, error) in
        guard let data = data, error == nil else {
            // TODO: display error
            return
        }

        do {
            // decode fetched data
            let res = try JSONDecoder().decode([RegionsData].self, from: data)

            // create date labels
            var dates: [Date] = []
            for el in res {
                dates.append(createDate(day: el.day, month: el.month, year: el.year))
            }
            
            DispatchQueue.main.async {
                completion(
                    Chart(title: title,
                          type: ChartType.Line,
                          datasets: createDatasets(data: res),
                          dates: dates,
                          labels: []
                          
                    )
                )
            }

        } catch {
            print("error: \(error)")
            // TODO: display error
        }
    }).resume()
}

private struct RegionsData: Codable {
    let year: Int
    let month: Int
    let day: Int
    
    let regions: Region
    
    struct Region: Codable {
        let po: RegionData
        let za: RegionData
        let kr: RegionData
        let sg: RegionData
        let ce: RegionData
        let nm: RegionData
        let ms: RegionData
        let mb: RegionData
        let ng: RegionData
        let kp: RegionData
        let lj: RegionData
        let kk: RegionData
    }
    
    struct RegionData: Codable {
        let activeCases: Int?
        let confirmedToDate: Int?
    }
    
}
