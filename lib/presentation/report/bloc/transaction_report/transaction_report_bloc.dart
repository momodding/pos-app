import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_report_bloc.freezed.dart';
part 'transaction_report_event.dart';
part 'transaction_report_state.dart';

class TransactionReportBloc extends Bloc<TransactionReportEvent, TransactionReportState> {
  final ProductLocalDataSource productLocalDataSource;
  TransactionReportBloc(
    this.productLocalDataSource,
  ) : super(const _Initial()) {
    on<_GetTransactionReport>((event, emit) async {
      emit(const _Loading());
      final result = await productLocalDataSource.getAllOrder(
        event.startDate,
        event.endDate,
      );
      emit(_Loaded(result));
    });
  }
}
