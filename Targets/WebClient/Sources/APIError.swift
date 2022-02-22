import Foundation

public enum APIError: Error, LocalizedError {
    case resourceNotFound
    case unacceptableStatusCode(Int)

    public var errorDescription: String? {
        switch self {
        case .unacceptableStatusCode(let statusCode):
            return "Response status code was unacceptable: \(statusCode)."
        case .resourceNotFound:
            return "Couldn't find the resource."
        }
    }
}
