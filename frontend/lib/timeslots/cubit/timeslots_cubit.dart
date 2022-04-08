import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timeslots_state.dart';

class TimeslotsCubit extends Cubit<TimeslotsState> {
  TimeslotsCubit() : super(TimeslotsInitial());
}
