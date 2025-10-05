import Fluent
import Vapor

final class Category: Model, Content {
    static let schema = "categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @OptionalField(key: "riv_file_url")
    var rivFileURL: String?

    @Field(key: "is_adult")
    var isAdult: Bool

    @Field(key: "is_locked")
    var isLocked: Bool

    @Parent(key: "game_id")
    var game: Game

    init() {}

    init(
        id: UUID? = nil,
        title: String,
        rivFileURL: String?,
        isAdult: Bool,
        isLocked: Bool,
        gameID: UUID
    ) {
        self.id = id
        self.title = title
        self.rivFileURL = rivFileURL
        self.isAdult = isAdult
        self.isLocked = isLocked
        self.$game.id = gameID
    }
}
