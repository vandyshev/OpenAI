public enum Either<T, U> {
    case left(T)
    case right(U)
}

public extension Either {
    var left: T? {
        switch self {
        case .left(let left): left
        default: nil
        }
    }

    var right: U? {
        switch self {
        case .right(let right): right
        default: nil
        }
    }

    var isLeft: Bool {
        switch self {
        case .left: true
        default: false
        }
    }
    var isRight: Bool {
        return !isLeft
    }

    func bimap<V, W>(leftBy lf: (T) -> V, rightBy rf: (U) -> W) -> Either<V, W> {
        return either(ifLeft: { .left(lf($0)) }, ifRight: { .right(rf($0)) })
    }

    func either<R>(ifLeft: (T) throws -> R, ifRight: (U) throws -> R) rethrows -> R {
        switch self {
        case let .left(x):
            return try ifLeft(x)
        case let .right(x):
            return try ifRight(x)
        }
    }

    func either<R>(_ left: @escaping (T) -> R) -> ((U) -> R) -> R {
        return { self.either(ifLeft: left, ifRight: $0) }
    }
}

extension Either: Equatable where T: Equatable, U: Equatable {
    public static func == (lhs: Either<T, U>, rhs: Either<T, U>) -> Bool {
        switch (lhs.left, rhs.left) {
        case let (left?, right?): return left == right
        case (nil, nil):
            switch (lhs.right, rhs.right) {
            case let (left?, right?): return left == right
            default: return false
            }
        default: return false
        }
    }
}

extension Either where T: Equatable, U == Void {
    public static func == (lhs: Either<T, U>, rhs: Either<T, U>) -> Bool {
        switch (lhs, rhs) {
        case (.left(let left), .left(let right)): return left == right
        case (.right, .right): return true
        default: return false
        }
    }
}

extension Either where T == Void, U: Equatable {
    public static func == (lhs: Either<T, U>, rhs: Either<T, U>) -> Bool {
        switch (lhs, rhs) {
        case (.left, .left): return true
        case (.right(let left), .right(let right)): return left == right
        default: return false
        }
    }
}

extension Either: Codable where T: Codable, U: Codable {
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .left(let value): try value.encode(to: encoder)
        case .right(let value): try value.encode(to: encoder)
        }
    }
}
