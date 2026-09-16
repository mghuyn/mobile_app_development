import 'package:flutter/material.dart';

class CSVCApp extends StatelessWidget {
  const CSVCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HUIT Facilities',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0f766e),
        ),
        scaffoldBackgroundColor: const Color(0xfff4f8f7),
      ),
      home: const CSVCHomeScreen(),
    );
  }
}

class CSVCHomeScreen extends StatefulWidget {
  const CSVCHomeScreen({super.key});

  @override
  State<CSVCHomeScreen> createState() => _CSVCHomeScreenState();
}

class _CSVCHomeScreenState extends State<CSVCHomeScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> facilities = [
    {
      'name': 'Cơ sở 1',
      'address': '140 Lê Trọng Tấn, Tân Phú',
      'icon': Icons.school_rounded,
      'color': Color(0xff0f766e),
    },
    {
      'name': 'Cơ sở 2',
      'address': 'Phường Tây Thạnh, Tân Phú',
      'icon': Icons.business_rounded,
      'color': Color(0xff2563eb),
    },
    {
      'name': 'Thư viện',
      'address': 'Không gian học tập và nghiên cứu',
      'icon': Icons.local_library_rounded,
      'color': Color(0xff7c3aed),
    },
    {
      'name': 'Phòng thực hành',
      'address': 'Hệ thống máy tính hiện đại',
      'icon': Icons.computer_rounded,
      'color': Color(0xffea580c),
    },
    {
      'name': 'Khu thể thao',
      'address': 'Sân bóng, cầu lông, bóng chuyền',
      'icon': Icons.sports_basketball_rounded,
      'color': Color(0xff0891b2),
    },
    {
      'name': 'Căn tin',
      'address': 'Không gian ăn uống và nghỉ ngơi',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xffbe123c),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HUIT Facilities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: Color(0xffccfbf1),
              child: Icon(
                Icons.person_rounded,
                color: Color(0xff0f766e),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildHome(),
          buildFavorite(),
          buildInformation(),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Thông tin',
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff0f766e),
                  Color(0xff14b8a6),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khám phá HUIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tìm hiểu các cơ sở vật chất và tiện ích trong trường.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Đại học Công Thương TP.HCM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Danh mục cơ sở vật chất',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: facilities.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) {
              final item = facilities[index];

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FacilityDetail(
                        name: item['name'],
                        address: item['address'],
                        icon: item['icon'],
                        color: item['color'],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: item['color'].withOpacity(0.12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          item['icon'],
                          color: item['color'],
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['address'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text(
                            'Xem chi tiết',
                            style: TextStyle(
                              color: Color(0xff0f766e),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Color(0xff0f766e),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildFavorite() {
    return const Center(
      child: Text(
        'Danh sách yêu thích đang trống',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildInformation() {
    return const Padding(
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin ứng dụng',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Ứng dụng giới thiệu cơ sở vật chất Đại học Công Thương TP.HCM, '
            'giúp sinh viên dễ dàng tìm kiếm và khám phá các tiện ích trong trường.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class FacilityDetail extends StatelessWidget {
  final String name;
  final String address;
  final IconData icon;
  final Color color;

  const FacilityDetail({
    super.key,
    required this.name,
    required this.address,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                size: 100,
                color: color,
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on_rounded, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Đây là khu vực được thiết kế nhằm phục vụ nhu cầu học tập, '
              'sinh hoạt và nghiên cứu của sinh viên.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}