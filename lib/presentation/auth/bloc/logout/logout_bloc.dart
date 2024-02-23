import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/auth_remote_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_bloc.freezed.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDataSource authRemoteDataSource;
  LogoutBloc(
    this.authRemoteDataSource,
  ) : super(const _Initial()) {
    on<LogoutEvent>((event, emit) async {
      emit(const _Loading());
      final result = await authRemoteDataSource.logout();
      result.fold(
        (error) => emit(_Error(error)),
        (success) => emit(const _Success()),
      );
    });
  }
}
