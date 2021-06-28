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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['estimatedTime'] = this.estimatedTime;
    data['problem'] = this.problem;
    data['forceCrash'] = this.forceCrash;
    data['suddenLags'] = this.suddenLags;
    data['appWasUnresponsive'] = this.appWasUnresponsive;
    data['componentDoesNotWorkAsExpected'] =
        this.componentDoesNotWorkAsExpected;
    data['requestForAFeature'] = this.requestForAFeature;
    return data;
  }
}
