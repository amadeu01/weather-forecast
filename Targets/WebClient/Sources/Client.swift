import Foundation

public protocol APIClientDelegate: AnyObject {
    func client(
        _ client: APIClient,
        willSendRequest request: inout URLRequest
    ) async throws

    func shouldClientRetry(
        _ client: APIClient,
        withError error: Error
    ) async throws -> Bool

    func client(
        _ client: APIClient,
        didReceiveInvalidResponse response: HTTPURLResponse,
        data: Data
    ) -> Error
}

public actor APIClient {
    private let session: URLSession
    private let host: String
    private let delegate: APIClientDelegate
    private let serializer: Serializer

    public init(
        host: String,
        configuration: URLSessionConfiguration = .default,
        delegate: APIClientDelegate? = nil,
        serializer: Serializer = .init()
    ) {
        self.host = host
        self.session = URLSession(configuration: configuration)
        self.delegate = delegate ?? DefaultAPIClientDelegate()
        self.serializer = serializer
    }
}

extension APIClient {
    public func send<T: Decodable>(
        _ request: Request<Void, T>
    ) async throws -> T {
        try await send(request, serializer.decode)
    }

    private func send<T: Decodable>(
        _ request: Request<Void, T>,
        _ decode: @escaping (Data) async throws -> T
    ) async throws -> T {
        let request = try await makeRequest(for: request)
        let (data, response) = try await send(request)
        try validate(response: response, data: data)
        return try await decode(data)
    }

    public func send<K: Encodable, T: Decodable>(
        _ request: Request<K, T>
    ) async throws -> T {
        try await send(request, serializer.decode)
    }

    private func send<K: Encodable, T: Decodable>(
        _ request: Request<K, T>,
        _ decode: @escaping (Data) async throws -> T
    ) async throws -> T {
        let request = try await makeRequest(for: request)
        let (data, response) = try await send(request)
        try validate(response: response, data: data)
        return try await decode(data)
    }

    private func makeRequest<T: Decodable>(
        for request: Request<Void, T>
    ) async throws -> URLRequest {
        let url = try makeURL(
            path: request.path,
            query: request.query
        )

        return try await makeRequest(
            url: url,
            method: request.method,
            headers: request.headers
        )
    }

    private func makeRequest<K: Encodable, T: Decodable>(
        for request: Request<K, T>
    ) async throws -> URLRequest {
        let url = try makeURL(
            path: request.path,
            query: request.query
        )

        return try await makeRequest(
            url: url,
            method: request.method,
            body: request.body,
            headers: request.headers
        )
    }

    private func makeURL(
        path: String,
        query: [(String, String?)]?
    ) throws -> URL {
        guard let url = URL(string: path),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                  throw URLError(.badURL)
              }
        if path.starts(with: "/") {
            components.scheme = "https"
            components.host = self.host
        }
        if let query = query {
            components.queryItems = query.map(URLQueryItem.init)
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }

    private func makeRequest(
        url: URL,
        method: String,
        headers: [String: String]?
    ) async throws -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )
        return request
    }

    private func makeRequest<Body: Encodable>(
        url: URL,
        method: String,
        body: Body?,
        headers: [String: String]?
    ) async throws -> URLRequest {
        var request = try await makeRequest(
            url: url,
            method: method,
            headers: headers
        )

        if let body = body {
            request.httpBody = try await serializer.encode(body)
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        }

        return request
    }

    private func send(
        _ request: URLRequest
    ) async throws -> (Data, URLResponse) {
        try await session.data(for: request, delegate: nil)
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        if !(200..<300).contains(httpResponse.statusCode) {
            throw delegate.client(
                self,
                didReceiveInvalidResponse: httpResponse,
                data: data
            )
        }
    }
}
