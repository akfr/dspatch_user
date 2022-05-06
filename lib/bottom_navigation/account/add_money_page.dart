import 'package:dspatch_user/bottom_navigation/home/bloc/payment_bloc/payment_bloc.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/payment_bloc/payment_event.dart';
import 'package:dspatch_user/bottom_navigation/home/bloc/payment_bloc/payment_state.dart';
import 'package:dspatch_user/bottom_navigation/home/process_payment_page.dart';
import 'package:dspatch_user/components/card_picker.dart';
import 'package:dspatch_user/components/continue_button.dart';
import 'package:dspatch_user/components/custom_app_bar.dart';
import 'package:dspatch_user/components/entry_field.dart';
import 'package:dspatch_user/components/error_final_widget.dart';
import 'package:dspatch_user/components/toaster.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/wallet_bloc/wallet_bloc.dart';
import 'bloc/wallet_bloc/wallet_event.dart';
import 'bloc/wallet_bloc/wallet_state.dart';

class AddMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double balance = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body:

          //  BlocProvider<WalletBloc>(
          //   create: (context) => WalletBloc(),
          //   child: AddMoneyBody(balance),
          // ),

          MultiBlocProvider(providers: [
        BlocProvider<PaymentBloc>(
          create: (BuildContext context) =>
              PaymentBloc()..add(FetchPaymentEvent(["cod", "wallet"])),
        ),
        BlocProvider<WalletBloc>(
          create: (BuildContext context) => WalletBloc(),
        ),
      ], child: AddMoneyBody(balance)),
    );
  }
}

class AddMoneyBody extends StatefulWidget {
  final double balance;

  AddMoneyBody(this.balance);

  @override
  _AddMoneyBodyState createState() => _AddMoneyBodyState();
}

class _AddMoneyBodyState extends State<AddMoneyBody> {
  // TextEditingController _nameController = TextEditingController();
  // TextEditingController _bankNameController = TextEditingController();
  // TextEditingController _branchController = TextEditingController();
  // TextEditingController _numberController = TextEditingController();
  // TextEditingController _amountController =
  //     TextEditingController(text: '${AppSettings.currencyIcon} ');
  TextEditingController _amountController = TextEditingController();
  PaymentMethod _selectedPaymentMethod;
  bool isLoaderShowing = false;

  @override
  void dispose() {
    _amountController?.dispose();
    // _nameController?.dispose();
    // _bankNameController?.dispose();
    // _branchController?.dispose();
    // _numberController?.dispose();
    // _amountController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is LoadingWalletState) {
          showLoader();
        } else {
          dismissLoader();
        }
        if (state is WalletDepositState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcessPaymentPage(state.paymentData),
            ),
          ).then(
            (value) {
              Toaster.showToastBottom(AppLocalizations.of(context)
                  .getTranslationOf(value is PaymentStatus && value.isPaid
                      ? "payment_success"
                      : "payment_fail"));
              Navigator.pop(
                context,
                value != null && value is PaymentStatus && value.isPaid == true,
              );
            },
          );
        }
      },
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  CustomAppBar(
                    title: AppLocalizations.of(context)
                        .getTranslationOf("add_money"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                      ),
                    ),
                    child: (state is SuccessPaymentState &&
                            state.listOfPaymentMethods.isNotEmpty)
                        ? ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .getTranslationOf(
                                                "availableBalance")
                                            .toUpperCase(),
                                        style: theme.textTheme.subtitle2
                                            .copyWith(color: theme.hintColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '${Helper().getSettingValue("currency_icon")} ${(widget.balance ?? 0).toStringAsFixed(2)}',
                                      style: listTitleTextStyle.copyWith(
                                          fontSize: 28.0,
                                          color: kMainColor,
                                          letterSpacing: 0.18),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Theme.of(context).cardColor,
                                thickness: 2.0,
                              ),
                              EntryField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                hint: AppLocalizations.of(context)
                                    .getTranslationOf("enter_amount"),
                              ),
                              Divider(
                                color: Theme.of(context).cardColor,
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: DropdownButtonFormField(
                                  hint: Text(AppLocalizations.of(context)
                                      .getTranslationOf("selectPayment")),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 18),
                                  items: state.listOfPaymentMethods
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.title),
                                            value: e,
                                          ))
                                      .toList(),
                                  value: _selectedPaymentMethod,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPaymentMethod = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : state is LoadingPaymentState
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                              )
                            : ErrorFinalWidget.errorWithRetry(
                                context,
                                AppLocalizations.of(context).getTranslationOf(
                                    state is FailurePaymentState
                                        ? "something_wrong"
                                        : "empty_payment_methods"),
                                AppLocalizations.of(context)
                                    .getTranslationOf("okay"),
                                (context) => Navigator.pop(context),
                              ),
                  ),
                ],
              ),
              if (state is SuccessPaymentState &&
                  state.listOfPaymentMethods.isNotEmpty)
                PositionedDirectional(
                  bottom: 0,
                  start: 0,
                  end: 0,
                  child: CustomButton(
                    radius: BorderRadius.only(topLeft: Radius.circular(35.0)),
                    text: AppLocalizations.of(context)
                        .getTranslationOf("add_money"),
                    onPressed: () async {
                      if (_amountController.text == null ||
                          _amountController.text.trim().isEmpty) {
                        Toaster.showToastBottom(AppLocalizations.of(context)
                            .getTranslationOf("enter_amount"));
                      } else if (_selectedPaymentMethod == null) {
                        Toaster.showToastBottom(AppLocalizations.of(context)
                            .getTranslationOf("selectPayment"));
                      } else {
                        CardInfo cardInfo;
                        if (_selectedPaymentMethod.slug == "stripe") {
                          CardInfo savedCard = await CardPicker.getSavedCard();
                          cardInfo = await CardPicker.pickCard(
                              context, savedCard, true);
                        }
                        BlocProvider.of<WalletBloc>(context).add(
                          DepositWalletEvent(
                            _amountController.text.trim(),
                            _selectedPaymentMethod,
                            cardInfo,
                          ),
                        );
                      }
                    },
                  ),
                ),
            ],
          );
        },
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
