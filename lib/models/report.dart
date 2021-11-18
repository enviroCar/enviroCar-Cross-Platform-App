import 'package:flutter/foundation.dart';

// Model for report created in Report Issue Screen
class Report {
  String id;
  String estimatedTime;
  String problem;
  bool forceCrash;
  bool suddenLags;
  bool appWasUnresponsive;
  bool componentDoesNotWorkAsExpected;
  bool requestForAFeature;

  Report({
    @required this.id,
    @required this.estimatedTime,
    @required this.problem,
    @required this.forceCrash,
    @required this.suddenLags,
    @required this.appWasUnresponsive,
    @required this.componentDoesNotWorkAsExpected,
    @required this.requestForAFeature,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['estimatedTime'] = estimatedTime;
    data['problem'] = problem;
    data['forceCrash'] = forceCrash;
    data['suddenLags'] = suddenLags;
    data['appWasUnresponsive'] = appWasUnresponsive;
    data['componentDoesNotWorkAsExpected'] = componentDoesNotWorkAsExpected;
    data['requestForAFeature'] = requestForAFeature;
    return data;
  }
}
