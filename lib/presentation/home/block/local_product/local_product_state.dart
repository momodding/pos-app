part of 'local_product_bloc.dart';

@freezed
class LocalProductState with _$LocalProductState {
  const factory LocalProductState.initial() = _Initial;
  const factory LocalProductState.loading() = _Loading;
  //loaded
  const factory LocalProductState.loaded(List<Product> products) = _Loaded;
  //error
  const factory LocalProductState.error(String message) = _Error;
}
