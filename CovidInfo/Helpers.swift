import Foundation

public func createDate(day: Int, month: Int, year: Int) -> Date {
    var dateComponents = DateComponents()

    dateComponents.day = day
    dateComponents.month = month
    dateComponents.year = year
    dateComponents.timeZone = TimeZone(abbreviation: "GMT+1")

    let userCalendar = Calendar(identifier: .gregorian)
    return userCalendar.date(from: dateComponents)!
}
