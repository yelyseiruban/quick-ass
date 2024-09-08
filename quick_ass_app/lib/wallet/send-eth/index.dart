// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_framework/responsive_framework.dart';
//
// import '../../model/contract_model.dart';
// import '/view/screens/qr_code_scan.dart';
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';
import 'package:quick_ass_app/providers/users_connection_provider.dart';
import 'package:quick_ass_app/widgets/buttons/primary_button.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/json_rpc_models.dart';

class SendEthSheet extends StatefulWidget {
  const SendEthSheet({super.key});

  @override
  State<SendEthSheet> createState() => _SendEthSheetState();
}

class _SendEthSheetState extends State<SendEthSheet> {
  final amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final closestDevice = context.read<UsersConnectionProvider>().closestDevice;
    return SizedBox(
      width: MediaQuery.of(context).size.height,
        height: 500,
        child: Column(
          children: [
            Text('Closest device found: ${closestDevice?['ethAddress']}', style: TextStyle(color: Colors.black),),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(
                    color: Color(0xFF19667E),
                    width: 2.0,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
              ],
              controller: amountController,
            ),
            PrimaryButton(
              text: 'confirm',
              onPressed: () async {
                final web3app = context.read<ConnectionProvider>().web3app;
                final sesstionData = context.read<ConnectionProvider>().sessionData;

                final transaction = {
                  "from": context?.read<ConnectionProvider>().sessionData?.namespaces['eip155']!.accounts.first ?? '', // the user's Ethereum address
                  "to": closestDevice?['ethAddress'],
                  "value": amountController.value, // converting BigInt amount to hex
                };

                try {
                  final result = await web3app?.request(
                    topic: sesstionData!.topic, // the topic representing the session
                    chainId: 'eip155:1', // Ethereum Mainnet ID
                    request: SessionRequestParams(
                      method: 'eth_sendTransaction',
                      params: [transaction],
                    ),
                  );
                  print('Transaction Hash: $result');
                } catch (e) {
                  print('Error sending transaction: $e');
                }
              },
            ),
          ],
        ));
    return SizedBox(
      child: Column(
        children: [
          if (closestDevice != null)
            Flexible(
              child: Text('Closest device found: ${closestDevice['ethAddress']}'),
            ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white,
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: Color(0xFF19667E),
                        width: 2.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                  ],
                  controller: amountController,
                ),
              ),
              const Text(
                'ETH',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          PrimaryButton(
            text: 'confirm',
            onPressed: () async {
              'confirm';
            },
          ),
        ],
      ),
    );
  }

}
