import Fluent

struct AddGameDescriptionBlocks: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema("games")
            .field("description_block1", .json)
            .field("description_block2", .json)
            .update()
    }

    func revert(on db: Database) async throws {
        try await db.schema("games"
    )
            .deleteField("description_block1")
            .deleteField("description_block2")
            .update()
    }
}
