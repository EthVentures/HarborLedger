#!/bin/bash
rm dist/harbor-ledger-network.bna
composer archive create --sourceType dir --sourceName . -a dist/harbor-ledger-network.bna
composer network update -a dist/harbor-ledger-network.bna -c admin@harbor-ledger-network
composer-rest-server -c admin@harbor-ledger-network -w true -n never
