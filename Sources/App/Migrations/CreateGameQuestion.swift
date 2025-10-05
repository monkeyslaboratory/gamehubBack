import Fluent

struct CreateGameQuestion: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema("game_questions")
            .id()
            .field("game_id", .uuid, .required, .references("games", "id", onDelete: .cascade))
            .field("category_id", .uuid, .required, .references("categories", "id", onDelete: .cascade))
            .field("text", .string, .required)
            .unique(on: "game_id", "category_id")
            .create()
    }

    func revert(on db: Database) async throws {
        try await db.schema("game_questions").delete()
    }
}
