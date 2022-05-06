import 'package:country_code_picker/country_code_picker.dart';
import 'package:dspatch_user/authentication/login_navigator.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/entry_field.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/auth/auth_request_register.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/login_cubit.dart';

class LoginEmailPage extends StatelessWidget {
  final VoidCallback onRegistrationDone;

  LoginEmailPage(this.onRegistrationDone);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: LoginEmailBody(onRegistrationDone),
    );
  }
}

class LoginEmailBody extends StatefulWidget {
  final VoidCallback onRegistrationDone;

  LoginEmailBody(this.onRegistrationDone);

  @override
  _LoginEmailBodyState createState() => _LoginEmailBodyState();
}

class _LoginEmailBodyState extends State<LoginEmailBody> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  LoginCubit _loginCubit;
  String _isoCode, _dialCode;
  bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    _loginCubit = context.read<LoginCubit>();
    // if (AppConfig.isDemoMode) {
    //   _isoCode = "CI";
    //   _dialCode = "+225";
    //   _passwordController.text = "9898989898";
    //   _phoneController.text = "Ivory Coast";

    //   Future.delayed(
    //       Duration(seconds: 1),
    //       () => showDialog(
    //           context: context,
    //           barrierDismissible: false,
    //           builder: (BuildContext context) {
    //             return AlertDialog(
    //               title: Text(AppLocalizations.of(context)
    //                   .getTranslationOf("demo_login_title")),
    //               content: Text(AppLocalizations.of(context)
    //                   .getTranslationOf("demo_login_message")),
    //               actions: <Widget>[
    //                 FlatButton(
    //                   child: Text(AppLocalizations.of(context)
    //                       .getTranslationOf("okay")),
    //                   textColor: Theme.of(context).primaryColor,
    //                   shape: RoundedRectangleBorder(
    //                       side: BorderSide(
    //                           color: Theme.of(context).backgroundColor)),
    //                   onPressed: () => Navigator.pop(context),
    //                 ),
    //               ],
    //             );
    //           }));
    // }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                AppConfig.appName,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Theme.of(context).backgroundColor),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginLoading) {
                  showLoader();
                } else {
                  dismissLoader();
                }
                if (state is LoginLoaded) {
                  gotoHome();
                } else if (state is LoginExistsLoaded) {
                  if (state.isRegistered) {
                    // gotoVerification(state.phoneNumber.normalizedPhoneNumber);
                    loginWithPhoneMail(
                        _phoneController.text, _passwordController.text);
                  } else {
                    gotoRegistrationPhoneEmail(AuthRequestRegister("", "", "",
                        state.phoneNumber.normalizedPhoneNumber, ""));
                  }
                } else if (state is LoginErrorSocial) {
                  if (state.loginName.isNotEmpty &&
                      state.loginEmail.isNotEmpty) {
                    Toaster.showToastBottom(AppLocalizations.of(context)
                        .getTranslationOf(state.messageKey));
                    gotoRegistration(AuthRequestRegister(state.loginName,
                        state.loginEmail, "", "", state.loginImageUrl));
                  } else {
                    Toaster.showToastBottom(AppLocalizations.of(context)
                        .getTranslationOf("something_wrong"));
                  }
                  print("login_error_social: $state");
                } else if (state is LoginError) {
                  Toaster.showToastBottom(AppLocalizations.of(context)
                      .getTranslationOf(state.messageKey));
                  print("login_error: $state");
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(35.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 32.0),
                          Text(
                            locale.signIn,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headline5
                                .copyWith(color: theme.hoverColor),
                          ),
                          SizedBox(height: 24.0),
                          Stack(
                            children: [
                              EntryField(
                                controller: _phoneController,
                                label: locale.phoneText,
                                hint: locale.phoneHint,
                                suffixIcon: Icons.phone,
                                keyboardType: TextInputType.number,
                                // readOnly: true,
                              ),
                              // Positioned(
                              //   top: 24,
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     height: 56,
                              //     child: CountryCodePicker(
                              //       alignLeft: true,
                              //       padding: EdgeInsets.zero,
                              //       onChanged: (value) => setState(() {
                              //         _dialCode = value.dialCode;
                              //         _isoCode = value.code;
                              //         _countryController.text =
                              //             value.name ?? "";
                              //         _controller.clear();
                              //       }),
                              //       initialSelection: _isoCode ?? "+1",
                              //       hideMainText: true,
                              //       showFlag: false,
                              //       showFlagDialog: true,
                              //       favorite: ['+225', 'CI'],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          EntryField(
                            controller: _passwordController,
                            label: locale.passWordText,
                            obscureText: true,
                            suffixIcon: Icons.security,
                            // hint: (_dialCode != null && _dialCode.isNotEmpty)
                            //     ? "${locale.getTranslationOf("phoneHintExcluding")} $_dialCode"
                            //     : locale.getTranslationOf("phoneHint"),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 16.0),
                          CustomButton(
                            // radius: BorderRadius.only(
                            //     topLeft: Radius.circular(35.0),
                            //     bottomRight: Radius.circular(35.0)),
                            radius: BorderRadius.all(Radius.circular(20.0)),
                            onPressed: () => initLoginWithPhoneMail(
                                _phoneController.text.trim(),
                                _passwordController.text.trim()),
                            // onPressed: () => loginWithMobile(
                            //   _dialCode,
                            //   Helper.formatPhone(_controller.text.trim()),
                            // ),
                          ),
                          SizedBox(height: 20.0),
                          Text('\n' + locale.signinOTP,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.subtitle1),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            locale.orContinue,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headline5
                                .copyWith(color: theme.hoverColor),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: CustomButton(
                                  text: locale.facebook,
                                  padding: 14.0,
                                  color: Color(0xff3b45c1),
                                  // onPressed: () => loginWithFacebook(),
                                ),
                              ),
                              Expanded(
                                child: CustomButton(
                                  text: locale.google,
                                  padding: 14.0,
                                  color: Color(0xffff452c),
                                  onPressed: () => loginWithGoogle(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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

  void gotoVerification(String phoneNumber) {
    Navigator.pushNamed(context, LoginRoutes.verification,
        arguments: phoneNumber);
  }

  void gotoRegistrationPhoneEmail(AuthRequestRegister authRequestRegister) {
    Navigator.pushNamed(context, LoginRoutes.signUpEmail, arguments: [
      authRequestRegister,
      _isoCode,
      _dialCode,
      _phoneController.text,
      _passwordController.text
    ]);
  }

  void gotoRegistration(AuthRequestRegister authRequestRegister) {
    Navigator.pushNamed(context, LoginRoutes.signUp, arguments: [
      authRequestRegister,
      _isoCode,
      _dialCode,
      _phoneController.text,
      _passwordController.text
    ]);
  }

  void gotoHome() {
    widget.onRegistrationDone();
  }

  // void loginWithFacebook() {
  //   if (AppConfig.isDemoMode)
  //     Toaster.showToastBottom(AppLocalizations.of(context)
  //         .getTranslationOf("social_auth_disabled"));
  //   else
  //     _loginCubit.initLoginFacebook();
  // }

  void loginWithGoogle() {
    if (AppConfig.isDemoMode)
      Toaster.showToastBottom(AppLocalizations.of(context)
          .getTranslationOf("social_auth_disabled"));
    else
      _loginCubit.initLoginGoogle();
  }

  void loginWithMobile(String dialCode, String mobileNumber) {
    _loginCubit.initLoginPhone(dialCode, mobileNumber);
  }

  void initLoginWithPhoneMail(String phone, String passWord) {
    _loginCubit.initLoginPhoneEmail(phone, passWord);
  }

  void loginWithPhoneMail(String phone, String passWord) {
    _loginCubit.loginPhoneEmail(phone, passWord);
  }
}
