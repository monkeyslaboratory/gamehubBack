# GameBackend (Swift Vapor)

A minimal, secure backend for iOS + Telegram Mini App.

## Quick start (Docker)

1) Copy env file:
```bash
cp .env.example .env
# Optionally edit tokens and DATABASE_URL
```

2) Build & run:
```bash
docker compose up --build
```

3) Test requests (replace TOKEN with IOS_TOKEN or TELEGRAM_TOKEN):
```bash
# Health
curl -H "Authorization: Bearer ios_secret_abc123" http://localhost:8080/api/health

# Games (with descriptions)
curl -H "Authorization: Bearer ios_secret_abc123" http://localhost:8080/api/games

# Categories
curl -H "Authorization: Bearer tg_secret_xyz456" http://localhost:8080/api/categories

# Question for a specific pair (take gameID & categoryID from previous responses)
curl -H "Authorization: Bearer ios_secret_abc123" http://localhost:8080/api/games/<gameID>/categories/<categoryID>/question
```

## Develop in Xcode (optional)

- Open `Package.swift` in Xcode and build the `Run` scheme.
- Set environment variables in your scheme (Edit Scheme → Run → Arguments → Environment):
  - `DATABASE_URL=postgresql://vapor:vapor@localhost:5432/vapor` (if you run Postgres locally)
  - `IOS_TOKEN=...`
  - `TELEGRAM_TOKEN=...`

## Notes
- All `/api/*` routes are protected by a simple Bearer token middleware.
- CORS is enabled for all origins (adjust in `configure.swift` if needed).
- Database migrations run automatically on startup.
