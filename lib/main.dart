import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late WebViewController _webViewController;
  double prog = 0;

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          if (await _webViewController.canGoBack()) {
            _webViewController.goBack();
            return false;
          } else {
            _webViewController.clearCache();
            return true;
          }
        },
        child: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: prog,
                color: Colors.orange,
                backgroundColor: Colors.red,
              ),
              Expanded(
                child: WebView(

                  onProgress: (progress) => setState(() {
                    prog = progress / 100;
                    print("HELLO ....$progress");
                  }),
                  initialUrl: 'https://pencilbox.edu.bd/',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    // _controller.complete(webViewController);
                    _webViewController = webViewController;

                  },
                ),
              ),

            ],
          ),
        )),
      ),
    );
  }

  void _checkVersion() async {
    final newVersion=NewVersion(
      androidId:"com.pencilbox.training",
    );
    final status= await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
        context: context,
        versionStatus: status!,
      dialogTitle: 'Update',
      dismissButtonText: 'Skip',
      dialogText: 'Please update the app from '+'${status.localVersion}'+' to '+'${status.storeVersion}',
    dismissAction: (){
      SystemNavigator.pop();
    },
    updateButtonText: 'Lets Update'

    );
    print('Device '+status.localVersion);
    print('Device '+status.storeVersion);
  }


}
