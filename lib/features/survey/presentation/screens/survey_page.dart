import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: AuthenticationBloc.loginEntity!.surveyLink,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
