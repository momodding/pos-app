import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDataSource orderRemoteDataSource;
  SyncOrderBloc(
    this.orderRemoteDataSource,
  ) : super(const _Initial()) {
    on<SyncOrderEvent>((event, emit) async {
      emit(const _Loading());

      final localOrderData = await ProductLocalDataSource.instance.getOrdersByIsNotSync();
      for (var order in localOrderData) {
        final orderItem = await ProductLocalDataSource.instance.getOrderItemsByOrderId(order.id!);
        final newOrder = order.copyWith(orderItems: orderItem);
        final result = await orderRemoteDataSource.saveOrder(newOrder);
        if (result) {
          await ProductLocalDataSource.instance.updateOrderIsSync(order.id!);
        } else {
          emit(const _Error("Failed to sync order"));
          return;
        }
      }

      emit(const _Loaded());
    });
  }
}
