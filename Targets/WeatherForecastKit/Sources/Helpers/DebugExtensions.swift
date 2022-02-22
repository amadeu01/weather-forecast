import Foundation
import SharedModel

#if DEBUG

public extension Weather {
    static var mock: Self {
        .init(
            id: 366945,
            state: .snow,
            weatherStateAbbr: "lr",
            windDirectionCompass: "N",
            created: Date(),
            applicableDate: "2013-04-27",
            minTemp: 3.07,
            maxTemp: 10.01,
            theTemp: 10.01,
            windSpeed: 9.85,
            windDirection: 358,
            airPressure: 1015,
            humidity: 74,
            visibility: 9.997862483098704,
            predictability:  75
        )
    }
}

public extension Location {
    static var mock: Self {
        .init(
            title: "London",
            locationType: "City",
            woeid: 44418,
            lattLong: "51.506321,-0.12714"
        )
    }
}

public extension DIContainer.Interactors {
    static var stub: Self {
        .init(getLocationTomorrowWeatherForCity: { _ in (.mock, .mock)})
    }
}

#endif
