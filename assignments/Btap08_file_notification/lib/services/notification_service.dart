import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    await _requestNotificationPermission();
    await _requestExactAlarmPermission();
    _initialized = true;
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      status = await Permission.notification.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    try {
      await android?.requestExactAlarmsPermission();
    } catch (_) {
      // Một số Android cũ không cần quyền này.
    }
  }

  AndroidNotificationDetails _details({
    required String channelId,
    required String channelName,
    String? description,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: description,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
  }

  Future<void> showSimple({
    required int id,
    required String title,
    required String body,
    String channelId = 'general_channel',
    String channelName = 'Thông báo chung',
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: _details(
          channelId: channelId,
          channelName: channelName,
          description: body,
        ),
      ),
    );
  }

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    String channelId = 'scheduled_channel',
    String channelName = 'Lịch nhắc',
    String? payload,
  }) async {
    if (!at.isAfter(DateTime.now())) {
      throw ArgumentError('Thời gian nhắc phải ở tương lai');
    }

    final details = NotificationDetails(
      android: _details(
        channelId: channelId,
        channelName: channelName,
        description: body,
      ),
    );
    final when = tz.TZDateTime.from(at, tz.local);

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } on PlatformException {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    }
  }

  Future<void> scheduleAfter({
    required int id,
    required Duration delay,
    required String title,
    required String body,
    String channelId = 'scheduled_channel',
    String channelName = 'Lịch nhắc',
  }) {
    return schedule(
      id: id,
      title: title,
      body: body,
      at: DateTime.now().add(delay),
      channelId: channelId,
      channelName: channelName,
    );
  }

  Future<List<PendingNotificationRequest>> pending() => _plugin.pendingNotificationRequests();
  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();
}
