import Foundation
import Charts


private let title = "Stanje"

private func createDatasets(data: [Stats]) -> [IChartDataSet] {

    // Cases confirmed each day
    var cases = [ChartDataEntry]()
 
    for (i, el) in data.enumerated() {
        guard let positive = el.tests.positive.today else {
            continue
        }
        guard let performed = el.tests.performed.today else {
            continue
        }
        cases.append(ChartDataEntry(x: Double(i), y: Double(positive) / Double(performed)))
    }

    let casesSet = LineChartDataSet(entries: cases)
    casesSet.label = "Delež pozitivnih testov"
  
    casesSet.mode = .cubicBezier
    
    casesSet.lineWidth = 2
    casesSet.drawCirclesEnabled = false
    casesSet.setColor(.systemPink)

    casesSet.fillColor = .systemPink
    casesSet.fillAlpha = 0.5
    casesSet.drawFilledEnabled = true;
    casesSet.drawHorizontalHighlightIndicatorEnabled = false

    return [casesSet]
}

public func getCasesData(completion: @escaping (Chart) -> ()) {

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
    
    let tests: Tests
//    let vaccination: Vaccination
    
    struct Tests: Codable {
        let performed: Performed
        let positive: Positive
    }
    
    struct Performed: Codable {
        let today: Int?
        let toDate: Int?
    }

    struct Positive: Codable {
        let today: Int?
        let toDate: Int?
    }

}
