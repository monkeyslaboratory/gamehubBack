import Fluent

struct AddGameRelationToCategory: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema("categories")
            .field("game_id", .uuid, .references("games", "id", onDelete: .cascade))
            .update()
    }

    func revert(on db: Database) async throws {
        try await db.schema("categories")
            .deleteField("game_id")
            .update()
    }
}
//
//  AddGameRelationToCategory.swift
//  GameBackend
//
//  Created by SNNeprimerov on 05.10.2025.
//

