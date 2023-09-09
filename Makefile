.PHONY: start-tunnel
start-tunnel:
	docker compose --env-file .env --file docker-compose.yml --project-directory . --project-name rds up --build
	docker compose down

.PHONY: start-tunnel-bg
start-tunnel-bg:
	docker compose --env-file .env --project-directory . --project-name rds up --build -directory

.PHONY: stop-tunnel
stop-tunnel:
	docker compose down
