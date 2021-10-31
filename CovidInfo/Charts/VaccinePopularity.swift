import Foundation
import Charts

private let title = "Popularnost cepiv"

private func createDatasets(data: [Vaccination]) -> [IChartDataSet] {
    
    
    let latestData = data[data.count-1]
    
    let entries: [BarChartDataEntry] = [
        BarChartDataEntry(x: Double(0), y: Double(latestData.usedByManufacturer.pfizer!)),
        BarChartDataEntry(x: Double(1), y: Double(latestData.usedByManufacturer.az!)),
        BarChartDataEntry(x: Double(2), y: Double(latestData.usedByManufacturer.moderna!)),
        BarChartDataEntry(x: Double(3), y: Double(latestData.usedByManufacturer.janssen!))
    ]
    
    // Sorting not working?
    // entries = entries.sorted { $0.y < $1.y }
    // set.sort(by: { $0.y < $1.y })
    
    let set = BarChartDataSet(entries: entries)
    set.colors = ChartColorTemplates.material()
    
    set.highlightAlpha = 0.2
    
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
                          type: ChartType.Bar,
                          datasets: createDatasets(data: res),
                          dates: [],
                          labels: ["Pfizer", "AstraZeneca", "Moderna", "Janssen"]
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
