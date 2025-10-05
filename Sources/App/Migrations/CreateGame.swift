import Fluent

struct CreateGame: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema("games")
            .id()
            .field("title", .string, .required)
            .field("subtitle", .string, .required)
            .field("state", .string, .required)
            .field("description_block1", .jsonb)
            .field("description_block2", .jsonb)
            .create()
    }

    func revert(on db: Database) async throws {
        try await db.schema("games").delete()
    }
}
