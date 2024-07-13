import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key, required this.urlResponse});
  final String urlResponse;
  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

late WebViewController controller;

class _PaymentWebViewState extends State<PaymentWebView> {
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.urlResponse))
      ..setNavigationDelegate(
        NavigationDelegate(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Payment via VNPAY'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                Navigator.pop(context);
              }
            },
          )),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
        ],
      ),
    );
  }
}
