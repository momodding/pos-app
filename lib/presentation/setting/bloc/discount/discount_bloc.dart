import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/discount_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount_bloc.freezed.dart';
part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountRemoteDataSource discountRemoteDataSource;
  DiscountBloc(
    this.discountRemoteDataSource,
  ) : super(const _Initial()) {
    on<_GetDiscounts>((event, emit) async{
      emit(const _Loading());
      final result = await discountRemoteDataSource.getDiscounts();
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Loaded(r.data!));
      });
    });

    on<_AddDiscount>((event, emit) async {
      emit(const _Loading());
      final result = await discountRemoteDataSource.addDiscount({
        'name': event.name,
        'description': event.description,
        'value': event.value.toString(),
        'type': 'percentage',
      });
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(const _Success());
      });
    });
  }
}
