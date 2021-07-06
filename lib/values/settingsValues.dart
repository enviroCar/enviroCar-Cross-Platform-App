import '../models/settingsTileModel.dart';

/// Contains values of settings on Settings Screen

// General Settings List
List<SettingsTileModel> generalSettings = [
  SettingsTileModel(
    title: 'Automatic Upload',
    subtitle:
        'Enables the automatic upload of recorded tracks after the recording has been finished. It is only tried to upload the track directly afterwards. If the upload fails (e.g. no internet connection), the track has to be uploaded manually.',
    isChecked: false,
  ),
  SettingsTileModel(
    title: 'Keep the screen on',
    subtitle:
        'When checked, this setting keeps the screen on while the application is running.',
    isChecked: false,
  ),
  SettingsTileModel(
    title: 'Verbal Announcements',
    subtitle:
        'Enabling the verbal announcements of specific events, e.g. OBD-II connection established/lost, track finished.',
    isChecked: false,
  ),
  SettingsTileModel(
    title: 'Anonymize Start and Destination',
    subtitle:
        'Only upload measurements which are taken 250 meter (820 feet) and one minute after start and before end of each track.',
    isChecked: false,
  ),
];

// OBD Mode Settings List
List<SettingsTileModel> OBDModeSettings = [
  SettingsTileModel(
    title: 'Auto Connect',
    subtitle:
        'In case of OBD track, it automatically connects to the OBD-II adapter and starts the recording of a track. This feature periodically checks whether the selected OBD-II adapter is within range. In case of GPS track, it uses activity recognition features and automatically starts the GPS based track once it detects that the user is IN_VEHICLE. Therefore, this setting requires additional battery power.',
    isChecked: false,
  ),
  SettingsTileModel(
    title: 'Discovery Interval',
    subtitle:
        'The search interval at which the final String device searches for the selected OBD-II final String device. Note: the higher the value, the more the battery gets drained.',
    isChecked: false,
  ),
  SettingsTileModel(
    title: 'Diesel Consumption Estimation',
    subtitle:
        'Enables the estimation of consumption values for diesel. NOTE: This feature is just a beta feature.',
    isChecked: false,
  ),
];

// GPS Mode Settings List
List<SettingsTileModel> GPSModeSettings = [
  SettingsTileModel(
    title: 'Enable GPS based track recording',
    subtitle:
        "Activates an additional recording mode that enables the recording of plain GPS based tracks that does not require an OBD-II adapter.\n\nNOTE: This feature is just a beta feature.",
    isChecked: false,
  ),
  SettingsTileModel(
    title: 'Automatic Recording (GPS)',
    subtitle:
        'Activates automatic recording of GPS-based trips based on activity detection mechanisms.\n\nNote: This Android function does not work reliably on some smartphone models.',
    isChecked: false,
  ),
];

List<SettingsTileModel> debuggingSettings = [
  SettingsTileModel(
    title: 'Enable Debug Logging',
    subtitle: 'Increase the log level (used in issue/problem report)',
    isChecked: false,
  ),
];


/// Values copied from Android enviroCar
/// May need in the future

// final String pref_obd_recording = "OBD Mode";
// final String pref_gps_recording = "GPS Mode";

// // Settings Activity ;
// final String pref_settings_general = "General Settings";
// final String pref_settings_general_summary =
//     "Display, Verbal Announcements, Automatic Upload ...";
// final String pref_settings_autoconnect = "Connection Settings";
// final String pref_settings_autoconnect_summary =
//     "Settings for the automatic connection with the OBD-II adapter";
// final String pref_settings_optional = "Advanced Settings";
// final String pref_settings_optional_summary =
//     "Optional settings and beta functionalities";
// final String pref_settings_other = "App Infos";
// final String pref_settings_other_summary = "Version, Licenses, etc.";

// // General Settings;
// final String pref_automatic_upload = "Automatic Upload";
// final String pref_automatic_upload_sub =
//     "Enables the automatic upload of recorded tracks after the recording has been finished. It is only tried to upload the track directly afterwards. If the upload fails (e.g. no internet connection), the track has to be uploaded manually.";
// final String pref_display_always_activ = "Keep the Screen On";
// final String pref_display_always_activ_sub =
//     "When checked, this setting keeps the screen on while the application is running.";
// final String pref_imperial_unit_summary =
//     "Use imperial units (miles) for displaying values.";
// final String pref_obfuscate_track = "Anonymize Start and Destination";
// final String pref_obfuscate_track_summary =
//     "Only upload measurements which are taken 250 meter (820 feet) and one minute after start and before end of each track.";
// final String pref_text_to_speech = "Verbal Announcements";
// final String pref_text_to_speech_summary =
//     "Enabling the verbal announcements of specific events, e.g. OBD-II connection established/lost, track finished.";

// // OBD-Settings ;
// final String pref_obd_settings = "OBD-II Adapter Settings";
// final String pref_bluetooth_switch_isenabled = "Bluetooth is On";
// final String pref_bluetooth_switch_isdisabled = "Bluetooth is Off";
// final String pref_bluetooth_pairing = "Bluetooth Pairing";
// final String pref_bluetooth_pairing_summary =
//     "Manage the pairings to Bluetooth final String devices.";
// final String pref_bluetooth_select_adapter_title = "Select OBD-II adapter";
// final String pref_bluetooth_auto_connect = "Auto Connect";
// final String pref_bluetooth_auto_connect_summary =
//     "In case of OBD track, it automatically connects to the OBD-II adapter and starts the recording of a track. This feature periodically checks whether the selected OBD-II adapter is within range. In case of GPS track, it uses activity recognition features and automatically starts the GPS based track once it detects that the user is IN_VEHICLE. Therefore, this setting requires additional battery power.";
// final String pref_bluetooth_start_background = "Background Service";
// final String pref_bluetooth_start_background_summary =
//     "Automatically starts the background service whenever Bluetooth/GPS gets activated, depending on the track recording type selected.";
// final String pref_bluetooth_discovery_interval = "Discovery Interval";
// final String pref_bluetooth_discovery_interval_summary =
//     "The search interval at which the final String device searches for the selected OBD-II final String device. Note: the higher the value, the more the battery gets drained.";

// // Auto-connect Settings ;
// final String settings_autoconnect_title = "Auto-connect Settings";
// final String settings_autoconnect_subtitle =
//     "OBD Auto-connect, GPS Auto-connect etc.";

// // Optional Settings ;
// final String sampling_rate_title = "Sampling Rate";
// final String sampling_rate_summary =
//     "The time delta between two measurements in seconds. The lower the value, the bigger the data volume. Only consider changing if you are aware of the consequences.";
// final String enable_debug_logging = "Enable Debug Logging";
// final String enable_debug_logging_summary =
//     "Increase the log level (used in issue/problem reports)";
// final String pref_track_cut_duration = "Track Trim Duration";
// final String pref_track_cut_duration_summary =
//     "GPS based tracks will be stopped automatically on detecting that the user is NOT DRIVING. However it has some latency in detecting. So we cut the track for that duration. Change this, if you know that latency.";

// final String preference_track_trim_duration_title = "Set Track Trim Duration";
// final String preference_beta_diesel_consumption =
//     "Diesel Consumption Estimation";
// final String preference_beta_diesel_consumption_sum =
//     "Enables the estimation of consumption values for diesel. NOTE: This feature is just a beta feature.";

// final String preference_beta_enable_gps_based_track_recording =
//     "Enable GPS based track recording";
// final String preference_beta_enable_gps_based_track_recording_sum =
//     "Activates an additional recording mode that enables the recording of plain GPS based tracks that does not require an OBD-II adapter.\n\nNOTE: This feature is just a beta feature.";

// // Other Settings ;
// final String pref_licenses = "Licenses";

// final String pref_car_settings = "Vehicle Settings";
// final String pref_bluetooth_disabled = "Please enable Bluetooth";
// final String pref_optional_features = "Optional Features";
// final String pref_beta_features = "Beta Features";
// final String pref_version = "Version";
// final String pref_other = "Other";
// final String pref_settings_title = "Settings";

// final String pref_gps_mode_ar_title = "Automatic Recording (GPS)";
// final String pref_gps_mode_ar_summary =
//     "Activates automatic recording of GPS-based trips based on activity detection mechanisms.\n\nNote: This Android function does not work reliably on some smartphone models.";
