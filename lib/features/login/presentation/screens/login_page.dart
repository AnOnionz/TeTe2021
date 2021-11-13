import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/platform/package_info.dart';
import '../../../../features/login/presentation/blocs/login_bloc.dart';
import '../../../../features/login/presentation/widgets/auth_button.dart';


class LoginPage extends StatefulWidget {
  final LoginBloc bloc = Modular.get<LoginBloc>();
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController ctlUserName = !kDebugMode ? TextEditingController() : TextEditingController(text: 'megahadong_ca1');
  TextEditingController passWordController = !kDebugMode ? TextEditingController() : TextEditingController(text: '123456');
  bool _obscureText = true;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  bool resizeBottom = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    _nameFocusNode.addListener(_setResizeScaffold);
    _passFocusNode.addListener(_setResizeScaffold);
    super.didChangeDependencies();
  }

  void _setResizeScaffold() {
    setState(() {
      resizeBottom = _nameFocusNode.hasFocus || _passFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_setResizeScaffold);
    _nameFocusNode.dispose();
    _passFocusNode.removeListener(_setResizeScaffold);
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        exit(0);
      },
      child: GestureDetector(
        onTap: () {
          _nameFocusNode.unfocus();
          _passFocusNode.unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            key: _scaffoldKey,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(),
                            Container(
                              width: 50,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: kGreenColor,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: const Center(
                                  child: Text(
                                    "PG",
                                    style: kStyleWhite20,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1,),
                      Image.asset("assets/images/logo.png", height: 80,),
                      const Spacer(flex: 2,),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("Tài khoản", style: kStyleBlack16,),
                            const SizedBox(height: 7,),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              focusNode: _nameFocusNode,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(_passFocusNode);
                              },
                              controller: ctlUserName,
                              decoration: const InputDecoration(
                                hintText: 'Tài khoản',
                                contentPadding: EdgeInsets.all(16),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kOrangeBorderColor, width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: kOrangeBorderColor, width: 2),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: kOrangeBorderColor, width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  gapPadding: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("Mật khẩu", style: kStyleBlack16,),
                            const SizedBox(height: 7,),
                            TextFormField(
                              focusNode: _passFocusNode,
                              textInputAction: TextInputAction.done,
                              obscureText: _obscureText,
                              obscuringCharacter: "*",
                              controller: passWordController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Mật khẩu',
                                contentPadding: const EdgeInsets.all(16),
                                filled: true,
                                suffixIcon: InkWell(
                                  onTap: _toggle,
                                  child: _obscureText ? const Icon(Icons.visibility_off, color: Colors.black54,) : const Icon(Icons.visibility,  color: Colors.black54,),
                                ),
                                fillColor: Colors.white,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: kOrangeBorderColor, width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: kOrangeBorderColor, width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: kOrangeBorderColor, width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  gapPadding: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child:
                        AuthButton(
                          bloc: widget.bloc,
                          title: "Đăng nhập",
                          onPressed: () {
                            _nameFocusNode.unfocus();
                            _passFocusNode.unfocus();
                            widget.bloc.add(Login(userName: ctlUserName.text, password: passWordController.text));
                          },
                        ),
                      ),
                      const Spacer(flex: 12,),
                      const Text(
                        "Design by iMark / Version ${MyPackageInfo.version}",
                        style: TextStyle(fontSize: 13, fontFamily: 'Helvetica-regular', color: Colors.black),
                      ),
                       const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
