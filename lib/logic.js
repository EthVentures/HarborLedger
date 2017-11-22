/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Sample transaction processor function.
 * @param {com.harborledger.network.SampleTransaction} tx The sample transaction instance.
 * @transaction
 */
function sampleTransaction(tx) {

    // Save the old value of the asset.
    var oldValue = tx.asset.value;

    // Update the asset with the new value.
    tx.asset.value = tx.newValue;

    // Get the asset registry for the asset.
    return getAssetRegistry('com.harborledger.network.BankAccount')
        .then(function (assetRegistry) {

            // Update the asset in the asset registry.
            return assetRegistry.update(tx.asset);

        })
        .then(function () {

            // Emit an event for the modified asset.
            var event = getFactory().newEvent('com.harborledger.network', 'SampleEvent');
            event.asset = tx.asset;
            event.oldValue = oldValue;
            event.newValue = tx.newValue;
            emit(event);

        });

}
/**
 * Initialize some test assets and participants useful for running a demo.
 * @param {com.harborledger.network.SetupDemo} setupDemo - the SetupDemo transaction
 * @transaction
 */
function setupDemo(setupDemo) {

    var NS = 'com.harborledger.network';

    // create the refugees
    var refugee = getFactory().newResource(NS, 'Refugee', '1234');
    refugee.firstName = "Steven";
    refugee.lastName = "King";
    refugee.countryOfOrigin = "Syria";
    var refugee2 = getFactory().newResource(NS, 'Refugee', '4567');
    refugee2.firstName = "Ray";
    refugee2.lastName = "Berny";
    refugee2.countryOfOrigin = "Zimbabwe";

    // create the accounts
    var bank = getFactory().newResource('com.harborledger.network', 'BankAccount', '3');
    bank.owner = getFactory().newRelationship('com.harborledger.network', 'Refugee', '1234');
    bank.value = '10';
    var bank2 = getFactory().newResource('com.harborledger.network', 'BankAccount', '4');
    bank2.owner = getFactory().newRelationship('com.harborledger.network', 'Refugee', '4567');
    bank2.value = '20';

    return getParticipantRegistry(NS + '.Refugee')
        .then(function (RefugeeRegistry) {

            return RefugeeRegistry.addAll([refugee,refugee2]);
        })
        .then(function () {
          return getAssetRegistry(NS + '.BankAccount')
              .then(function (AssetRegistry) {

                  return AssetRegistry.addAll([bank,bank2]);
              });
        });
}
