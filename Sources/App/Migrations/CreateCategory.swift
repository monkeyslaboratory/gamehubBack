import Fluent

struct CreateCategory: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema("categories")
            .id()
            .field("title", .string, .required)
            .field("riv_file_url", .string)
            .field("is_adult", .bool, .required)
            .field("is_locked", .bool, .required)
            .create()
    }

    func revert(on db: Database) async throws {
        try await db.schema("categories").delete()
    }
}
