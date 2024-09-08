import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/providers/connection_provider.dart';
import 'package:quick_ass_app/routes/constants.dart';
import 'package:quick_ass_app/routes/index.dart';
import 'package:quick_ass_app/services/geolocator.dart';
import 'package:quick_ass_app/widgets/buttons/primary_button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class ConnectWalletButton extends StatefulWidget {
  @override
  _ConnectWalletButtonState createState() => _ConnectWalletButtonState();
}

class _ConnectWalletButtonState extends State<ConnectWalletButton> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initWalletConnect() async {
    Web3App web3app = await Web3App.createInstance(
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
    context.read<ConnectionProvider>().setWeb3App(web3app);
  }

  Future<void> connectWallet(String deepLink) async {
    final web3app = context.read<ConnectionProvider>().web3app;
    if (web3app == null) {
      await _initWalletConnect();
    }

    final connectResponse = await web3app!.connect(
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

    final uri = connectResponse.uri;
    if (uri == null) {
      throw Exception('Uri not found');
    }

    final url = '${deepLink}wc?uri=${Uri.encodeComponent('$uri')}';
    log(url);
    await launchUrlString(url, mode: LaunchMode.externalApplication);
    final sessionData = await connectResponse.session.future;
    context.read<ConnectionProvider>().setSessionData(sessionData);
  }

  Future<void> requestAuthWithWallet(String deepLink) async {
    final web3app = context.read<ConnectionProvider>().web3app;
    final sessionData = context.read<ConnectionProvider>().sessionData;
    if (web3app == null) {
      if(!context.read<ConnectionProvider>().isConnected){
        await _initWalletConnect();
      }
      await connectWallet(deepLink);
    }
    // Send off an auth request now that the pairing/session is established
    // Not every wallet my be supporting Auth SDK
    final authResponse = await web3app!.requestAuth(
      pairingTopic: sessionData!.pairingTopic,
      params: AuthRequestParams(
        chainId: 'eip155:1',
        domain: 'walletconnect.org',
        aud: 'https://walletconnect.org/login',
      ),
    );
    final authCompletion = await authResponse.completer.future;
    if (authCompletion.error != null) {
      throw authCompletion.error!;
    }
  }


  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
        onPressed: () {
          _connectWithWallet('metamask://');
        },
        text: 'connect metamask wallet'
    );
  }

  Future<void> _connectWithWallet(String deepLink) async {
    log(deepLink);
    connectWallet(deepLink).then((_) {
      if (mounted) {
        context.read<ConnectionProvider>().setStatusString('✅ connected');
        context.read<ConnectionProvider>().setConnection(true);
        context.goNamed(home);
      }
      requestAuthWithWallet(deepLink).then((_) {
        if (mounted) {
          context.read<ConnectionProvider>().setStatusString('✅ authenticated');
          context.read<ConnectionProvider>().setConnection(true);
        }
      }).catchError((error) {
        if (mounted) {
          context.read<ConnectionProvider>().setStatusString('❌ auth error $error');
        }
      });
    }).catchError((error) {
      if (mounted) {
        context.read<ConnectionProvider>().setStatusString('❌ connection error');
      }
    });
    final position = await determinePosition();
    log(position.latitude.toString());
  }
}
