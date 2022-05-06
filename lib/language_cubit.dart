import 'package:dspatch_user/config/app_config.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale(AppConfig.languageDefault));

  void localeSelected(String key) {
    emit(Locale(key));
  }

  getCurrentLanguage() async {
    String currLang = await Helper().getCurrentLanguage();
    localeSelected(currLang);
  }

  setCurrentLanguage(String langCode, bool save) async {
    if (save) await Helper().setCurrentLanguage(langCode);
    localeSelected(langCode);
  }
}
