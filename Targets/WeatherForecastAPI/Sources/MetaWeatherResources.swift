import Foundation
import SharedModel
import WebClient

public enum MetaWeatherResources {}

// MARK: - Search Location

extension MetaWeatherResources {
    public static func search(
        byLocation name: String
    ) -> LocationResource {
        LocationResource(
            path: "/api/location/search",
            location: name
        )
     }

     public struct LocationResource {
         public let path: String
         public let location: String

         public var get: GetRequest<[Location]> {
             .get(path, query: [("query", self.location)])
         }
     }
}

// MARK: - Location Day

extension MetaWeatherResources {
    public static func weather(
        for date: Date,
        atLocation woeid: Int
    ) -> WeatherLocationDayResource {
        let datePath = dateFormatter(date, "YYYY/M/dd")
        return .init(
            path: "/api/location/\(woeid)/\(datePath)"
        )
     }

     public struct WeatherLocationDayResource {
         public let path: String

         public var get: GetRequest<[Weather]> { .get(path) }
     }
}


private func dateFormatter(
  _ date: Date,
  _ format: String
) -> String {
  let dateformat = DateFormatter()
  dateformat.dateFormat = format
  return dateformat.string(from: date)
}
