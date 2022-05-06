// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:dspatch_user/components/continue_button.dart';
// import 'package:dspatch_user/components/custom_app_bar.dart';
// import 'package:dspatch_user/components/entry_field.dart';
// import 'package:dspatch_user/locale/locales.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:toast/toast.dart';
// import '../login_navigator.dart';
//
// class SocialSignUpPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<SocialSignUpBloc>(
//           create: (context) => SocialSignUpBloc(),
//         ),
//         BlocProvider<ProfileBloc>(
//           create: (context) => ProfileBloc()..add(FetchProfileEvent()),
//         ),
//       ],
//       child: SocialSignUpBody(),
//     );
//   }
// }
//
// class SocialSignUpBody extends StatefulWidget {
//   @override
//   _SocialSignUpBodyState createState() => _SocialSignUpBodyState();
// }
//
// class _SocialSignUpBodyState extends State<SocialSignUpBody> {
//   final TextEditingController _controller = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//
//   SocialSignUpBloc _signUpBloc;
//   ProfileBloc _profileBloc;
//   String isoCode;
//
//   @override
//   void initState() {
//     super.initState();
//     _signUpBloc = BlocProvider.of<SocialSignUpBloc>(context);
//     _profileBloc = BlocProvider.of<ProfileBloc>(context);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var locale = AppLocalizations.of(context);
//     var mediaQuery = MediaQuery.of(context);
//     var theme = Theme.of(context);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: BlocListener<SocialSignUpBloc, SocialSignUpState>(
//             listener: (context, state) {
//               _profileBloc.add(FetchProfileEvent());
//               if (state.isSuccess) {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, LoginRoutes.verification,
//                     arguments: state.number);
//               } else if (state.isSubmitting) {
//                 showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   useRootNavigator: false,
//                   builder: (BuildContext context) {
//                     return Center(child: CircularProgressIndicator());
//                   },
//                 );
//               } else if (state.isFailure) {
//                 Navigator.pop(context);
//                 final snackBar = SnackBar(
//                   content: Text('Network error'),
//                 );
//                 Scaffold.of(context).showSnackBar(snackBar);
//               } else if (!state.isNumberValid) {
//                 Toast.show('Invalid number', context,
//                     backgroundColor: Colors.black.withOpacity(0.5),
//                     duration: 2,
//                     gravity: Toast.TOP);
//               }
//             },
//             child: BlocBuilder<ProfileBloc, ProfileState>(
//               builder: (context, profileState) {
//                 return Container(
//                   height: mediaQuery.size.height - mediaQuery.padding.vertical,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Spacer(),
//                       CustomAppBar(),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Text(
//                           '\n' + locale.hey + ' ' + profileState.name,
//                           style: Theme.of(context).textTheme.headline5.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1.2,
//                               ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Text(
//                           '\n' + locale.socialText,
//                           style: Theme.of(context).textTheme.headline5,
//                         ),
//                       ),
//                       Spacer(flex: 2),
//                       Container(
//                         height: mediaQuery.size.height * 0.58,
//                         decoration: BoxDecoration(
//                           color: theme.backgroundColor,
//                           borderRadius: BorderRadiusDirectional.only(
//                             topStart: Radius.circular(35.0),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Spacer(),
//                             Stack(
//                               children: [
//                                 EntryField(
//                                   controller: _countryController,
//                                   label: locale.countryText,
//                                   hint: locale.selectCountryFromList,
//                                   suffixIcon: Icons.arrow_drop_down,
//                                   readOnly: true,
//                                 ),
//                                 Positioned(
//                                   top: 24,
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     height: 56,
//                                     child: CountryCodePicker(
//                                       padding: EdgeInsets.zero,
//                                       onChanged: (value) {
//                                         isoCode = value.code;
//                                         _countryController.text = value.name;
//                                       },
//                                       initialSelection: '+1',
//                                       showFlag: false,
//                                       showFlagDialog: true,
//                                       favorite: ['+91', 'US'],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             EntryField(
//                               controller: _controller,
//                               label: locale.phoneText,
//                               hint: locale.phoneHint,
//                               keyboardType: TextInputType.number,
//                             ),
//                             Spacer(),
//                             CustomButton(
//                               radius: BorderRadius.only(
//                                 topLeft: Radius.circular(35.0),
//                               ),
//                               onPressed: () => _signUpBloc.add(
//                                 SocialSignUpSubmittedEvent(
//                                   isoCode: isoCode,
//                                   mobileNumber: _controller.text,
//                                   name: profileState.name,
//                                   email: profileState.email,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
