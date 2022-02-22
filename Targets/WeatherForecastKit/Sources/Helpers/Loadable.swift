import Foundation
import SwiftUI

public typealias LoadableSubject<Value> = Binding<Loadable<Value>>

public enum Loadable<T> {

    case notRequested
    case isLoading
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case let .loaded(value): return value
        case .isLoading: return nil
        default: return nil
        }
    }

    var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }
}

public extension Loadable {
    func map<V>(_ transform: (T) throws -> V) -> Loadable<V> {
        do {
            switch self {
            case .notRequested: return .notRequested
            case let .failed(error): return .failed(error)
            case .isLoading: return .isLoading
            case let .loaded(value):
                return .loaded(try transform(value))
            }
        } catch {
            return .failed(error)
        }
    }
}

extension Loadable: Equatable where T: Equatable {
    public static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case (.isLoading, .isLoading): return true
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}
