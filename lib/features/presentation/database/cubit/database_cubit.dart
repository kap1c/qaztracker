import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitial());
}
