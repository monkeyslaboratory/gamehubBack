import Vapor

struct ClientAuthMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Missing Bearer token")
        }
        guard
            let iosToken = Environment.get("IOS_TOKEN"),
            let tgToken = Environment.get("TELEGRAM_TOKEN")
        else {
            request.logger.critical("IOS_TOKEN or TELEGRAM_TOKEN are not set in environment")
            throw Abort(.internalServerError, reason: "Server is misconfigured")
        }

        if token != iosToken && token != tgToken {
            throw Abort(.unauthorized, reason: "Invalid client token")
        }

        return try await next.respond(to: request)
    }
}
