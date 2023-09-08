BACALHAU_DUCKDB_VER := 0.0.1

# Bacalhau supports only amd64 images.
bacalhau-build:
	docker build --platform linux/amd64 -t 31z4/bacalhau-duckdb:${BACALHAU_DUCKDB_VER} bacalhau

bacalhau-push:
	docker push 31z4/bacalhau-duckdb:${BACALHAU_DUCKDB_VER}

bacalhau-analytics:
	docker run -it --rm ghcr.io/bacalhau-project/bacalhau \
		docker run --input ipfs://bafybeieslsgz7j3gedlqbi5b5omvkvmshd5fhco6gbuujnxzlbrrmjeo4q \
		31z4/bacalhau-duckdb:latest -- \
		./duckdb -init /init.sql -echo -s $(shell printf %q "`cat analytics.sql`") db

duckdb-analytics:
	docker compose -f duckdb/compose.yaml run -i --rm duckdb -echo -s $(shell printf %q "`cat analytics.sql`") db

web3-storage-upload:
	docker compose -f web3-storage/compose.yaml run -i --rm w3 put $(path) --name saturn-observatory

web3-storage-token:
	docker compose -f web3-storage/compose.yaml run -i --rm w3 token

web-serve:
	python -m http.server -d web
