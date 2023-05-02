import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/speed_save_bloc.dart';
import '../bloc/speed_save_event.dart';
import '../bloc/speed_save_state.dart';

class HoursInWeekday extends StatelessWidget {
  final int weekday;
  const HoursInWeekday({
    Key? key,
    required this.weekday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String weekdayName = '';
    if (weekday == 1) {
      weekdayName = 'Domingo';
    } else if (weekday == 2) {
      weekdayName = 'Segunda-feira';
    } else if (weekday == 3) {
      weekdayName = 'Terça-feira';
    } else if (weekday == 4) {
      weekdayName = 'Quarta-feira';
    } else if (weekday == 5) {
      weekdayName = 'Quinta-feira';
    } else if (weekday == 6) {
      weekdayName = 'Sexta-feira';
    } else if (weekday == 7) {
      weekdayName = 'Sábado';
    }
    return Card(
      child: Column(
        children: [
          Text(weekdayName),
          BlocBuilder<SpeedSaveBloc, SpeedSaveState>(
            builder: (context, state) {
              List<int> allHours = [
                6,
                7,
                8,
                9,
                10,
                11,
                12,
                13,
                14,
                15,
                16,
                17,
                18,
                19,
                20,
                21,
                22
              ];
              List<Widget> hours = [];
              Color color = Colors.black;
              for (var hour in allHours) {
                if (weekday == 2) {
                  if (state.mondayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 3) {
                  if (state.tuesdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 4) {
                  if (state.wednesdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 5) {
                  if (state.thursdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 6) {
                  if (state.fridayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 7) {
                  if (state.saturdayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                if (weekday == 1) {
                  if (state.sundayHours.contains(hour)) {
                    color = Colors.green;
                  } else {
                    color = Colors.black;
                  }
                }
                hours.add(CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: IconButton(
                      onPressed: () {
                        context.read<SpeedSaveBloc>().add(
                            SpeedSaveEventUpdateHourInWeekday(
                                weekday: weekday, hour: hour));
                      },
                      icon: Text('$hour')),
                ));
              }
              return Wrap(
                children: hours,
              );
            },
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
