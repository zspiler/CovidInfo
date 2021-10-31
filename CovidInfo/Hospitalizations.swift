import Foundation
import Charts

private let title = "Hospitalizacije"

private func createDatasets(data: [HospitalData]) -> [IChartDataSet] {
    // 'Hospitalizirani' data
    var hospiralizedData = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        let hospitalized = Double(el.overall.icu.occupied + el.overall.beds.occupied)
        hospiralizedData.append(ChartDataEntry(x: Double(i), y: hospitalized))
    }
    
    
    let hospSet = LineChartDataSet(entries: hospiralizedData)
    hospSet.label = "Hospitalizirani"
    hospSet.mode = .cubicBezier
    hospSet.cubicIntensity = 1
    hospSet.lineWidth = 2
    hospSet.drawCirclesEnabled = false
    hospSet.setColor(.systemBlue)

    hospSet.fillColor = .systemBlue
    hospSet.fillAlpha = 0.3
    hospSet.drawFilledEnabled = true;
    hospSet.drawHorizontalHighlightIndicatorEnabled = false
    
    // 'Intenzivna terapija' data
    var icuData = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        icuData.append(ChartDataEntry(x: Double(i), y: Double(el.overall.icu.occupied)))
    }

    let icuSet = LineChartDataSet(entries: icuData)
    icuSet.mode = .cubicBezier
    icuSet.label = "Intenzivna terapija"
    icuSet.cubicIntensity = 1
    icuSet.lineWidth = 2
    icuSet.drawCirclesEnabled = false
    icuSet.setColor(.systemRed)

    icuSet.fillColor = .systemRed
    icuSet.fillAlpha = 0.7
    icuSet.drawFilledEnabled = true;
    icuSet.drawHorizontalHighlightIndicatorEnabled = false
    
    return [hospSet, icuSet]
}


public func getHospitalizationData(completion: @escaping (Chart) -> ()) {

    URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/hospitals/")!, completionHandler: { (data, response, error) in
        guard let data = data, error == nil else {
            // TODO - display error
            return
        }

        do {
            // decode fetched data
            let res = try JSONDecoder().decode([HospitalData].self, from: data)

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
            print("error: \(error.localizedDescription)")
            // TODO: display error
        }
    }).resume()
}


struct HospitalData: Codable {
    let year: Int
    let month: Int
    let day: Int
    let overall: OverallData
    
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
}
