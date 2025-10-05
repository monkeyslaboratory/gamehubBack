import Fluent

struct CreateGame: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("games")
            .id()
            .field("title", .string, .required)
            .field("subtitle", .string, .required)
            .field("state", .string, .required)
            .field("description_block1", .json, .required)
            .field("description_block2", .json, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("games").delete()
    }
}
