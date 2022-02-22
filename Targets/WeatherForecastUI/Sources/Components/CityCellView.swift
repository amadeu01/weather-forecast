import SharedModel
import SwiftUI
import WeatherForecastKit

typealias LoadLocationWeatherForCity = (String) async throws -> (Location, Weather)

public struct CityCellView: View {
    private let city: String

    @State private(set) var loadableContent: Loadable<(Location, Weather)>
    @Environment(\.injected) private var injected: DIContainer

    private var loadLocationWeatherForCity: LoadLocationWeatherForCity {
        self.injected.interactors.getLocationTomorrowWeatherForCity
    }

    public init(
        _ city: String,
        content: Loadable<(Location, Weather)> = .notRequested
    ) {
        self.city = city
        self._loadableContent = .init(initialValue: content)

    }

    public var body: some View {
        self.contentView
            .animation(.easeOut, value: 0.3)
    }
}

private extension CityCellView {
    var contentView: AnyView {
        switch loadableContent {
        case .notRequested: return AnyView(notRequestedView)
        case .isLoading: return AnyView(loadingView())
        case let .loaded(content):
            return AnyView(loadedView(content))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
}

// MARK: - Loading Content

private extension CityCellView {
    var notRequestedView: some View {
        Text("").onAppear {
            Task { await reload() }
        }
    }

    func loadingView() -> some View {
        ProgressView().padding()
    }

    func failedView(_ error: Error) -> some View {
        ErrorView(
            error: error,
            retryAction: {
                Task { await self.reload() }
            }
        )
    }
}

// MARK: - Side Effects

private extension CityCellView {
    func reload() async {
        do {
            self.loadableContent = .isLoading
            let content = try await self.loadLocationWeatherForCity(self.city)
            self.loadableContent = .loaded(content)
        } catch {
            self.loadableContent = .failed(error)
        }
    }
}

// MARK: - Displaying Content

private extension CityCellView {
    func loadedView(
        _ data: (Location, Weather)
    ) -> some View {
        NavigationLink {
            WeatherView(data.1)
        } label: {
            let (location, weather) = data
            HStack {
                HStack {
                    Text(location.title)
                        .font(.title)
                }

                Spacer()
                weather.theTempTextView
                    .font(.largeTitle)
            }
        }
    }
}

private extension Weather {
    var theTempTextView: Text {
        let temperatureStyle = Measurement<UnitTemperature>.FormatStyle(
            width: .abbreviated,
            numberFormatStyle: .number
        )

        if let temp = self.theTemp {
            return Text(
                Measurement(
                    value: temp,
                    unit: UnitTemperature.celsius
                ),
                format: temperatureStyle
            )
        } else {
            return Text("-")
        }
    }
}

#if DEBUG

struct CityCellView_Previews: PreviewProvider {
    static var previews: some View {
        CityCellView(
            "London",
            content: .isLoading
        )

        CityCellView(
            "London",
            content: .loaded((Location.mock, Weather.mock))
        )
    }
}

#endif
