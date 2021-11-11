import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/constants.dart';
import '../../../../features/login/presentation/blocs/login_bloc.dart';

class AuthButton extends StatelessWidget {
  final LoginBloc bloc;
  final String title;
  final VoidCallback onPressed;
  const AuthButton({Key? key, required this.bloc, required this.onPressed, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: bloc,
      builder: (context, state) {
        return InkWell(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 40.0,
            width: state is LoginLoading ? 40.0 : 400,
            child:  state is LoginLoading ? Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(3.0),
              child: const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
              )),
            ) : Center(child: Text(title, style: kStyleWhite17,)),
            padding: EdgeInsets.symmetric(horizontal: state is LoginLoading ? 0 : 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular( state is LoginLoading ? 48.0 : 5.0),
              color: kRedColor,
            ),
          ),
        );
      },
    );
  }
}
// state is LoginLoading ?  Container(
// width: 35, height: 35,
// child: