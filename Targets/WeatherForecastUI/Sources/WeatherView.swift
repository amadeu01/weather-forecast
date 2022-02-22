import SwiftUI
import SharedModel
import WeatherForecastKit

public struct WeatherView: View {
    private let data: Weather

    public init(_ data: Weather) {
        self.data = data
    }

    private let temperatureStyle = Measurement<UnitTemperature>.FormatStyle(
        width: .abbreviated,
        numberFormatStyle: .number
    )

    private let speedStyle = Measurement<UnitSpeed>.FormatStyle(
        width: .abbreviated,
        numberFormatStyle: .number
    )

    public var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 16)
            self.summary
            self.bodyDetail
            Spacer()
        }.navigationTitle("Tomorrow Forecast")
    }

    private var summary: some View {
        HStack {
            Spacer()
            AsyncImage(
                url: data.state.iconUrl,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 40, maxHeight: 40)
                },
                placeholder: {
                    ProgressView()
                }
            )
            Spacer().frame(width: 16)

            Text(data.state.rawValue)
                .font(.title)
                .fontWeight(.light)
            Spacer()
        }.padding(0)
    }

    private var bodyDetail: some View {
        HStack {
            self.tempText
                .font(.system(size: 80))
                .fontWeight(.ultraLight)

            VStack(alignment: .leading) {
                HStack {
                    Text("MAX TEMP")
                    Spacer()
                    self.maxTemp
                }.padding(.bottom, 1)

                HStack {
                    Text("WIND SPEED")
                    Spacer()
                    self.windSpeed
                }.padding(.bottom, 1)

                HStack {
                    Text("HUMIDITY")
                    Spacer()
                    if let humidity = data.humidity {
                        Text("\(humidity) %")
                    } else {
                        Text("-")
                    }
                }.padding(.bottom, 1)

                HStack {
                    Text("PREDICTABILITY")
                    Spacer()
                    if let predictability = data.predictability {
                        Text("\(predictability) %")
                    } else {
                        Text("-")
                    }
                }.padding(.bottom, 1)
            }.font(.caption)
        }.padding()
    }

    private var tempText: Text {
        if let temp = data.theTemp {
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

    private var maxTemp: some View {
        if let temp = data.maxTemp {
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

    private var windSpeed: some View {
        if let speed = data.windSpeed {
            return Text(
                Measurement(
                    value: speed,
                    unit: UnitSpeed.milesPerHour
                ),
                format: speedStyle
            )
        } else {
            return Text("-")
        }
    }
}


#if DEBUG

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(.mock)
    }
}

#endif
