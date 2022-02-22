import Foundation
import WeatherForecastAPI
import SharedModel

public typealias GetLocationTomorrowWeatherForCity = (String) async throws -> (Location, Weather)

func makeGetLocationTomorrowWeatherForCity(
    from interactor: @escaping GetLocationWeatherForCityAndDay
) -> GetLocationTomorrowWeatherForCity {
    return { city in
        let today = Date.now
        return try await interactor(city, today.nextDay)
    }
}
