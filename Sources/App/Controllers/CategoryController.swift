import Vapor
import Fluent

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categories")
        categories.get(use: index)
        categories.post(use: create)
        categories.group(":categoryID") { cat in
            cat.get(use: get)
            cat.put(use: update)
            cat.delete(use: delete)
        }

        // Вложенный роут для /games/:id/categories
        routes.group("games", ":gameID", "categories") { game in
            game.get(use: listForGame)
        }
    }

    func index(req: Request) async throws -> [Category] {
        try await Category.query(on: req.db).all()
    }

    func listForGame(req: Request) async throws -> [Category] {
        guard let gameID = req.parameters.get("gameID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return try await Category.query(on: req.db)
            .filter(\.$game.$id == gameID)
            .all()
    }

    func get(req: Request) async throws -> Category {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return category
    }

    func create(req: Request) async throws -> Category {
        let category = try req.content.decode(Category.self)
        try await category.save(on: req.db)
        return category
    }

    func update(req: Request) async throws -> Category {
        let updated = try req.content.decode(Category.self)
        guard let category = try await Category.find(updated.id, on: req.db) else {
            throw Abort(.notFound)
        }
        category.title = updated.title
        category.rivFileURL = updated.rivFileURL
        category.isAdult = updated.isAdult
        category.isLocked = updated.isLocked
        category.$game.id = updated.$game.id
        try await category.save(on: req.db)
        return category
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await category.delete(on: req.db)
        return .noContent
    }
}
