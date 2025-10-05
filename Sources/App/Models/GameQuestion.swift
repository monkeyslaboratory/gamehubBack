import Vapor
import Fluent

final class GameQuestion: Model, Content {
    static let schema = "game_questions"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "game_id")
    var game: Game

    @Parent(key: "category_id")
    var category: Category

    @Field(key: "text")
    var text: String

    init() { }

    init(id: UUID? = nil, gameID: UUID, categoryID: UUID, text: String) {
        self.id = id
        self.$game.id = gameID
        self.$category.id = categoryID
        self.text = text
    }
}
