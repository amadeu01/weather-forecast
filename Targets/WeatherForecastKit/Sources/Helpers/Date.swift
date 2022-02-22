import Foundation

extension Date {

    var previousDay: Date {
        Calendar.current.date(
            byAdding: DateComponents(day: -1),
            to: self
        )!
    }

    var nextDay: Date {
        Calendar.current.date(
            byAdding: DateComponents(day: +1),
            to: self
        )!
    }
}
