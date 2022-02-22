import Foundation

// MARK: - Location
public struct Location: Codable {
    public let title: String
    public let locationType: String
    public let woeid: Int
    public let lattLong: String

    public init(
        title: String,
        locationType: String,
        woeid: Int,
        lattLong: String
    ) {
        self.title = title
        self.locationType = locationType
        self.woeid = woeid
        self.lattLong = lattLong
    }

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}
