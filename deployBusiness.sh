#!/bin/bash
rm dist/harbor-ledger-network.bna
composer runtime install -c PeerAdmin@fabric-network -n harbor-ledger-network
composer archive create --sourceType dir --sourceName . -a dist/harbor-ledger-network.bna
composer network start -c PeerAdmin@fabric-network -a dist/harbor-ledger-network.bna -A admin -S adminpw
composer-rest-server -c admin@harbor-ledger-network -w true -n never
