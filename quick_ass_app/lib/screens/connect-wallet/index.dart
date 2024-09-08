import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';
import 'package:quick_ass_app/services/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class ConnectWallet extends StatefulWidget {
  @override
  _ConnectWalletState createState() => _ConnectWalletState();
}

class _ConnectWalletState extends State<ConnectWallet> {
  Web3App? _web3app;
  SessionData? _sessionData;
  String _logs = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initWalletConnect() async {
    _web3app = await Web3App.createInstance(
      projectId: dotenv.env['PROJECT_ID']!,
      metadata: const PairingMetadata(
        name: 'Flutter WalletConnect',
        description: 'Flutter WalletConnect Dapp Example',
        url: 'https://walletconnect.com/',
        icons: [
          'https://walletconnect.com/walletconnect-logo.png',
        ],
      ),
    );
  }

  Future<void> connectWallet(String deepLink) async {
    if (_web3app == null) {
      await _initWalletConnect();
    }

    final connectResponse = await _web3app!.connect(
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1'],
          // Not every method may be needed for your purposes
          methods: [
            "personal_sign",
            "eth_sendTransaction",
            // "eth_accounts",
            // "eth_requestAccounts",
            // "eth_sendRawTransaction",
            // "eth_sign",
            // "eth_signTransaction",
            // "eth_signTypedData",
            // "eth_signTypedData_v3",
            // "eth_signTypedData_v4",
            // "wallet_switchEthereumChain",
            // "wallet_addEthereumChain",
            // "wallet_getPermissions",
            // "wallet_requestPermissions",
            // "wallet_registerOnboarding",
            // "wallet_watchAsset",
            // "wallet_scanQRCode",
          ],
          // Not every event may be needed for your purposes
          events: [
            "chainChanged",
            "accountsChanged",
            // "message",
            // "disconnect",
            // "connect",
          ],
        ),
      },
    );

    setState(() => _logs += '$connectResponse\n\n');
    final uri = connectResponse.uri;
    if (uri == null) {
      throw Exception('Uri not found');
    }

    final url = '${deepLink}wc?uri=${Uri.encodeComponent('$uri')}';
    log(url);
    await launchUrlString(url, mode: LaunchMode.externalApplication);
    _sessionData = await connectResponse.session.future;
    context.read<ConnectionProvider>().setSessionData(_sessionData);
    setState(() {
      _logs += 'sessionData ${jsonEncode(_sessionData?.toJson())}\n\n';
    });
  }

  Future<void> requestAuthWithWallet(String deepLink) async {
    if (_web3app == null) {

      if(!context.read<ConnectionProvider>().isConnected){
        await _initWalletConnect();
      }
      await connectWallet(deepLink);
    }
    // Send off an auth request now that the pairing/session is established
    // Not every wallet my be supporting Auth SDK
    setState(() => _logs += 'Requesting authentication...\n\n');
    final authResponse = await _web3app!.requestAuth(
      pairingTopic: _sessionData!.pairingTopic,
      params: AuthRequestParams(
        chainId: 'eip155:1',
        domain: 'walletconnect.org',
        aud: 'https://walletconnect.org/login',
      ),
    );
    final authCompletion = await authResponse.completer.future;
    setState(() => _logs += '$authCompletion\n\n');
    if (authCompletion.error != null) {
      throw authCompletion.error!;
    }
  }

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();


  Future<void> sendTransaction() async {
    log('send tr');
    if (_sessionData == null || _web3app == null) {
      log('Not connected');
      return;
    }

    log(_sessionData!.namespaces['eip155']!.accounts.first!.toString());
    try {
      final params = {
        "from": _sessionData!.peer.publicKey,
        "to": "0xRecipientWalletAddress",
        "value": "0xAmountInWei", // Amount to send in hexadecimal
        // Optional parameters:
        // "gas": "0xGasLimit",
        // "gasPrice": "0xGasPrice",
        // "data": "0xData"
      };

      final transactionResult = await _web3app!.request(
        topic: _sessionData!.topic,
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

  @override
  Widget build(BuildContext context) {
    log(_logs);
    return ElevatedButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          top: 8.0,
                          right: 8.0,
                        ),
                        child: Wrap(
                          spacing: 12.0,
                          runSpacing: 12.0,
                          children: [
                            ElevatedButton(
                              child: const Text('MetaMask'),
                              onPressed: () =>
                                  _connectWithWallet('metamask://'),
                            ),
                            ElevatedButton(
                              child: const Text('Rainbow'),
                              onPressed: () => _connectWithWallet('rainbow://'),
                            ),
                            ElevatedButton(
                              child: const Text('Trust'),
                              onPressed: () => _connectWithWallet('trust://'),
                            ),
                            ElevatedButton(onPressed: () => _connectWithWallet('cbwallet://'), child: Text('cb')),
                            ElevatedButton(onPressed: () async
                            {await sendTransaction();},
                            child: Text('send transaction')),

                          ],
                        ),
                      )
                    ]);
              });
        },
        child: Text('connect wallet'));
  }

  Future<void> _connectWithWallet(String deepLink) async {
    log(deepLink);
    connectWallet(deepLink).then((_) {
      setState(() => _logs += '✅ connected\n\n');
      context.read<ConnectionProvider>().setConnection(true);
      requestAuthWithWallet(deepLink).then((_) {
        setState(() => _logs += '✅ authenticated\n\n');
        context.read<ConnectionProvider>().setConnection(true);
      }).catchError((error) {
        setState(() => _logs += '❌ auth error $error\n\n');
      });
    }).catchError((error) {
      setState(() => _logs += '❌ connection error $error\n\n');
    });
    final position = await determinePosition();
    log(position.latitude.toString());
  }
}
