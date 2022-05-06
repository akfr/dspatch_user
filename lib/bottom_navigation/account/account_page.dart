import 'package:dspatch_user/authentication/bloc/auth_bloc.dart';
import 'package:dspatch_user/authentication/bloc/auth_event.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/account_bloc/account_bloc.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/account_bloc/account_event.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/account_bloc/account_state.dart';
import 'package:dspatch_user/bottom_navigation/account/contact_us_page.dart';
import 'package:dspatch_user/bottom_navigation/account/language_page.dart';
import 'package:dspatch_user/bottom_navigation/account/my_profile_page.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/routes/routes.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => AccountBloc()..add(FetchEvent()),
      child: AccountBody(),
    );
  }
}

class AccountBody extends StatefulWidget {
  @override
  _AccountBodyState createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  AccountBloc _accountBloc;
  var val;
  String userName;
  String userImage;

  @override
  void initState() {
    super.initState();
    _accountBloc = BlocProvider.of<AccountBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is SuccessState) {
              userName = state.userInformation.name;
              userImage = state
                      .userInformation.mediaurls?.images?.first?.defaultImage ??
                  'images/empty_dp.png';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      locale.accountText,
                      style:
                          TextStyle(color: theme.backgroundColor, fontSize: 28),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProfilePage(
                                  state.userInformation.name,
                                  state.userInformation.email,
                                  state.userInformation.mobileNumber,
                                  state.userInformation.id,
                                  state.userInformation.mediaurls.images == null
                                      ? 'images/empty_dp.png'
                                      : state
                                          .userInformation
                                          .mediaurls
                                          .images[0]
                                          .defaultImage))).then((value) => () {
                            _accountBloc.add(FetchEvent());
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.0),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'profile_pic',
                            child: CircleAvatar(
                              radius: 36.0,
                              backgroundImage:
                                  state.userInformation.mediaurls == null ||
                                          state.userInformation.mediaurls
                                                  .images ==
                                              null ||
                                          state.userInformation.mediaurls
                                                  .images[0].defaultImage ==
                                              null
                                      ? AssetImage('images/empty_dp.png')
                                      : NetworkImage(userImage),
                            ),
                          ),
                          SizedBox(width: 24.0),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: userName + '\n',
                                style: theme.textTheme.headline5,
                              ),
                              TextSpan(text: locale.viewProfile)
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      // height: mediaQuery.size.height * 0.7,
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(35.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 8),
                            buildListTile(
                              Icons.account_balance_wallet,
                              locale.getTranslationOf("wallet"),
                              locale.getTranslationOf("wallet_subtitle"),
                              onTap: () => Navigator.pushNamed(
                                  context, PageRoutes.earningsPage),
                            ),
                            // buildListTile(
                            //   Icons.location_on,
                            //   locale.savedAddresses,
                            //   locale.saveAddress,
                            //   onTap: () {
                            //     Navigator.pushNamed(
                            //         context, PageRoutes.savedAddressesPage);
                            //   },
                            // ),
                            buildListTile(
                              Icons.mail,
                              locale.contactUs,
                              locale.contactQuery,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactUsPage(),
                                  ),
                                );
                              },
                            ),
                            buildListTile(
                              Icons.library_books,
                              locale.tnc,
                              locale.knowtnc,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.tncPage);
                              },
                            ),
                            buildListTile(
                              Icons.assignment,
                              locale.privacyPolicy,
                              locale.companyPrivacyPolicy,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.privacyPolicy);
                              },
                            ),
                            buildListTile(Icons.call_split, locale.shareApp,
                                locale.shareFriends, onTap: () {
                              Helper.openShareMediaIntent(context);
                            }),
                            buildListTile(
                              Icons.language,
                              locale.getTranslationOf("select_language"),
                              locale.getTranslationOf("change_language"),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LanguagePage()));
                              },
                            ),
                            buildListTile(
                              Icons.exit_to_app,
                              locale.logout,
                              locale.signoutAccount,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(locale.loggingout),
                                        content: Text(locale.sureText),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(locale.no),
                                            textColor: theme.primaryColor,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color:
                                                        theme.backgroundColor)),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          FlatButton(
                                              child: Text(locale.yes),
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: theme
                                                          .backgroundColor)),
                                              textColor: theme.primaryColor,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                BlocProvider.of<AuthBloc>(
                                                        context)
                                                    .add(AuthChanged(
                                                        clearAuth: true));
                                              })
                                        ],
                                      );
                                    });
                              },
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, String subtitle,
      {Function onTap}) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.primaryColor,
        ),
        title: Text(
          title,
          style: theme.textTheme.headline5.copyWith(
              color: theme.primaryColorDark, height: 1.72, fontSize: 22),
        ),
        subtitle: Text(subtitle,
            style: theme.textTheme.subtitle1.copyWith(height: 1.3)),
        onTap: onTap,
      ),
    );
  }
}
