import Foundation
import WebClient
import SharedModel

public typealias MetaWeatherAPIClient = APIClient

public extension APIClient {
    static func prod(
        configuration: URLSessionConfiguration = .default
    ) -> APIClient {
        return .init(
            host: "www.metaweather.com",
            configuration: configuration
        )
    }
}

public extension APIClient {
    func search(byLocation name: String) async throws -> [Location] {
        try await self.send(
            MetaWeatherResources.search(byLocation: name).get
        )
    }

    func weather(for day: Date, at location: Location) async throws -> Weather {
        guard let weatherDay = try await self.send(
            MetaWeatherResources.weather(for: day, atLocation: location.woeid).get
        ).first else {
            throw APIError.resourceNotFound
        }
        
        return weatherDay
    }
}
