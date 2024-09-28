build_frontend:
	cd frontend && flutter pub get && flutter build

build_backend:
	@cd backend \
	&& echo 'DATABASE_URL="file:./dev.db"' >> .env \
	&& yarn install && yarn db:init

build: build_frontend build_backend

run_frontend:
	cd frontend && flutter run

run_backend:
	cd backend && yarn dev
