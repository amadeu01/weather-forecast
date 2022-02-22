import Foundation
import WeatherForecastAPI

public extension DIContainer {
    static func bootstrap() -> DIContainer {
        let api = MetaWeatherAPIClient.prod()
        let getLocationWeatherForCityAndDay = makeGetLocationWeatherForCityAndDay(from: api)
        let getLocationWeatherTomorrowForCity = makeGetLocationTomorrowWeatherForCity(
            from: getLocationWeatherForCityAndDay
        )

        return .init(
            interactors: .init(
                getLocationTomorrowWeatherForCity: getLocationWeatherTomorrowForCity
            ),
            api: api
        )
    }
}

