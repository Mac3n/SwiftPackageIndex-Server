import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST")!,
        username: Environment.get("DATABASE_USERNAME")!,
        password: Environment.get("DATABASE_PASSWORD")!,
        database: Environment.get("DATABASE_NAME")!
    ), as: .psql)

    app.migrations.add(CreatePackage())
    app.migrations.add(CreateRepository())

    app.commands.use(IngestorCommand(), as: "ingest")
    app.commands.use(ReconcilerCommand(), as: "reconcile")

    // register routes
    try routes(app)
}