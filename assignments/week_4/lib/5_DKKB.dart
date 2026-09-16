import 'package:flutter/material.dart';

class DKKBApp extends StatelessWidget {
  const DKKBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Đăng ký khám bệnh',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0891b2),
        ),
        scaffoldBackgroundColor: const Color(0xfff3fbfd),
      ),
      home: const DKKBScreen(),
    );
  }
}

class DKKBScreen extends StatefulWidget {
  const DKKBScreen({super.key});

  @override
  State<DKKBScreen> createState() => _DKKBScreenState();
}

class _DKKBScreenState extends State<DKKBScreen> {
  int selectedIndex = 0;
  String selectedDepartment = 'Nội tổng quát';
  String selectedDoctor = 'BS. Nguyễn Minh Anh';
  DateTime selectedDate = DateTime.now();
  String selectedTime = '08:00 - 09:00';
  bool hasInsurance = true;

  final departments = [
    'Nội tổng quát',
    'Ngoại khoa',
    'Tai - Mũi - Họng',
    'Răng - Hàm - Mặt',
    'Da liễu',
    'Nhi khoa',
  ];

  final doctors = [
    'BS. Nguyễn Minh Anh',
    'BS. Trần Hoàng Nam',
    'BS. Lê Thu Hà',
    'BS. Phạm Quốc Bảo',
  ];

  final times = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng ký khám bệnh',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildBooking(),
          buildAppointmentHistory(),
          buildProfile(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Đặt lịch',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Lịch sử',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget buildBooking() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff0891b2),
                  Color(0xff06b6d4),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                SizedBox(height: 15),
                Text(
                  'Chăm sóc sức khỏe\ncủa bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Đặt lịch khám nhanh chóng và tiện lợi.',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Thông tin đặt lịch',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          inputField(
            label: 'Họ và tên',
            icon: Icons.person_outline,
          ),
          inputField(
            label: 'Số điện thoại',
            icon: Icons.phone_outlined,
          ),
          inputField(
            label: 'Ngày sinh',
            icon: Icons.cake_outlined,
          ),
          const SizedBox(height: 10),
          dropdownField(
            label: 'Chuyên khoa',
            value: selectedDepartment,
            items: departments,
            onChanged: (value) {
              setState(() {
                selectedDepartment = value!;
              });
            },
          ),
          const SizedBox(height: 14),
          dropdownField(
            label: 'Bác sĩ',
            value: selectedDoctor,
            items: doctors,
            onChanged: (value) {
              setState(() {
                selectedDoctor = value!;
              });
            },
          ),
          const SizedBox(height: 14),
          const Text(
            'Ngày khám',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: chooseDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xff0891b2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          dropdownField(
            label: 'Khung giờ',
            value: selectedTime,
            items: times,
            onChanged: (value) {
              setState(() {
                selectedTime = value!;
              });
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Có sử dụng bảo hiểm y tế'),
            value: hasInsurance,
            onChanged: (value) {
              setState(() {
                hasInsurance = value;
              });
            },
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: confirmBooking,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Xác nhận đặt lịch'),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputField({
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> chooseDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: selectedDate,
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void confirmBooking() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đặt lịch thành công'),
          content: Text(
            'Bạn đã đặt lịch khám $selectedDepartment '
            'với $selectedDoctor vào ngày '
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}, '
            'khung giờ $selectedTime.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget buildAppointmentHistory() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Lịch sử đặt khám',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        appointmentCard(
          'Nội tổng quát',
          'BS. Nguyễn Minh Anh',
          '20/09/2026',
          '08:00 - 09:00',
        ),
        appointmentCard(
          'Tai - Mũi - Họng',
          'BS. Trần Hoàng Nam',
          '25/09/2026',
          '09:00 - 10:00',
        ),
      ],
    );
  }

  Widget appointmentCard(
    String department,
    String doctor,
    String date,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xff0891b2),
              ),
              const SizedBox(width: 8),
              Text(
                department,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Chip(
                label: Text('Đã đặt'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(doctor),
          Text('$date • $time'),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return const Center(
      child: Text(
        'Thông tin tài khoản bệnh nhân',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}