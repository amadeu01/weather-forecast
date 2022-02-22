import Foundation

public struct Weather: Codable {
    public let id: Int
    public let state: State
    public let weatherStateAbbr: String
    public let windDirectionCompass: String
    public let created: Date?
    public let applicableDate: String
    public let minTemp, maxTemp, theTemp: Double?
    public let windSpeed: Double?
    public let windDirection, airPressure: Double?
    public let humidity: Int?
    public let visibility: Double?
    public let predictability: Int?

    public init(
        id: Int,
        state: Weather.State,
        weatherStateAbbr: String,
        windDirectionCompass: String,
        created: Date,
        applicableDate: String,
        minTemp: Double,
        maxTemp: Double,
        theTemp: Double,
        windSpeed: Double,
        windDirection: Double,
        airPressure: Double,
        humidity: Int,
        visibility: Double,
        predictability: Int
    ) {
        self.id = id
        self.state = state
        self.weatherStateAbbr = weatherStateAbbr
        self.windDirectionCompass = windDirectionCompass
        self.created = created
        self.applicableDate = applicableDate
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.theTemp = theTemp
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.airPressure = airPressure
        self.humidity = humidity
        self.visibility = visibility
        self.predictability = predictability
    }

    enum CodingKeys: String, CodingKey {
        case id
        case state = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability
    }

    public enum State: String, Codable {
        case snow = "Snow"
        case sleet = "Sleet"
        case hail = "Hail"
        case thunderstorm = "Thunderstorm"
        case thunder = "Thunder"
        case heavyRain = "Heavy Rain"
        case lightRain = "Light Rain"
        case showers = "Showers"
        case heavyCloud = "Heavy Cloud"
        case lightCloud = "Light Cloud"
        case clear = "Clear"

        public var abbreviation: String {
            switch self {
            case .snow: return "sn"
            case .sleet: return "sl"
            case .hail: return "h"
            case .thunderstorm: return "t"
            case .thunder: return "t"
            case .heavyRain: return "hr"
            case .lightRain: return "lr"
            case .showers: return "s"
            case .heavyCloud: return "hc"
            case .lightCloud: return "lc"
            case .clear: return "c"
            }
        }

        public var iconUrl: URL {
            let base = "https://www.metaweather.com"
            let pngPath = "/static/img/weather/png/"
            return URL(string: "\(base)\(pngPath)\(self.abbreviation).png")!
        }
    }
}
