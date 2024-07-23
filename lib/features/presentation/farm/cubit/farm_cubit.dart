import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'farm_state.dart';

class FarmCubit extends Cubit<FarmState> {
  FarmCubit() : super(FarmInitial());
}
