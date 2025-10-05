import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    // CORS for Telegram Mini App/iOS
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfig))

    // Database
    guard let dbURL = Environment.get("DATABASE_URL"),
          let postgres = PostgresConfiguration(url: dbURL) else {
        app.logger.critical("DATABASE_URL is not set or invalid. Example: postgresql://user:password@host:5432/dbname")
        throw Abort(.internalServerError, reason: "DATABASE_URL not configured")
    }
    app.databases.use(.postgres(configuration: postgres), as: .psql)

    // Migrations
    app.migrations.add(CreateGame())
    app.migrations.add(CreateGameDescription())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateGameQuestion())
    app.migrations.add(SeedInitialData())
    app.migrations.add(SeedData())

    // Auto-migrate on boot
    try app.autoMigrate().wait()

    // Routes
    try routes(app)
}
