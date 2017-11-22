#


## Composer Network (Proposed)
**Participants**
`Nonprofit Organizations`	`Medical Providers` `Government Agencies` `Refugees`

**Assets**
	`BankAccounts`

**Transactions**
`Transfer`

**Events**
`Transaction`

### Prerequisites
* [Node](https://nodejs.org/)
* [Docker](https://www.docker.com/community-edition)
* Hyperledger composer
```bash
npm install -g composer-cli
```
* Hyperledger composer-rest-server
```bash
npm install -g composer-rest-server
```
* Hyperledger Fabric Tools
```bash
/getTools.sh
```


### Starting Fabric

```bash
cd fabric-tools
./downloadFabric.sh
./startFabric.sh
./createPeerAdminCard.sh
```

### Compile and test Business Network

```bash
npm install
npm test
```

### Locate and move Fabric Admin Key and Cert to directory root.
```bash
cp fabric-tools/fabric-scripts/hlfv1/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/<cert> .
cp fabric-tools/fabric-scripts/hlfv1/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/<key> .
```

### Create and import business network card for Hyperledger Fabric Admin
```bash
composer card create -p connection.json -u PeerAdmin -c Admin@org1.example.com-cert.pem -k <keyfile> -r PeerAdmin -r ChannelAdmin
composer card import -f PeerAdmin\@fabric-network.card
```
### Install run time on peers
```bash
composer runtime install -c PeerAdmin@fabric-network -n harbor-ledger-network
```

### Deploying Business Network to Fabric

```bash
composer network start -c PeerAdmin@fabric-network -a dist/harbor-ledger-network.bna -A admin -S adminpw
```

### Importing the business network card for the business network administrator
```bash
composer card import -f admin\@harbor-ledger-network.card
```
### Generate Rest API
```bash
composer-rest-server -c admin@harbor-ledger-network -n never -w true
```
This will start a rest server listening at: <http://localhost:3000>

Browse your REST API at <http://localhost:3000/explorer>

### Run API in background
```bash
nohup composer-rest-server -c admin@harbor-ledger-network -n never -w true > ~/rest.stdout 2> ~/rest.stderr & disown
```

### Updating Business Network
```bash
composer archive create --sourceType dir --sourceName . -a dist/harbor-ledger-network.bna
composer network update -a dist/harbor-ledger-network.bna -c admin@harbor-ledger-network
```

### Tearing Down

To tear down your development session
```bash
cd ~/fabric-tools
./stopFabric.sh
./teardownFabric.sh
```
### Team

[![EthVentures](https://github.com/EthVentures/CryptoTracker/raw/master/resources/img/ethventures-logo.png)](https://ethventures.io)
