class UserStats {
  double distance;
  double duration;
  Userstatistic userstatistic;
  int trackCount;

  UserStats(
      {this.distance, this.duration, this.userstatistic, this.trackCount});

  UserStats.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    duration = json['duration'];
    userstatistic = json['userstatistic'] != null
        ? new Userstatistic.fromJson(json['userstatistic'])
        : null;
    trackCount = json['trackCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    if (this.userstatistic != null) {
      data['userstatistic'] = this.userstatistic.toJson();
    }
    data['trackCount'] = this.trackCount;
    return data;
  }
}

class Userstatistic {
  Below60kmh below60kmh;
  Below60kmh above130kmh;
  Below60kmh naN;

  Userstatistic({this.below60kmh, this.above130kmh, this.naN});

  Userstatistic.fromJson(Map<String, dynamic> json) {
    below60kmh = json['below60kmh'] != null
        ? new Below60kmh.fromJson(json['below60kmh'])
        : null;
    above130kmh = json['above130kmh'] != null
        ? new Below60kmh.fromJson(json['above130kmh'])
        : null;
    naN = json['NaN'] != null ? new Below60kmh.fromJson(json['NaN']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.below60kmh != null) {
      data['below60kmh'] = this.below60kmh.toJson();
    }
    if (this.above130kmh != null) {
      data['above130kmh'] = this.above130kmh.toJson();
    }
    if (this.naN != null) {
      data['NaN'] = this.naN.toJson();
    }
    return data;
  }
}

class Below60kmh {
  double distance;
  double duration;

  Below60kmh({this.distance, this.duration});

  Below60kmh.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    return data;
  }
}
