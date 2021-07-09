class UserStats {
  double distance;
  double duration;
  Userstatistic userstatistic;
  int trackCount;

  UserStats(
      {this.distance, this.duration, this.userstatistic, this.trackCount});

  UserStats.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] as double;
    duration = json['duration'] as double;
    userstatistic = json['userstatistic'] != null
        ? Userstatistic.fromJson(json['userstatistic'] as Map<String, dynamic>)
        : null;
    trackCount = json['trackCount'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['duration'] = duration;
    if (userstatistic != null) {
      data['userstatistic'] = userstatistic.toJson();
    }
    data['trackCount'] = trackCount;
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
        ? Below60kmh.fromJson(json['below60kmh'] as Map<String, dynamic>)
        : null;
    above130kmh = json['above130kmh'] != null
        ? Below60kmh.fromJson(json['above130kmh'] as Map<String, dynamic>)
        : null;
    naN = json['NaN'] != null
        ? Below60kmh.fromJson(json['NaN'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (below60kmh != null) {
      data['below60kmh'] = below60kmh.toJson();
    }
    if (above130kmh != null) {
      data['above130kmh'] = above130kmh.toJson();
    }
    if (naN != null) {
      data['NaN'] = naN.toJson();
    }
    return data;
  }
}

class Below60kmh {
  double distance;
  double duration;

  Below60kmh({this.distance, this.duration});

  Below60kmh.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] as double;
    duration = json['duration'] as double;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['duration'] = duration;
    return data;
  }
}
