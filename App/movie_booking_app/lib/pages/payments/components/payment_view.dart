import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({super.key, required this.url});
  final String url;

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  bool _isLoading = false;
  late WebViewController controller;
  late Map<String, dynamic> returnData;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
            _handleUrlParameters(url);
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {},
          onNavigationRequest: (NavigationRequest request) {
            _handleUrlParameters(request.url);
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void _handleUrlParameters(String url) async {
    String? result = '999';
    final uri = Uri.parse(url);
    final parameters = uri.queryParameters;
    if (parameters.containsKey('vnp_Amount') &&
        parameters.containsKey('vnp_TransactionNo')) {
      String amount = parameters['vnp_Amount']!;
      String transaction = parameters['vnp_TransactionNo']!;
      result = parameters['vnp_ResponseCode'];
      setState(() {
        returnData = {
          'result': result,
          'transaction': transaction,
          'amount': amount,
        };
      });
    }
    if (parameters.containsKey('vnp_ResponseCode') &&
        parameters['vnp_ResponseCode'] == '00') {
      Navigator.pop(context, returnData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading && mounted
        ? Scaffold(
            body: Center(
              child: loadingContent,
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: Common.customAppbar(context, null, '',
                AppColors.appbarColor, AppColors.appbarColor.withOpacity(0.1)),
            body: Center(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          );
  }
}
