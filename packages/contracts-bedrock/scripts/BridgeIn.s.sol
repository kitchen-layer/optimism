// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// Bridge script for Bridging ETH to L2
// OptimismPortal address : 0x7e3395aac680D71eeC249499CC124cA5ddCC1afB
// function depositTransaction(address _to, uint256 _value, uint64 _gasLimit, bool _isCreation, bytes memory _data)

import { Script } from "forge-std/Script.sol";
import { OptimismPortal } from "../src/L1/OptimismPortal.sol";

contract BridgeScript is Script {
    address payable internal optimismPortal = payable(0x7e3395aac680D71eeC249499CC124cA5ddCC1afB);
    // Adresse du L2StandardBridge pré-déployé sur L2
    address constant L2_STANDARD_BRIDGE_ADDRESS = 0x4200000000000000000000000000000000000010;
    // Votre adresse EOA sur L2 où vous voulez recevoir les fonds
    address payable constant L2_RECEIVER_EOA = payable(0x8e46Cc63f1DaE605D8B5fb74CC75458E217441c5);

    uint256 constant AMOUNT_TO_DEPOSIT = 10 ether;
    uint64 constant L2_GAS_LIMIT = 1000000; // Ou plus, si 1M n'est pas suffisant

    function run() public {
        // Assurez-vous que vm.broadcast est appelé avec la clé privée de l'expéditeur L1
        // qui a les 0.01 ETH à déposer.
        // Par exemple, si 0x8e46Cc63f1DaE605D8B5fb74CC75458E217441c5 est aussi l'expéditeur L1 :

        vm.startBroadcast(); // Ou vm.startBroadcast(votreCléPrivée);

        OptimismPortal(optimismPortal).depositTransaction{ value: AMOUNT_TO_DEPOSIT }(
            L2_RECEIVER_EOA, // _to: Le destinataire FINAL sur L2
            AMOUNT_TO_DEPOSIT, // _value: Le montant à rendre disponible sur L2
            L2_GAS_LIMIT, // _gasLimit: Gaz pour l'exécution de la tx L2
            false, // _isCreation: Ce n'est pas un déploiement de contrat
            bytes("") // _data: Pas de données d'appel supplémentaires nécessaires pour un transfert ETH
        );
        vm.stopBroadcast();
    }
}
