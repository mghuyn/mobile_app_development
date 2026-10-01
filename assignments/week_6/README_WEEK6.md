# WEEK 6 - MULTIMEDIA (Flutter)

Project đã được sửa để một app chạy chung trên:
- Windows
- Web / Chrome
- Android máy ảo Android Studio
- Android điện thoại thật

## Chạy project

```powershell
flutter clean
flutter pub get
flutter devices
flutter run -d windows
flutter run -d chrome
flutter run -d emulator-5554
```

Điện thoại thật:
```powershell
flutter devices
flutter run -d <device-id>
```

Nếu Android báo cache/plugin cũ:
```powershell
flutter clean
flutter pub get
flutter run
```

## Các bài trong app

- Bài 1: Media Picker & Viewer
- Bài 2: Photo Capture & Preview
- Bài 3: Đọc danh bạ + SMS
- Bài 4: Video Recorder & Playback
- Bài 5: Quản lý danh bạ
- BTVN 6: Music Player
- BTVN 7: SMS Analyzer

## Lưu ý đa nền tảng

Các chức năng multimedia và Music Player được viết để build được trên Windows/Web/Android.

Danh bạ hệ thống và SMS là API của thiết bị di động. `flutter_contacts_service` chỉ hỗ trợ Android/iOS và `another_telephony` chỉ hỗ trợ Android. Vì vậy trên Windows/Web, Bài 3, Bài 5 và BTVN 7 vẫn mở được, nhưng hiển thị thông báo chức năng hệ thống không khả dụng thay vì làm app build/run lỗi.

BTVN 7 trên Android:
- Tổng SMS nhận được.
- Lọc theo số điện thoại.
- Thống kê theo tháng và ngày.
- Nhóm [QC].
- Nhóm [OTP] + 6 chữ số.
- Chạm tin OTP để lấy riêng mã 6 số.

## Android permissions

AndroidManifest đã khai báo:
- CAMERA
- RECORD_AUDIO
- READ_CONTACTS
- WRITE_CONTACTS
- READ_SMS
- RECEIVE_SMS
- READ_PHONE_STATE
- READ_MEDIA_IMAGES
- READ_MEDIA_VIDEO
- INTERNET

Khi Android hỏi quyền, chọn Allow.

## BTVN 6

Ba file MP4 ban đầu chứa cả video + audio. Đã tách phần audio thành:
- assets/audios/xuongrong.mp3
- assets/audios/choanhve.mp3
- assets/audios/touch.mp3

`audioplayers` hỗ trợ Android, Windows và Web nên Music Player có thể chạy chung trên các nền tảng này.
