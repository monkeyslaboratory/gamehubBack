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
    guard let dbURL = Environment.get("DATABASE_URL") else {
        app.logger.critical("DATABASE_URL is not set. Example: postgresql://user:password@host:5432/dbname")
        throw Abort(.internalServerError, reason: "DATABASE_URL not configured")
    }

    let postgres = try SQLPostgresConfiguration(url: dbURL)

    app.databases.use(
        .postgres(
            configuration: postgres,
            maxConnectionsPerEventLoop: 5,
            connectionPoolTimeout: .seconds(10),
            encodingContext: .default,
            decodingContext: .default,
            sqlLogLevel: .debug
        ),
        as: .psql
    )

    // MARK: - Migrations
    app.migrations.add(CreateGame())
    app.migrations.add(CreateGameDescription())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateGameQuestion())
    app.migrations.add(SeedInitialData())
    app.migrations.add(SeedData())

    // MARK: - Auto-migrate on boot
    try app.autoMigrate().wait()

    // MARK: - Routes
    try routes(app)
}
