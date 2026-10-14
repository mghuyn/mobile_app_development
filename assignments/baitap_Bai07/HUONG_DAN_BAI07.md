# Bài 07 - Google Maps hoàn chỉnh

Bản này giữ các chức năng đang có của project và bổ sung các phần còn thiếu của Bai07.

## Chức năng đã có

- Google Maps + vị trí hiện tại.
- Marker xuất phát / đích đến.
- Chạm bản đồ để chọn điểm đích.
- Tìm địa điểm bằng Places API.
- Chuyển địa chỉ thành tọa độ bằng Geocoding API.
- Tìm đường, vẽ polyline, hiển thị khoảng cách và thời gian.

## Phần bổ sung

- Chọn phương tiện: Ô tô (`DRIVE`), Đi bộ (`WALK`), Xe máy (`TWO_WHEELER`).
- Routes API tìm đường theo đúng phương tiện đã chọn.
- Lưu tuyến đang tìm vào SQLite.
- Màn hình "Tuyến đường yêu thích" để xem, xóa và chọn lại tuyến đã lưu.
- Khi chọn tuyến yêu thích, marker + polyline + khoảng cách + thời gian + phương tiện được hiển thị lại mà không cần gọi API lần nữa.

## File bổ sung

- `lib/favorite_route.dart`: model tuyến yêu thích.
- `lib/database_helper.dart`: tạo và thao tác SQLite.
- `lib/favorite_routes_screen.dart`: danh sách tuyến yêu thích.

## File đã cập nhật

- `lib/router_finder_screen.dart`
- `pubspec.yaml`
- `android/app/src/main/AndroidManifest.xml`
- `test/widget_test.dart` (sửa test mặc định cũ không còn phù hợp với project)

## Chạy project

Mở terminal tại thư mục project và chạy:

```bash
flutter pub get
flutter run
```

Nếu dùng Android thật, cần bật GPS và cấp quyền vị trí cho ứng dụng.

## Google Cloud cần bật

API key hiện có trong project được giữ nguyên. Project Google Cloud tương ứng cần bật các dịch vụ mà code đang dùng:

- Maps SDK for Android
- Routes API
- Places API (New)
- Geocoding API

## SQLite

Dữ liệu yêu thích được lưu local trong database `favorite_routes.db` bằng package `sqflite`. Không cần tạo file database thủ công.
