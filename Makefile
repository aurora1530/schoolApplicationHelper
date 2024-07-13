build_frontend:
	cd frontend && flutter pub get && flutter build

build_backend:
	cd backend && yarn install && yarn db:init

build: build_frontend build_backend

run_frontend:
	cd frontend && flutter run

run_backend:
	cd backend && yarn dev