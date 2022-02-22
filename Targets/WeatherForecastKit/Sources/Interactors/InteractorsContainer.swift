extension DIContainer {
    public struct Interactors {
        public let getLocationTomorrowWeatherForCity: GetLocationTomorrowWeatherForCity

        public init(
            getLocationTomorrowWeatherForCity: @escaping GetLocationTomorrowWeatherForCity
        ) {
            self.getLocationTomorrowWeatherForCity = getLocationTomorrowWeatherForCity
        }
    }
}
