import Foundation
import Charts


private let title = "Smrti"


private func createDatasets(data: [Stats]) -> [IChartDataSet] {

    // Cases confirmed each day
    var cases = [ChartDataEntry]()

    var s = Double(data[0].deceased ?? 0)
    
    for (i, el) in data.enumerated() {
        if i % 7 == 0 {
            cases.append(ChartDataEntry(x: Double(i), y: s / 7))
            s = 0
        } else {
            s += Double(el.deceased ?? 0)
        }
    
    }

    let deathsSet = LineChartDataSet(entries: cases)
    deathsSet.label = "Umrlih na dan (7-dnevno povprečje)"
  
    deathsSet.mode = .cubicBezier
    deathsSet.drawValuesEnabled = false
    
    deathsSet.lineWidth = 2
    deathsSet.drawCirclesEnabled = false
    deathsSet.setColor(.systemRed)

    deathsSet.fillColor = .systemRed
    deathsSet.fillAlpha = 0.6
    deathsSet.drawFilledEnabled = true;
    deathsSet.drawHorizontalHighlightIndicatorEnabled = false

    return [deathsSet]


}

public func getDeathsData(completion: @escaping (Chart) -> ()) {

    URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/stats/")!, completionHandler: { (data, response, error) in
        guard let data = data, error == nil else {
            // TODO - display error
            return
        }

        do {
            // decode fetched data
            let res = try JSONDecoder().decode([Stats].self, from: data)

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


private struct Stats: Codable {
    let year: Int
    let month: Int
    let day: Int
    
    let deceased: Int?
}
