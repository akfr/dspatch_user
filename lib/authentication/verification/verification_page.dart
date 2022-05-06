import 'dart:async';

import 'package:dspatch_user/authentication/verification/cubit/verification_cubit.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/custom_app_bar.dart';
import 'package:dspatch_user/components/entry_field.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationPage extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onVerificationDone;

  VerificationPage(
    this.phoneNumber,
    this.onVerificationDone,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit(),
      child: VerificationBody(phoneNumber, onVerificationDone),
    );
  }
}

class VerificationBody extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerificationDone;

  VerificationBody(this.phoneNumber, this.onVerificationDone);

  @override
  _VerificationBodyState createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody> {
  final TextEditingController _controller = TextEditingController();
  bool isLoaderShowing = false;
  VerificationCubit _verificationCubit;
  bool isDialogShowing = false;

  int _counter = 60;
  Timer _timer;

  _startTimer() {
    //shows timer
    _counter = 60; //time counter

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter > 0 ? _counter-- : _timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _verificationCubit = context.read<VerificationCubit>();
    _verificationCubit.initAuthentication(widget.phoneNumber);
  }

  // void verifyPhoneNumber() {
  //   _startTimer();
  //
  //   int resendToken;
  //   _verificationBloc = BlocProvider.of<VerificationBloc>(context);
  //   FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: widget.phoneNumber,
  //     timeout: Duration(seconds: 5),
  //     verificationCompleted: (AuthCredential authCredential) =>
  //         _verificationBloc.add(VerificationSuccessEvent(authCredential)),
  //
  //     //This callback would gets called when verification is done automatically
  //     verificationFailed: (AuthException authException) =>
  //         _verificationBloc.add(VerificationFailureEvent(authException)),
  //     codeSent: (String verId, [int forceCodeResend]) {
  //       resendToken = forceCodeResend;
  //       _verificationBloc.add(PhoneCodeSentEvent(verId));
  //     },
  //     codeAutoRetrievalTimeout: (String verId) =>
  //         _verificationBloc.add(CodeAutoRetrievalTimeoutEvent(verId)),
  //     forceResendingToken: resendToken,
  //   );
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _locale = AppLocalizations.of(context);
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerificationLoading) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is VerificationSentLoaded) {
          Toaster.showToastBottom(_locale.getTranslationOf("code_sent"));
          _startTimer();
          if (AppConfig.isDemoMode &&
              widget.phoneNumber.contains("9898989898")) {
            _controller.text = "123456";
            _verificationCubit.verifyOtp("123456");
          }
        } else if (state is VerificationVerifyingLoaded) {
          widget.onVerificationDone();
        } else if (state is VerificationError) {
          Toaster.showToastBottom(
              AppLocalizations.of(context).getTranslationOf(state.messageKey));
          // if (state.messageKey == "something_wrong" ||
          //     state.messageKey == "role_exists") {
          //   Navigator.of(context).pop();
          // }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: mediaQuery.size.height - mediaQuery.padding.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Spacer(),
                    CustomAppBar(title: locale.verificationText),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        locale.otpText,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "0:$_counter min",
                            style: Theme.of(context).textTheme.button,
                          ),
                          TextButton(
                            child: Text(
                              locale.resendText,
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              if (_counter < 1) {
                                _verificationCubit
                                    .initAuthentication(widget.phoneNumber);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: mediaQuery.size.height * 0.63,
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(35.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Spacer(),
                          EntryField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            label: locale.enterOTP,
                            hint: locale.otpText1,
                            maxLength: 6,
                          ),
                          Spacer(flex: 4),
                          CustomButton(
                            radius: BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                            ),
                            onPressed: () {
                              verify(_controller.text);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.red),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }

  void verify(String otp) {
    _verificationCubit.verifyOtp(otp);
  }
}
