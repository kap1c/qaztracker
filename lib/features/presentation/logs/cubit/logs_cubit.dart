import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'logs_state.dart';

class LogsCubit extends Cubit<LogsState> {
  LogsCubit() : super(LogsInitial());
}
