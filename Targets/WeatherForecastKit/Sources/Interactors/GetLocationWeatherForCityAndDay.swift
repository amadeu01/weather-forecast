import Foundation
import WeatherForecastAPI
import SharedModel

public typealias GetLocationWeatherForCityAndDay = (String, Date) async throws -> (Location, Weather)


func makeGetLocationWeatherForCityAndDay(
    from api: MetaWeatherAPIClient
) -> GetLocationWeatherForCityAndDay {
    return { city, date in
        guard let location = ( try await api.search(byLocation: city)).first else {
            throw ResourcesError.resourceNotFound
        }
        print(location)
        do { let _ = try await api.weather(for: date, at: location) } catch {
            print(">>> \(location), \(error)")
        }
        let weather = try await api.weather(for: date, at: location)

        return (location, weather)
    }
}
