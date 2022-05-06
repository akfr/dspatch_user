import 'package:dspatch_user/bottom_navigation/account/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/update_profile_bloc/update_profile_event.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/update_profile_bloc/update_profile_state.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/custom_app_bar.dart';
import 'package:dspatch_user/components/entry_field.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/utility_functions/pick_and_get_imageurl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyProfilePage extends StatelessWidget {
  final String name;
  final String emailId;
  final String phone;
  final int id;
  final String imageUrl;

  MyProfilePage(this.name, this.emailId, this.phone, this.id, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileBloc>(
        create: (context) => UpdateProfileBloc(/*id*/),
        child: MyProfileBody(name, emailId, phone, id, imageUrl));
  }
}

class MyProfileBody extends StatefulWidget {
  final String name;
  final String emailId;
  final String phone;
  final int id;
  final String imageUrl;

  MyProfileBody(this.name, this.emailId, this.phone, this.id, this.imageUrl);

  @override
  _MyProfileBodyState createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  UpdateProfileBloc _updateProfileBloc;
  TextEditingController nameController;
  String imageUrl;

  bool isLoaderShowing = false;
  ProgressDialog _pr;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    _updateProfileBloc = BlocProvider.of<UpdateProfileBloc>(context);
    imageUrl = widget.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return BlocListener<UpdateProfileBloc, UpdateUserMeState>(
      listener: (context, state) {
        if (state is LoadingUpdateUserMeState != null &&
            state is LoadingUpdateUserMeState == true)
          showLoader();
        else
          dismissLoader();

        if (state is SuccessUpdateUserMeState) {
          Toaster.showToastBottom(
              AppLocalizations.of(context).getTranslationOf("updated"));
          // Phoenix.rebirth(context);
          Navigator.pop(context);
        } else if (state is FailureUpdateUserMeState) {
          Toaster.showToastBottom(
              AppLocalizations.of(context).getTranslationOf('failed'));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 28,
                  ),
                  CustomAppBar(
                    title: locale.myProfile,
                  ),
                  SizedBox(
                    height: 46,
                  ),
                  Expanded(
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
                            SizedBox(
                              height: 120,
                            ),
                            EntryField(
                              label: locale.fullName,
                              // initialValue: widget.name,
                              controller: nameController,
                              // readOnly: true,
                            ),
                            EntryField(
                              label: locale.emailText,
                              initialValue: widget.emailId,
                              readOnly: true,
                            ),
                            EntryField(
                              label: locale.phoneText,
                              initialValue: widget.phone,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                width: mediaQuery.size.width,
                top: mediaQuery.size.width / 4,
                child: Center(
                  child: Hero(
                    tag: 'profile_pic',
                    child: InkWell(
                      onTap: () async {
                        await showProgress();
                        String url =
                            await pickAndGetImageUrl('CourierOne/delivery');
                        await dismissProgress();
                        if (url != null) {
                          setState(() {
                            imageUrl = url;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: imageUrl == null ||
                                imageUrl == 'images/empty_dp.png'
                            ? AssetImage('images/empty_dp.png')
                            : NetworkImage(imageUrl),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomButton(
                  text: AppLocalizations.of(context)
                      .getTranslationOf("update_profile"),
                  radius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                  ),
                  onPressed: () async {
                    _updateProfileBloc.add(
                        PutUpdateProfileEvent(nameController.text, imageUrl));
                    Toaster.showToastBottom(AppLocalizations.of(context)
                        .getTranslationOf("updating"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showProgress() async {
    if (_pr == null) {
      _pr = ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      _pr.style(
        message: AppLocalizations.of(context).getTranslationOf("uploading"),
      );
    }
    await _pr.show();
  }

  Future<bool> dismissProgress() {
    return _pr.hide();
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
            valueColor: AlwaysStoppedAnimation(kMainColor),
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
}
