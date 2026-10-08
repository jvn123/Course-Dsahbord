protocol SecureStorage: Sendable {
    func save(_ value: String, for key: String) throws
    func read(for key: String) throws -> String?
    func delete(for key: String) throws
}
