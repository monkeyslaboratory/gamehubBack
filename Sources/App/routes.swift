import Vapor
import Fluent

public func routes(_ app: Application) throws {
    // MARK: - /api (с токеном)
    let api = app.grouped("api").grouped(ClientAuthMiddleware())

    // Проверка доступности сервера
    api.get("health") { req async throws -> String in
        "ok"
    }

    // MARK: - Games

    // GET /api/games — список всех игр
    api.get("games") { req async throws -> [Game.Output] in
        let games = try await Game.query(on: req.db).all()
        return games.map { $0.output }
    }

    // POST /api/games — создание игры
    api.post("games") { req async throws -> HTTPStatus in
        struct Input: Content {
            let title: String
            let subtitle: String
            let state: GameState
            let descriptionBlock1: GameDescriptionBlock?
            let descriptionBlock2: GameDescriptionBlock?
        }

        let input = try req.content.decode(Input.self)
        let game = Game(
            title: input.title,
            subtitle: input.subtitle,
            state: input.state,
            descriptionBlock1: input.descriptionBlock1,
            descriptionBlock2: input.descriptionBlock2
        )
        try await game.save(on: req.db)
        return .created
    }

    // PUT /api/games/:id — обновление игры
    api.put("games", ":gameID") { req async throws -> HTTPStatus in
        struct Input: Content {
            let title: String
            let subtitle: String
            let state: GameState
            let descriptionBlock1: GameDescriptionBlock?
            let descriptionBlock2: GameDescriptionBlock?
        }

        let input = try req.content.decode(Input.self)

        guard let game = try await Game.find(req.parameters.get("gameID"), on: req.db) else {
            throw Abort(.notFound, reason: "Game not found")
        }

        game.title = input.title
        game.subtitle = input.subtitle
        game.state = input.state
        game.descriptionBlock1 = input.descriptionBlock1
        game.descriptionBlock2 = input.descriptionBlock2

        try await game.save(on: req.db)
        return .ok
    }

    // DELETE /api/games/:id — удаление игры
    api.delete("games", ":gameID") { req async throws -> HTTPStatus in
        guard let game = try await Game.find(req.parameters.get("gameID"), on: req.db) else {
            throw Abort(.notFound, reason: "Game not found")
        }

        try await game.delete(on: req.db)
        return .ok
    }

    // MARK: - Categories
    api.get("categories") { req async throws -> [Category] in
        try await Category.query(on: req.db).all()
    }

    // MARK: - Question
    api.get("games", ":gameID", "categories", ":categoryID", "question") { req async throws -> QuestionResponse in
        guard let game = try await Game.find(req.parameters.get("gameID"), on: req.db) else {
            throw Abort(.notFound, reason: "Game not found")
        }
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound, reason: "Category not found")
        }

        let gameID = try game.requireID()
        let categoryID = try category.requireID()

        guard let q = try await GameQuestion.query(on: req.db)
            .filter(\.$game.$id == gameID)
            .filter(\.$category.$id == categoryID)
            .first()
        else {
            throw Abort(.notFound, reason: "Question not found for this game/category")
        }

        return .init(gameID: gameID, categoryID: categoryID, question: q.text)
    }
}

// MARK: - Response DTO для вопроса
struct QuestionResponse: Content {
    let gameID: UUID
    let categoryID: UUID
    let question: String
}
