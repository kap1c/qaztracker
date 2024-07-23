import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sensors_state.dart';

class SensorsCubit extends Cubit<SensorsState> {
  SensorsCubit() : super(SensorsInitial());
}
