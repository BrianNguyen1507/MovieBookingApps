import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(
      const MaterialApp(
        home: QRScannPage(),
        debugShowCheckedModeBanner: false,
      ),
    );

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
    setState(() {
      _closed = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actions: [
            //xac nhan ve
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: MaterialButton(
                onPressed: () {
                  //do something sss
                  // Navigator.pop(context);
                  // setState(() {
                  //   result = null;
                  //   _closed = false;
                  // });
                },
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            //huy
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Barcode Type: ${describeEnum(result!.format)}'),
              Text('Data: ${result!.code}'),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _closed = false;
        result = null;
      });
    });
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
