import Vapor
import Fluent

// MARK: - Возможные состояния игры
enum GameState: String, Codable, CaseIterable, Content {
    case available
    case paid
    case inDevelopment
}

// MARK: - Модель описательного блока
struct GameDescriptionBlock: Codable, Content {
    var title: String
    var subtitle: String
}

// MARK: - Основная модель игры
final class Game: Model, Content {
    static let schema = "games"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "subtitle")
    var subtitle: String

    @Field(key: "state")
    var state: GameState

    // Два описательных блока (JSON)
    @OptionalField(key: "description_block1")
    var descriptionBlock1: GameDescriptionBlock?

    @OptionalField(key: "description_block2")
    var descriptionBlock2: GameDescriptionBlock?

    init() {}

    init(
        id: UUID? = nil,
        title: String,
        subtitle: String,
        state: GameState,
        descriptionBlock1: GameDescriptionBlock? = nil,
        descriptionBlock2: GameDescriptionBlock? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.state = state
        self.descriptionBlock1 = descriptionBlock1
        self.descriptionBlock2 = descriptionBlock2
    }
}

// MARK: - DTO (для API ответов)
extension Game {
    struct Output: Content {
        let id: UUID?
        let title: String
        let subtitle: String
        let state: GameState
        let descriptionBlock1: GameDescriptionBlock?
        let descriptionBlock2: GameDescriptionBlock?
    }

    var output: Output {
        .init(
            id: self.id,
            title: self.title,
            subtitle: self.subtitle,
            state: self.state,
            descriptionBlock1: self.descriptionBlock1,
            descriptionBlock2: self.descriptionBlock2
        )
    }
}
