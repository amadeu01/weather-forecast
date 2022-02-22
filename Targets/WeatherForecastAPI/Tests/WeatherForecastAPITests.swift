import Foundation
import XCTest
@testable import WeatherForecastAPI
import Mocker
import Difference
import SharedModel
import SnapshotTesting

final class WeatherForecastAPITests: XCTestCase {
    var client: MetaWeatherAPIClient!

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        self.client = .prod(configuration: configuration)
        isRecording = false
    }

    func test_WeatherLocationDayResource() async throws {
        self.stubWeatherDayApiCall()

        let date = Date(timeIntervalSince1970: 1645503440.799227)
        let london = Location(
            title: "London", locationType: "", woeid: 44418, lattLong: ""
        )

        let content = try await client.weather(for: date, at: london)

        assertSnapshot(matching: content, as: .dump)
    }

    private func stubWeatherDayApiCall() {
        let url = URL(string: "https://www.metaweather.com/api/location/44418/2022/2/22")!

        let mock = Mock(url: url, dataType: .json, statusCode: 200, data: [
            .get : weatherDayResponse.data(using: .utf8)!
        ])

        mock.register()
    }

    func test_WeatherLocationDayResource_WhenFails() async throws {
        self.stubFailureWeatherDayApiCall()

        let date = Date(timeIntervalSince1970: 1645503440.799227)
        let london = Location(
            title: "London", locationType: "", woeid: 44418, lattLong: ""
        )

        do {
            let _ = try await client.weather(for: date, at: london)
        } catch {
            assertSnapshot(matching: error, as: .dump)
        }

    }

    private func stubFailureWeatherDayApiCall() {
        let url = URL(string: "https://www.metaweather.com/api/location/44418/2022/2/22")!

        let mock = Mock(url: url, dataType: .json, statusCode: 500, data: [
            .get : "[]".data(using: .utf8)!
        ])

        mock.register()
    }

    func test_LocationResource() async throws {
        self.stubLocationSearchApiCall()

        let content = try await client.search(byLocation: "london")

        assertSnapshot(matching: content, as: .dump)
    }

    private func stubLocationSearchApiCall() {
        let url = URL(string: "https://www.metaweather.com/api/location/search?query=london")!

        let mock = Mock(url: url, dataType: .json, statusCode: 200, data: [
            .get : locationResponse.data(using: .utf8)!
        ])

        mock.register()
    }

    func test_LocationResource_WhenAPIFails() async throws {
        self.stubFailureLocationSearchApiCall()

        do {
            let _ = try await client.search(byLocation: "london")
        } catch {
            assertSnapshot(matching: error, as: .dump)
        }
    }

    private func stubFailureLocationSearchApiCall() {
        let url = URL(string: "https://www.metaweather.com/api/location/search?query=london")!

        let mock = Mock(url: url, dataType: .json, statusCode: 500, data: [
            .get : #"[]"#.data(using: .utf8)!
        ])

        mock.register()
    }
}
