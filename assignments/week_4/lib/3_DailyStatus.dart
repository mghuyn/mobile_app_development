import 'package:flutter/material.dart';

class DailyStatusApp extends StatelessWidget {
  const DailyStatusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Status',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffec4899),
        ),
        scaffoldBackgroundColor: const Color(0xfffff7fb),
      ),
      home: const DailyStatusScreen(),
    );
  }
}

class DailyStatusScreen extends StatefulWidget {
  const DailyStatusScreen({super.key});

  @override
  State<DailyStatusScreen> createState() => _DailyStatusScreenState();
}

class _DailyStatusScreenState extends State<DailyStatusScreen> {
  int selectedMood = 1;
  double energy = 70;
  bool studied = false;
  bool exercised = false;
  bool sleptWell = true;

  final moods = [
    {
      'emoji': '😴',
      'title': 'Mệt mỏi',
      'color': Color(0xff64748b),
    },
    {
      'emoji': '🙂',
      'title': 'Bình thường',
      'color': Color(0xfff59e0b),
    },
    {
      'emoji': '😊',
      'title': 'Vui vẻ',
      'color': Color(0xff22c55e),
    },
    {
      'emoji': '🤩',
      'title': 'Tuyệt vời',
      'color': Color(0xffec4899),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mood = moods[selectedMood];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hôm nay bạn thế nào?',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Theo dõi trạng thái mỗi ngày',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    mood['color'] as Color,
                    (mood['color'] as Color).withOpacity(0.65),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Text(
                    mood['emoji'] as String,
                    style: const TextStyle(fontSize: 65),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Hãy dành một chút thời gian cho bản thân.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Tâm trạng hiện tại',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                moods.length,
                (index) {
                  final item = moods[index];
                  final selected = selectedMood == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 74,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? (item['color'] as Color).withOpacity(0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? item['color'] as Color
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            item['emoji'] as String,
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['title'] as String,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Mức năng lượng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bạn đang cảm thấy tràn đầy năng lượng đến đâu?'),
                Text(
                  '${energy.toInt()}%',
                  style: const TextStyle(
                    color: Color(0xffec4899),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: energy,
              min: 0,
              max: 100,
              divisions: 10,
              activeColor: const Color(0xffec4899),
              onChanged: (value) {
                setState(() {
                  energy = value;
                });
              },
            ),
            const SizedBox(height: 15),
            const Text(
              'Hoạt động hôm nay',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            statusTile(
              icon: Icons.menu_book_rounded,
              title: 'Tôi đã học tập',
              value: studied,
              onChanged: (value) {
                setState(() {
                  studied = value;
                });
              },
            ),
            statusTile(
              icon: Icons.fitness_center_rounded,
              title: 'Tôi đã vận động',
              value: exercised,
              onChanged: (value) {
                setState(() {
                  exercised = value;
                });
              },
            ),
            statusTile(
              icon: Icons.bedtime_rounded,
              title: 'Tôi đã ngủ đủ giấc',
              value: sleptWell,
              onChanged: (value) {
                setState(() {
                  sleptWell = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã lưu trạng thái hôm nay.'),
                    ),
                  );
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Lưu trạng thái'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Icon(
          icon,
          color: const Color(0xffec4899),
        ),
        title: Text(title),
      ),
    );
  }
}