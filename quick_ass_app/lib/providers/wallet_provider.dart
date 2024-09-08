import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletProvider extends ChangeNotifier {
  Future<void> sendTransaction(SessionData sessionData, Web3App web3app) async {
    log('send tr');
    if (sessionData == null || web3app == null) {
      log('Not connected');
      return;
    }

    log(sessionData!.namespaces['eip155']!.accounts.first!.toString());
    try {
      final params = {
        "from": sessionData!.peer.publicKey,
        "to": "0xRecipientWalletAddress",
        "value": "0xAmountInWei", // Amount to send in hexadecimal
        // Optional parameters:
        // "gas": "0xGasLimit",
        // "gasPrice": "0xGasPrice",
        // "data": "0xData"
      };

      final transactionResult = await web3app!.request(
        topic: sessionData!.topic,
        chainId: 'eip155:1',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [params],
        ),
      );

      log('Transaction Result: $transactionResult');
    } catch (e) {
      log('Error sending transaction: $e');
    }
  }
}