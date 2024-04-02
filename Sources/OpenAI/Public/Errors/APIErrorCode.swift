public struct APIErrorCode: Error {
    public let code: Int

    public init(code: Int) {
        self.code = code
    }
}
