import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_ticket_scanner/Components/widget.dart';
import 'package:movie_ticket_scanner/Converter/convert.dart';
import 'package:movie_ticket_scanner/model/order.dart';
import 'package:movie_ticket_scanner/service/order_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannPage extends StatefulWidget {
  const QRScannPage({super.key});

  @override
  State<StatefulWidget> createState() => _QRScannPageState();
}

class _QRScannPageState extends State<QRScannPage> {
  static const double iconSize = 20.0;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _closed = false;
  bool isCameraPaused = false;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (result != null && !_closed) {
        _showBottomSheet(context);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              bool? flashStatus = false;
                              if (snapshot.hasData) {
                                flashStatus = snapshot.data!;
                              }
                              return SvgPicture.asset(
                                flashStatus
                                    ? 'assets/svg/flash.svg'
                                    : 'assets/svg/flash_off.svg',
                                height: iconSize,
                              );
                            },
                          )),
                      MaterialButton(
                        onPressed: () async {
                          if (isCameraPaused) {
                            await controller?.resumeCamera();
                          } else {
                            await controller?.pauseCamera();
                          }
                          setState(() {
                            isCameraPaused = !isCameraPaused;
                          });
                        },
                        child: SvgPicture.asset(
                            isCameraPaused
                                ? 'assets/svg/play.svg'
                                : 'assets/svg/pause.svg',
                            height: iconSize),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return SvgPicture.asset(
                                'assets/svg/camera.svg',
                                height: iconSize,
                              );
                            } else {
                              return const Text('loading');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    late Future<Result?> orderData;
    setState(() {
      _closed = true;
      orderData = OrderService.detailOrderByCode(result!.code.toString());
    });

    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<Result?>(
          future: orderData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                backgroundColor: Colors.white,
                content: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return _buildErrorDialog(snapshot.error.toString());
            } else if (snapshot.hasData && snapshot.data != null) {
              return _buildDataDialog(snapshot.data!);
            } else {
              return _buildNoDataDialog();
            }
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        _closed = false;
        result = null;
      });
    });
  }

  Widget _buildErrorDialog(String error) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text('Error: $error'),
      actions: [_buildCloseButton()],
    );
  }

  Widget _buildDataDialog(Result order) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'CODE: ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  TextSpan(
                    text: result!.code.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Ngày: ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  TextSpan(
                    text: order.date,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            WidgetForm.buildMovieInfo(context, order),
            const Divider(height: 24),
            WidgetForm.buildTicketInfo(order),
            const Divider(height: 24),
            WidgetForm.buildFoodInfo(order),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TỔNG TIỀN',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${ConverterData.formatPrice(order.sumtotal)}đ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        _buildConfirmButton(context, order.id),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildNoDataDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: const Center(child: Text('KHÔNG CÓ DỮ LIỆU')),
      actions: [_buildCloseButton()],
    );
  }

  Widget _buildCloseButton() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            result = null;
            _closed = false;
          });
        },
        child: const Text(
          'Đóng',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(context, int orderId) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: MaterialButton(
        onPressed: () async {
          int confirmOrder = await OrderService.confirmOrder(orderId);
          if (confirmOrder == 1000.toInt()) {
            ConverterData.confirmSuccess(context);
          } else {
            ConverterData.confirmFail(context, confirmOrder);
          }
        },
        child: const Text(
          'Xác nhận',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
