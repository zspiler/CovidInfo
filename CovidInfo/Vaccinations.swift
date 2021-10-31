import Foundation
import Charts

private let title = "Poraba cepiv"

private func createDatasets(data: [Vaccination]) -> [IChartDataSet] {
    
    // MODERNA used
    var usedModerna = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        // display every 5th data
        if (i % 10 != 0) {
            continue
        }
        usedModerna.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.moderna ?? 0)))
    }

    let mdrnSet = LineChartDataSet(entries: usedModerna)
    mdrnSet.label = "Moderna"
    mdrnSet.mode = .cubicBezier

    mdrnSet.lineWidth = 2
    mdrnSet.drawCirclesEnabled = false
    mdrnSet.setColor(.systemGreen)

    mdrnSet.fillColor = .systemGreen
    mdrnSet.fillAlpha = 0.0
    mdrnSet.drawFilledEnabled = true;
    mdrnSet.drawHorizontalHighlightIndicatorEnabled = false
    
    
    // AZ used
    var usedAz = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        // display every 5th data
        if (i % 10 != 0) {
            continue
        }
        usedAz.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.az ?? 0)))
    }

    let azSet = LineChartDataSet(entries: usedAz)
    azSet.label = "AstraZeneca"
    azSet.mode = .cubicBezier
    azSet.lineWidth = 2
    azSet.drawCirclesEnabled = false
    azSet.setColor(.systemRed)

    azSet.fillColor = .systemRed
    azSet.fillAlpha = 0.0
    azSet.drawFilledEnabled = true;
    azSet.drawHorizontalHighlightIndicatorEnabled = false
    
    // Pfizer used
    var usedPfizer = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        // display every 5th data
        if (i % 10 != 0) {
            continue
        }
        usedPfizer.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.pfizer ?? 0)))
    }

    let pfizerSet = LineChartDataSet(entries: usedPfizer)
    pfizerSet.label = "Pfizer"
    pfizerSet.mode = .cubicBezier
    pfizerSet.lineWidth = 2
    pfizerSet.drawCirclesEnabled = false
    pfizerSet.setColor(.systemBlue)

    pfizerSet.fillColor = .systemBlue
    pfizerSet.fillAlpha = 0.0
    pfizerSet.drawFilledEnabled = true;
    pfizerSet.drawHorizontalHighlightIndicatorEnabled = false
    
    
    // Janssen used
    var usedJanssen = [ChartDataEntry]()
    for (i, el) in data.enumerated() {
        // display every 5th data
        if (i % 10 != 0) {
            continue
        }
        usedJanssen.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.janssen ?? 0)))
    }

    let janssenSet = LineChartDataSet(entries: usedJanssen)
    janssenSet.label = "Janssen"
    janssenSet.mode = .cubicBezier
    janssenSet.lineWidth = 2
    janssenSet.drawCirclesEnabled = false
    janssenSet.setColor(.systemTeal)

    janssenSet.fillColor = .systemTeal
    janssenSet.fillAlpha = 0.0
    janssenSet.drawFilledEnabled = true;
    janssenSet.drawHorizontalHighlightIndicatorEnabled = false
    
    return [mdrnSet, azSet, pfizerSet, janssenSet]

    
}

public func getVaccinationsData(completion: @escaping (Chart) -> ()) {

    URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/vaccinations/")!, completionHandler: { (data, response, error) in
        guard let data = data, error == nil else {
            // TODO: display error
            return
        }

        do {
            // decode fetched data
            let res = try JSONDecoder().decode([Vaccination].self, from: data)

            // create date labels
            var dates: [Date] = []
            for el in res {
                dates.append(createDate(day: el.day, month: el.month, year: el.year))
            }
            
            DispatchQueue.main.async {
                completion(
                    Chart(title: title,
                          datasets: createDatasets(data: res),
                          dates: dates,
                          type: ChartType.Line
                    )
                )
            }

        } catch {
            print("error: \(error.localizedDescription)")
            // TODO: display error
        }
    }).resume()
}



struct Vaccination: Codable {
    let year: Int
    let month: Int
    let day: Int
    
    let administered: Administered
    let administered2nd: Administered
    let administered3rd: Administered

    let usedToDate: Int?
    let deliveredToDate: Int
    
    let usedByManufacturer: Manufacturer
    
    struct Administered: Codable {
        let today: Int?
        let toDate: Int?
    }
    
    struct Manufacturer: Codable {
        let moderna: Int?
        let az: Int?
        let pfizer: Int?
        let janssen: Int?
    }
}
