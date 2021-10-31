import Foundation
import Charts

private let title = "Popularnost cepiv"

private func createDatasets(data: [Vaccination]) -> [IChartDataSet] {
    
    
    let latestData = data[data.count-1]
    
    let entries: [BarChartDataEntry] = [
        BarChartDataEntry(x: Double(0), y: Double(latestData.usedByManufacturer.moderna!)),
        BarChartDataEntry(x: Double(1), y: Double(latestData.usedByManufacturer.pfizer!)),
        BarChartDataEntry(x: Double(2), y: Double(latestData.usedByManufacturer.az!)),
        BarChartDataEntry(x: Double(3), y: Double(latestData.usedByManufacturer.janssen!))
    ]
    
    let set =  BarChartDataSet(entries: entries)
    set.setColor(.red)
    set.highlightColor = .blue
    set.highlightAlpha = 1
    
    
    return [set]
    
}

public func getVaccinePopularityData(completion: @escaping (Chart) -> ()) {

    URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/vaccinations/")!, completionHandler: { (data, response, error) in
        guard let data = data, error == nil else {
            // TODO: display error
            return
        }

        do {
            // decode fetched data
            let res = try JSONDecoder().decode([Vaccination].self, from: data)
            
            DispatchQueue.main.async {
                completion(
                    Chart(title: title,
                          datasets: createDatasets(data: res),
                          dates: [],
                          type: ChartType.Bar
                    )
                )
            }

        } catch {
            print("error: \(error.localizedDescription)")
            // TODO: display error
        }
    }).resume()
}
