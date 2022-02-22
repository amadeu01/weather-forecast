import SwiftUI
import WeatherForecastKit

public struct CityListView: View {

    public init() {}

    private let cities = [
        "Gothenburg",
        "Stockholm",
        "Mountain View",
        "London",
        "New York",
        "Berlin"
    ]

    public var body: some View {
        NavigationView {
            VStack {
                List(cities, id: \.self) { city in
                    CityCellView(city)
                }
                .navigationBarTitle(Text("Cities"))
            }
        }
    }
}
