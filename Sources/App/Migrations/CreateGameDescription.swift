import Fluent

struct CreateGameDescription: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema("game_descriptions")
            .id()
            .field("game_id", .uuid, .required, .references("games", "id", onDelete: .cascade))
            .field("title", .string, .required)
            .field("subtitle", .string, .required)
            .create()
    }

    func revert(on db: Database) async throws {
        try await db.schema("game_descriptions").delete()
    }
}
