import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    // MARK: - CORS (для iOS и Telegram Mini App)
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfig))

    // MARK: - Database
    if let dbURL = Environment.get("DATABASE_URL") {
        // ✅ Подключение через полный URL
        app.logger.info("Using DATABASE_URL for Postgres connection")
        let postgres = try SQLPostgresConfiguration(url: dbURL)
        app.databases.use(
            .postgres(configuration: postgres),
            as: .psql
        )
    } else {
        // ✅ Подключение через отдельные переменные (Docker Compose / локально)
        app.logger.info("Using individual DATABASE_* env variables for Postgres connection")

        let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
        let port = Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432
        let username = Environment.get("DATABASE_USERNAME") ?? "vapor"
        let password = Environment.get("DATABASE_PASSWORD") ?? "vapor"
        let database = Environment.get("DATABASE_NAME") ?? "vapor"

        app.databases.use(.postgres(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database
        ), as: .psql)
    }

    // MARK: - Server config (чтобы слушать снаружи)
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    // MARK: - Migrations
    app.migrations.add(CreateGame())
    app.migrations.add(CreateCategory())
    app.migrations.add(AddGameRelationToCategory())
    app.migrations.add(CreateGameQuestion())
    app.migrations.add(SeedInitialData())
    app.migrations.add(SeedData())

    // MARK: - Auto-migrate
    try app.autoMigrate().wait()

    // MARK: - Routes
    try routes(app)
}
