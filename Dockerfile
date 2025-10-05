# Dev-friendly image: builds & runs in the same container
FROM swift:5.9-jammy

WORKDIR /app
COPY . .

# Pre-resolve dependencies (speed up subsequent builds)
RUN swift package resolve

EXPOSE 8080

# Build & run in release to be closer to prod
CMD bash -lc "swift build -c release && .build/release/Run"
