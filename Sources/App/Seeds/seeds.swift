//
//  seeds.swift
//  GameBackend
//
//  Created by SNNeprimerov on 05.10.2025.
//

import Vapor
import Fluent

struct SeedData: AsyncMigration {
    func prepare(on database: Database) async throws {
        // 1️⃣ Добавляем игру с двумя описательными блоками
        let game = Game(
            title: "Trivia Quest",
            subtitle: "Угадай ответы!",
            state: .available,
            descriptionBlock1: GameDescriptionBlock(
                title: "Как играть",
                subtitle: "Отвечай на вопросы и зарабатывай очки!"
            ),
            descriptionBlock2: GameDescriptionBlock(
                title: "Особенности",
                subtitle: "Разные категории и уровни сложности."
            )
        )
        try await game.create(on: database)
        let gameID = try game.requireID()
        
        // 2️⃣ Добавляем категории (передаём обязательный gameID)
        let category1 = Category(
            title: "Фильмы",
            rivFileURL: "movies.riv",
            isAdult: false,
            isLocked: false,
            gameID: gameID
        )
        let category2 = Category(
            title: "Музыка",
            rivFileURL: "music.riv",
            isAdult: false,
            isLocked: false,
            gameID: gameID
        )
        try await category1.create(on: database)
        try await category2.create(on: database)
        
        // 3️⃣ Добавляем вопрос
        let question = GameQuestion(
            gameID: gameID,
            categoryID: try category1.requireID(),
            text: "Кто сыграл Джокера в фильме 'Тёмный рыцарь'?"
        )
        try await question.create(on: database)
    }

    func revert(on database: Database) async throws {
        try await GameQuestion.query(on: database).delete()
        try await Category.query(on: database).delete()
        try await Game.query(on: database).delete()
    }
}
