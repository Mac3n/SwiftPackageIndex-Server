VAPOR=vapor-beta

build:
	$(VAPOR) build

run:
	$(VAPOR) run

test:
	swift test --enable-test-discovery

test-docker:
	@# run tests inside a docker container
	docker run --rm -v $(PWD):/host -w /host --network="host" vapor/swift:5.2-bionic make test

test-e2e: reset reconcile ingest

migrate:
	$(VAPOR) run migrate

revert:
	$(VAPOR) run migrate --revert

routes:
	$(VAPOR) run routes

ingest:
	$(VAPOR) run ingest --limit 10

reconcile:
	$(VAPOR) run reconcile

db-up:
	docker run --name spi_dev -e POSTGRES_DB=spi_dev -e POSTGRES_USER=spi_dev -e POSTGRES_PASSWORD=xxx -p 5432:5432 -d postgres

db-down:
	docker rm -f spi_dev

reset: db-down db-up migrate
