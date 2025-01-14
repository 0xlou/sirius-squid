process: migrate
	@node -r dotenv/config lib/processor.js


serve:
	@npx squid-graphql-server


migrate:
	@npx sqd db:migrate


migration:
	@npx sqd db:create-migration Data


build:
	@npm run build


codegen:
	@npx sqd codegen


typegen: moonbeamVersions.json
	@npx squid-substrate-typegen typegen.json


moonbeamVersions.json:
	@make explore


explore:
	@npx squid-substrate-metadata-explorer \
		--chain wss://wss.api.moonriver.moonbeam.network \
		--archive https://moonriver-beta.indexer.gc.subsquid.io/v4/graphql \
		--out moonbeamVersions.json


up:
	@docker-compose up -d


down:
	@docker-compose down


.PHONY: process serve start codegen migration migrate up down

reset:
	@zsh reset-db.sh

restart:
	@zsh restart.sh

abi:
	@read -p "abi name: " TARGET \
  && npx squid-evm-typegen --abi "src/abi/$${TARGET}.json" --output "src/abi/$${TARGET}.ts"

deploy:
	@read -p "version number: " VERSION \
	&& npx sqd squid:release sirius@$${VERSION} --source "https://github.com/0xlou/sirius-squid#master"