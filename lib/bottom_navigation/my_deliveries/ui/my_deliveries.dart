import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_bloc.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_event.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/bloc/order_state.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/ui/order_card_widgets.dart';
import 'package:dspatch_user/components/error_final_widget.dart';
import 'package:dspatch_user/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDeliveriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
        create: (BuildContext context) => OrderBloc()..add(FetchOrderEvent(1)),
        child: MyDeliveriesBody());
  }
}

class MyDeliveriesBody extends StatefulWidget {
  @override
  _MyDeliveriesBodyState createState() => _MyDeliveriesBodyState();
}

class _MyDeliveriesBodyState extends State<MyDeliveriesBody> {
  int _currentPage = 1;
  bool _allDone = false, _isLoading = true;
  AppLocalizations locale;
  ThemeData theme;

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context);
    theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              locale.myDeliv,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.backgroundColor, fontSize: 28),
            ),
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0)),
        child: Container(
          margin: EdgeInsets.only(bottom: 56.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0)),
            color: theme.cardColor,
          ),
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is SuccessOrdersState) {
                _isLoading = false;
                _allDone = state.orders.meta.current_page ==
                    state.orders.meta.last_page;
                _currentPage = state.orders.meta.current_page;
                if (state.orders.data == null || state.orders.data.isEmpty) {
                  return ErrorFinalWidget.errorWithRetry(
                      context,
                      AppLocalizations.of(context)
                          .getTranslationOf("empty_orders"),
                      AppLocalizations.of(context).getTranslationOf("reload"),
                      (context) => BlocProvider.of<OrderBloc>(context)
                        ..add(FetchOrderEvent(1)));
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<OrderBloc>().add(FetchOrderEvent(1));
                    },
                    child: ListView.builder(
                        padding:
                            EdgeInsets.only(bottom: 12, left: 16, right: 16),
                        shrinkWrap: true,
                        itemCount: state.orders.data.length,
                        itemBuilder: (context, index) {
                          if (state.orders.data.isNotEmpty) {
                            if (index == state.orders.data.length - 1) {
                              _triggerPagination(context);
                            }
                          }
                          return state.orders.data[index].id < 0
                              ? OrderCardWidget.orderHeading(
                                  context,
                                  locale.getTranslationOf(
                                      state.orders.data[index].type))
                              : OrderCardWidget.orderCard(
                                  state.orders.data[index]);
                        }),
                  );
                }
              } else if (state is FailureOrderState) {
                return ErrorFinalWidget.errorWithRetry(
                    context,
                    AppLocalizations.of(context)
                        .getTranslationOf("something_wrong"),
                    AppLocalizations.of(context).getTranslationOf("retry"),
                    (context) => BlocProvider.of<OrderBloc>(context)
                      ..add(FetchOrderEvent(1)));
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  void _triggerPagination(BuildContext context) {
    if (!_isLoading && !_allDone) {
      BlocProvider.of<OrderBloc>(context)
        ..add(FetchOrderEvent(_currentPage + 1));
      _isLoading = true;
    }
  }
}
