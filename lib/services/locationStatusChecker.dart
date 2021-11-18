import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../utils/enums.dart';

class LocationStatusChecker {
  static const Duration DEFAULT_INTERVAL = Duration(seconds: 2);

  factory LocationStatusChecker() => _locationStatusChecker;
  LocationStatusChecker._() {
    _statusController.onListen = () {
      _sendStatusUpdates();
    };

    _statusController.onCancel = () {
      _timer?.cancel();
      _lastStatus = null;
    };
  }

  static final LocationStatusChecker _locationStatusChecker =
      LocationStatusChecker._();

  /// function to get [LocationStatus]
  Future<LocationStatus> get locationIsEnabled async {
    final bool serviceIsEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceIsEnabled ? LocationStatus.enabled : LocationStatus.disabled;
  }

  Duration checkInterval = DEFAULT_INTERVAL;

  /// function to send status updates
  Future _sendStatusUpdates([Timer timer]) async {
    _timer?.cancel();
    timer?.cancel();

    final _currentStatus = await locationIsEnabled;

    // if the current status is different than the last known status and stream has listeners then adding the new value to the stream
    if (_currentStatus != _lastStatus && _statusController.hasListener) {
      _statusController.add(_currentStatus);
    }

    // if the stream does not have any listeners returning from the function
    if (!_statusController.hasListener) {
      return;
    }

    // calling the function after an interval of time
    _timer = Timer(checkInterval, _sendStatusUpdates);

    // update the last known status
    _lastStatus = _currentStatus;
  }

  LocationStatus _lastStatus;
  Timer _timer;

  final StreamController<LocationStatus> _statusController =
      StreamController.broadcast();

  /// function to return stream of [LocationStatus]
  Stream<LocationStatus> get onStatusChange => _statusController.stream;

  /// function to check whether the [LocationStatus] stream has listeners
  bool get hasListeners => _statusController.hasListener;
}
