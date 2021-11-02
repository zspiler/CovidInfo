import Foundation
import Charts

private let title = "Cepljenost po starosti"

private func createDatasets(data: [Vaccination]) -> [IChartDataSet] {
    
    
    let latestData = data[data.count-1]
    
    var entries: [BarChartDataEntry] = []
    
    for i in 0...15 {
        let entry = BarChartDataEntry(x: Double(i), y: Double(latestData.administeredPerAge[i].administered ?? 0))
        entries.append(entry)
    }
    
    let set = BarChartDataSet(entries: entries)
    set.colors = ChartColorTemplates.joyful()
    
    set.highlightAlpha = 0.2
    
    return [set]
}

public func getVaccinationsByAgeData(completion: @escaping (Chart) -> ()) {

    URLSession.shared.dataTask(with: URL(string: "https://api.sledilnik.org/api/vaccinations/")!, completionHandler: { (data, response, error) in
        guard let data = data, error == nil else {
            // TODO: display error
            return
        }

        do {
            // decode fetched data
            let res = try JSONDecoder().decode([Vaccination].self, from: data)
        
            var labels = [String]()
            
            for group in res[res.count-1].administeredPerAge {
                if group.ageTo != nil {
                    labels.append("\(group.ageFrom)-\(group.ageTo! ?? 0)")
                } else {
                    labels.append("\(group.ageFrom)+")
                }
                
                
                
//                println("something " + (fileExists ? "exists" : "does not exist"))
            }
            
            DispatchQueue.main.async {
                completion(
                    Chart(title: title,
                          type: ChartType.Bar,
                          datasets: createDatasets(data: res),
                          dates: [],
//                          labels: ["0-17", "18-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59",
//                                   "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90+"]
                          labels: labels
                    )
                )
            }

        } catch {
            print("error: \(error)")
            // TODO: display error
        }
    }).resume()
}

private struct Vaccination: Codable {
    
    let administeredPerAge: [Administered]
  
    struct Administered: Codable {
        let ageFrom: Int
        let ageTo: Int?
        let administered: Int?
        let administered2nd: Int?
        let administered3rd: Int?
    }
}
