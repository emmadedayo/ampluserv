import 'package:ampluserv/models/step_res.dart';

class TripInfoRes {
  final int distance; // met
  final List<StepsRes> steps;

  TripInfoRes(this.distance, this.steps);
}