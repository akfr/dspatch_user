import 'package:dspatch_user/bottom_navigation/account/add_money_page.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/wallet_bloc/wallet_bloc.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/wallet_bloc/wallet_event.dart';
import 'package:dspatch_user/bottom_navigation/account/bloc/wallet_bloc/wallet_state.dart';
import 'package:dspatch_user/components/error_final_widget.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:dspatch_user/models/wallet_transaction.dart';
import 'package:dspatch_user/theme/colors.dart';
import 'package:dspatch_user/theme/style.dart';
import 'package:dspatch_user/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
        create: (context) => WalletBloc()..add(FetchWalletEvent(1)),
        child: EarningsBody());
  }
}

class EarningsBody extends StatefulWidget {
  @override
  _EarningsBodyState createState() => _EarningsBodyState();
}

class _EarningsBodyState extends State<EarningsBody> {
  List<WalletTransaction> _transactions = [];
  String _balance = "0.00";
  int _currentPage = 1;
  bool _isLoading = true;
  bool _allDone = false;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    //var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    var currencyIcon = Helper().getSettingValue("currency_icon");
    _balance = "$currencyIcon 0";

    return BlocConsumer<WalletBloc, WalletState>(listener: (context, state) {
      if (state is SuccessWalletBalanceState) {
        _balance =
            "$currencyIcon ${state.walletBalance.balance.toStringAsFixed(2)}";
      }
      _isLoading = state is LoadingWalletState;
      if (state is SuccessWalletTransactionsState) {
        _currentPage = state.walletTransactions.meta.current_page;
        _allDone = state.walletTransactions.meta.current_page ==
            state.walletTransactions.meta.last_page;
        if (state.walletTransactions.meta.current_page == 1) {
          _transactions = state.walletTransactions.data;
        } else {
          _transactions.addAll(state.walletTransactions.data);
        }
      }
    }, builder: (context, state) {
      return WillPopScope(
          child: Scaffold(body: SafeArea(child:
              BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, walletState) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8),
                  Row(children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios,
                            color: theme.backgroundColor)),
                    Spacer(flex: 4),
                    Text(locale.getTranslationOf("wallet_subtitle"),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headline5),
                    Spacer(flex: 5)
                  ]),
                  Text(_balance,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline4.copyWith(
                          color: theme.backgroundColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Expanded(
                      child: ClipRRect(
                          borderRadius: borderRadius,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: borderRadius),
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 20),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                locale.recentTrans,
                                                style: theme.textTheme.subtitle1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddMoneyPage(),
                                                ),
                                              ),
                                              child: Text(
                                                locale.getTranslationOf(
                                                    "add_money"),
                                                style: theme.textTheme.subtitle1
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: kMainColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    if (_transactions != null &&
                                        _transactions.isNotEmpty)
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _transactions.length,
                                          itemBuilder: (context, index) {
                                            if (_transactions.isNotEmpty &&
                                                index ==
                                                    _transactions.length - 1) {
                                              if (!_allDone && !_isLoading) {
                                                BlocProvider.of<WalletBloc>(
                                                    context)
                                                  ..add(FetchWalletEvent(
                                                      _currentPage + 1));
                                              }
                                            }
                                            var _trans = _transactions[index];
                                            return Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [boxShadow],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color:
                                                        theme.backgroundColor),
                                                padding: EdgeInsets.all(12),
                                                margin: EdgeInsets.only(
                                                    bottom: 8,
                                                    left: 12,
                                                    right: 12),
                                                child: Row(children: [
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12),
                                                      child: Image.asset(
                                                          _trans.meta?.source_meta_courier_type !=
                                                                  null
                                                              ? _trans.meta
                                                                          .source_meta_courier_type ==
                                                                      'grocery'
                                                                  ? 'images/home3.png'
                                                                  : _trans.meta
                                                                              .source_meta_courier_type ==
                                                                          'food'
                                                                      ? 'images/home2.png'
                                                                      : 'images/home1.png'
                                                              : 'images/home1.png',
                                                          scale: 4.2)),
                                                  Expanded(
                                                    child: RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                          text: locale.getTranslationOf(
                                                                  "wallet_" +
                                                                      _transactions[
                                                                              index]
                                                                          .type) +
                                                              '\n',
                                                          style: theme.textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        TextSpan(
                                                          text: locale.getTranslationOf(
                                                                  "transaction") +
                                                              " #${_transactions[index].id}",
                                                          style: theme
                                                              .textTheme.caption
                                                              .copyWith(
                                                                  color: theme
                                                                      .hintColor),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                  // RichText(
                                                  //     textAlign:
                                                  //         TextAlign.end,
                                                  //     text: TextSpan(
                                                  //         children: [
                                                  //           TextSpan(
                                                  //               text: (_transactions[index].meta.source_amount == null
                                                  //                       ? "0"
                                                  //                       : _transactions[index].meta.source_amount.toStringAsFixed(
                                                  //                           2)) +
                                                  //                   '\n',
                                                  //               style: theme
                                                  //                   .textTheme
                                                  //                   .caption
                                                  //                   .copyWith(
                                                  //                       color: theme.hintColor,
                                                  //                       fontWeight: FontWeight.bold)),
                                                  //           TextSpan(
                                                  //               text: _transactions[
                                                  //                       index]
                                                  //                   .meta
                                                  //                   .source_payment_type,
                                                  //               style: theme
                                                  //                   .textTheme
                                                  //                   .caption)
                                                  //         ])),
                                                  // SizedBox(width: 24.0),
                                                  RichText(
                                                      textAlign: TextAlign.end,
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text: currencyIcon +
                                                                " " +
                                                                (_transactions[index]
                                                                            .amount ==
                                                                        null
                                                                    ? "0"
                                                                    : _transactions[
                                                                            index]
                                                                        .amount
                                                                        .toStringAsFixed(
                                                                            2)) +
                                                                '\n',
                                                            style: theme
                                                                .textTheme
                                                                .caption
                                                                .copyWith(
                                                                    color: theme
                                                                        .hintColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                        TextSpan(
                                                            // text: locale.getTranslationOf(_transactions[
                                                            //         index]
                                                            //     .meta
                                                            //     .type),
                                                            text: "",
                                                            style: theme
                                                                .textTheme
                                                                .caption)
                                                      ]))
                                                ]));
                                          })
                                    else if (state is LoadingWalletState)
                                      Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                        Color>(
                                                    kNavigationButtonColor)),
                                      )
                                    else
                                      ErrorFinalWidget.errorWithRetry(
                                          context,
                                          AppLocalizations.of(context)
                                              .getTranslationOf(state
                                                      is SuccessWalletTransactionsState
                                                  ? "empty_transactions"
                                                  : "something_wrong"),
                                          AppLocalizations.of(context)
                                              .getTranslationOf("retry"),
                                          (context) => refreshWallet()),
                                    SizedBox(height: 40)
                                  ]))))
                ]);
          }))),
          onWillPop: onBackPressed);
    });
  }

  void refreshWallet() {
    _isLoading = true;
    _allDone = false;
    _transactions.clear();
    BlocProvider.of<WalletBloc>(context)..add(FetchWalletEvent(1));
  }

  Future<bool> onBackPressed() async {
    // You can do some work here.
    // Returning true allows the pop to happen, returning false prevents it.
    BlocProvider.of<WalletBloc>(context)..add(CancelWalletEvent());
    return true;
  }
}
