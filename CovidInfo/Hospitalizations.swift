import Foundation
import Charts


private func createDatasets(data: [HospitalData]) -> [IChartDataSet] {
    // 'Hospitalizirani' data
    var hospiralizedData = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        let hospitalized = Double(el.overall.icu.occupied + el.overall.beds.occupied)
        hospiralizedData.append(ChartDataEntry(x: Double(i), y: hospitalized))
    }
    

    let set = LineChartDataSet(entries: hospiralizedData)
    set.label = "Hospitalizirani"
    set.mode = .cubicBezier
    set.cubicIntensity = 1
    set.lineWidth = 2
    set.drawCirclesEnabled = false
    set.setColor(.systemBlue)

    set.fillColor = .systemBlue
    set.fillAlpha = 0.3
    set.drawFilledEnabled = true;
    set.drawHorizontalHighlightIndicatorEnabled = false

    
    // 'Intenzivna terapija' data
    var icuData = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        icuData.append(ChartDataEntry(x: Double(i), y: Double(el.overall.icu.occupied)))
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
    
    return [set, set2]
    
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
                    Chart(title: "Hospitalizacije",
                          datasets: createDatasets(data: res),
                          dates: dates
                    )
                )
            }

        } catch {
            print("error: \(error.localizedDescription)")
            // TODO: display error
        }
    }).resume()
}


public struct HospitalData: Codable {
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

private func createDate(day: Int, month: Int, year: Int) -> Date {
    var dateComponents = DateComponents()
    
    dateComponents.day = day
    dateComponents.month = month
    dateComponents.year = year
    dateComponents.timeZone = TimeZone(abbreviation: "GMT+1")
    
    let userCalendar = Calendar(identifier: .gregorian)
    return userCalendar.date(from: dateComponents)!
}




