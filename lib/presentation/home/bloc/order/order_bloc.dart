import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/order_model.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'order_bloc.freezed.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());
      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue + (element.product.price!.toIntegerFromText * element.quantity));
      final total = subTotal + event.tax + event.serviceCharge - event.discount;

      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);

      final userData = await AuthLocalDataSource().getAuthData();
      // save to local storage
      final inputData = OrderModel(
        subTotal: subTotal,
        paymentAmount: event.paymentAmount,
        tax: event.tax,
        discount: event.discount,
        serviceCharge: event.serviceCharge,
        total: total,
        paymentMethod: 'Cash',
        totalItem: totalItem,
        idKasir: userData.user!.id!,
        namaKasir: userData.user!.name!,
        transactionTime: DateFormat.yMd().format(DateTime.now()),
        isSync: 0,
        orderItems: event.items,
      );

      await ProductLocalDataSource.instance.saveOrder(inputData);
      emit(_Loaded(inputData));
    });
  }
}
