import SwiftUI
import WeatherForecastUI
import WeatherForecastKit

@main
struct WeatherForecastApp: App {
    private let container: DIContainer

    init() {
        self.container = .bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            CityListView()
                .environment(\.dynamicTypeSize, .medium)
                .environment(\.colorScheme, .light)
                .environment(\.accessibilityEnabled, false)
                .environment(\.locale, .init(identifier: "en-US"))
                .inject(self.container)
        }
    }
}
