import Foundation
import Charts

private let title = "Poraba cepiv"

private func createDatasets(data: [Vaccination]) -> [IChartDataSet] {
    
    // MODERNA used
    var usedModerna = [ChartDataEntry]()
    var usedAz = [ChartDataEntry]()
    var usedPfizer = [ChartDataEntry]()
    var usedJanssen = [ChartDataEntry]()

    for (i, el) in data.enumerated() {
        // display every 5th data
        if (i % 10 != 0) {
            continue
        }
        usedModerna.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.moderna ?? 0)))
        usedAz.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.az ?? 0)))
        usedPfizer.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.pfizer ?? 0)))
        usedJanssen.append(ChartDataEntry(x: Double(i), y: Double(el.usedByManufacturer.janssen ?? 0)))
    }

    let mdrnSet = LineChartDataSet(entries: usedModerna)
    styleSet(set: mdrnSet, label: "Moderna", color: .systemGreen)

    let azSet = LineChartDataSet(entries: usedAz)
    styleSet(set: azSet, label: "AstraZeneca", color: .systemRed)

    let pfizerSet = LineChartDataSet(entries: usedPfizer)
    styleSet(set: pfizerSet, label: "Pfizer", color: .systemBlue)


    let janssenSet = LineChartDataSet(entries: usedJanssen)
    styleSet(set: janssenSet, label: "Janssen", color: .systemTeal)

    return [mdrnSet, azSet, pfizerSet, janssenSet]
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



private struct Vaccination: Codable {
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
