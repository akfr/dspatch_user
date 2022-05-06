import 'package:dspatch_user/authentication/bloc/auth_bloc.dart';
import 'package:dspatch_user/authentication/bloc/auth_event.dart';
import 'package:dspatch_user/authentication/login_navigator.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/custom_app_bar.dart';
import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/language_cubit.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePage extends StatefulWidget {
  final bool fromRoot;

  LanguagePage([this.fromRoot = false]);
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _defaultLanguage;

  getLanguage() async {
    String currLang = await Helper().getCurrentLanguage();
    setState(() {
      _defaultLanguage = currLang ?? AppConfig.languageDefault;
    });
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  showLeadingButton: !widget.fromRoot,
                  title: locale.getTranslationOf("select_language"),
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(35.0)),
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.vertical -
                        70,
                    decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(35.0))),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text(
                            '\n' +
                                locale
                                    .getTranslationOf("change_language_desc") +
                                '\n',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: theme.primaryColorDark)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: AppConfig.languagesSupported.length,
                          itemBuilder: (context, index) => RadioListTile(
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() => _defaultLanguage = value);
                            },
                            groupValue: _defaultLanguage,
                            value: AppConfig.languagesSupported.keys
                                .elementAt(index),
                            title: Text(AppConfig
                                .languagesSupported[AppConfig
                                    .languagesSupported.keys
                                    .elementAt(index)]
                                .name),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                child: CustomButton(
                  text: locale.getTranslationOf("continueText"),
                  radius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                  ),
                  onPressed: () {
                    BlocProvider.of<LanguageCubit>(context)
                        .setCurrentLanguage(_defaultLanguage, true);
                    if (widget.fromRoot) {
                      BlocProvider.of<AuthBloc>(context).add(AuthChanged());
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
