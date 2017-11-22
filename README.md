#


## Composer Network (Proposed)
**Participants**
`Nonprofit Organizations`	`Medical Providers` `Government Agencies` `Refugees`

**Assets**
`CampVisit`	`DoctorVisits`	`Aid Workers`

**Transactions**
`Check In`

**Events**
`Sample`

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
.getTools.sh
```


### Starting Fabric

```bash
cd ~/fabric-tools
./downloadFabric.sh
./startFabric.sh
./createPeerAdminCard.sh
```

### Compile Business Network

```bash
npm install
npm test
npm run prepublish
```

### Deploying Business Network to Fabric

```bash
npm run deployNetwork
```

### Updating Business Network to Fabric

```bash
npm run updateNetwork
```

### Generate Rest API
```bash
composer-rest-server -p hlfv1 -n harbor-ledger-network -i admin -s adminpw
```
This will start a rest server listening at: <http://localhost:3000>

Browse your REST API at <http://localhost:3000/explorer>


### Tearing Down

To tear down your development session
```bash
cd ~/fabric-tools
./stopFabric.sh
./teardownFabric.sh
```
### Team

[![EthVentures](https://github.com/EthVentures/CryptoTracker/raw/master/resources/img/ethventures-logo.png)](https://ethventures.io)
