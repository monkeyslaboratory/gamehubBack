import Fluent
import Vapor

struct SeedInitialData: AsyncMigration {
    func prepare(on db: Database) async throws {
        // ✅ Создаём игру с двумя описательными блоками
        let game = Game(
            title: "Trivia Rush",
            subtitle: "Успей ответить первым",
            state: .available,
            descriptionBlock1: GameDescriptionBlock(
                title: "Как играть",
                subtitle: "Отвечай на вопросы по категориям"
            ),
            descriptionBlock2: GameDescriptionBlock(
                title: "Цель",
                subtitle: "Набери максимум баллов до финиша"
            )
        )

        try await game.save(on: db)
        let gameID = try game.requireID()

        // ✅ Категории (передаём gameID)
        let c1 = Category(title: "Кино", rivFileURL: nil, isAdult: false, isLocked: false, gameID: gameID)
        let c2 = Category(title: "Наука", rivFileURL: "https://cdn.example.com/anim/science.riv", isAdult: false, isLocked: false, gameID: gameID)
        let c3 = Category(title: "18+", rivFileURL: nil, isAdult: true, isLocked: true, gameID: gameID)
        try await c1.save(on: db)
        try await c2.save(on: db)
        try await c3.save(on: db)

        // ✅ Вопрос для игры + категории
        let q = GameQuestion(
            gameID: gameID,
            categoryID: try c1.requireID(),
            text: "Кто режиссёр фильма 'Интерстеллар'?"
        )
        try await q.save(on: db)
    }

    func revert(on db: Database) async throws {
        try await GameQuestion.query(on: db).delete()
        try await Category.query(on: db).delete()
        try await Game.query(on: db).delete()
    }
}
