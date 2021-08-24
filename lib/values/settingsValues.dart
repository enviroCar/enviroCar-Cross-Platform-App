import '../models/settingsTileModel.dart';
import '../globals.dart';

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

List<SettingsTileModel> themeSettings = [
  SettingsTileModel(
    title: 'Theme of the App',
    subtitle: 'Choose between Light and Dark Theme (Light is default)',
    isChecked: preferences.get('theme') == 'dark',
  ),
];
