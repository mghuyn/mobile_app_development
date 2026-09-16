import 'package:flutter/material.dart';

void main() {
  runApp(const Bai06App());
}

class Bai06App extends StatelessWidget {
  const Bai06App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Space',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0B14),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8064D9),
          brightness: Brightness.dark,
        ),
      ),
      home: const MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  int _selectedIndex = 0;
  bool _isPlaying = false;
  bool _isFavorite = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  double _progress = 35;

  final List<Map<String, String>> songs = [
    {
      'title': 'Until I Found You',
      'artist': 'Stephen Sanchez',
      'time': '2:57',
    },
    {
      'title': 'Golden Hour',
      'artist': 'JVKE',
      'time': '3:29',
    },
    {
      'title': 'Perfect',
      'artist': 'Ed Sheeran',
      'time': '4:23',
    },
    {
      'title': 'Dandelions',
      'artist': 'Ruth B.',
      'time': '3:53',
    },
    {
      'title': 'Those Eyes',
      'artist': 'New West',
      'time': '3:40',
    },
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF594080),
      ),
    );
  }

  void _playSong(String title) {
    setState(() {
      _isPlaying = true;
    });

    _showMessage('Đang phát: $title');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomePage(),
            _buildExplorePage(),
            _buildLibraryPage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // =========================
  // TRANG CHỦ
  // =========================

  Widget _buildHomePage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 28),
          const Text(
            'Chào buổi tối 👋',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bạn muốn nghe gì hôm nay?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          _buildSearchBar(),
          const SizedBox(height: 30),
          _buildSectionTitle(
            title: 'Nghe gần đây',
            action: 'Xem tất cả',
            onTap: () {
              _showMessage('Đang mở lịch sử nghe');
            },
          ),
          const SizedBox(height: 15),
          _buildRecentlyPlayed(),
          const SizedBox(height: 30),
          _buildSectionTitle(
            title: 'Đề xuất cho bạn',
            action: 'Xem thêm',
            onTap: () {
              _showMessage('Đang tải thêm bài hát');
            },
          ),
          const SizedBox(height: 12),
          _buildSongList(),
          const SizedBox(height: 30),
          _buildSectionTitle(
            title: 'Danh sách phát',
            action: 'Tất cả',
            onTap: _showPlaylist,
          ),
          const SizedBox(height: 15),
          _buildPlaylistList(),
          const SizedBox(height: 25),
          _buildMiniPlayer(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.08),
              ),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            _showMessage('Bạn không có thông báo mới');
          },
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.08),
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const SizedBox(width: 10),
        const CircleAvatar(
          radius: 21,
          backgroundColor: Color(0xFF8064D9),
          child: Text(
            'U',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        _showMessage('Chức năng tìm kiếm đang được mở');
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Colors.white54,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Tìm kiếm bài hát, nghệ sĩ...',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.tune_rounded,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String action,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFFB59BFF),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayed() {
    return SizedBox(
      height: 185,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _recentCard(
            title: 'Until I Found You',
            artist: 'Stephen Sanchez',
            colors: const [
              Color(0xFF4E2774),
              Color(0xFFD88CC1),
            ],
          ),
          _recentCard(
            title: 'Golden Hour',
            artist: 'JVKE',
            colors: const [
              Color(0xFFB56A27),
              Color(0xFFF1C46F),
            ],
          ),
          _recentCard(
            title: 'Dandelions',
            artist: 'Ruth B.',
            colors: const [
              Color(0xFF20516E),
              Color(0xFF73C3C4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recentCard({
    required String title,
    required String artist,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: () => _playSong(title),
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -12,
                    top: -12,
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 105,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 36,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 14,
                    bottom: 12,
                    child: Icon(
                      Icons.headphones_rounded,
                      size: 20,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongList() {
    return Column(
      children: [
        _songItem(
          title: 'Until I Found You',
          artist: 'Stephen Sanchez',
          time: '2:57',
          colors: const [
            Color(0xFF5D347E),
            Color(0xFFD68CBF),
          ],
        ),
        _songItem(
          title: 'Golden Hour',
          artist: 'JVKE',
          time: '3:29',
          colors: const [
            Color(0xFFB86D2C),
            Color(0xFFEAC36E),
          ],
        ),
        _songItem(
          title: 'Perfect',
          artist: 'Ed Sheeran',
          time: '4:23',
          colors: const [
            Color(0xFF346A83),
            Color(0xFF89C7C5),
          ],
        ),
        _songItem(
          title: 'Dandelions',
          artist: 'Ruth B.',
          time: '3:53',
          colors: const [
            Color(0xFF543C89),
            Color(0xFFB69BEA),
          ],
        ),
      ],
    );
  }

  Widget _songItem({
    required String title,
    required String artist,
    required String time,
    required List<Color> colors,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _playSong(title),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    artist,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            IconButton(
              onPressed: _showMoreOptions,
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistList() {
    return SizedBox(
      height: 145,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _playlistCard(
            title: 'Chill Vibes',
            subtitle: 'Nhẹ nhàng và thư giãn',
            icon: Icons.nightlight_round,
            colors: const [
              Color(0xFF30235D),
              Color(0xFF8064D9),
            ],
          ),
          _playlistCard(
            title: 'Love Songs',
            subtitle: 'Những bản tình ca',
            icon: Icons.favorite_rounded,
            colors: const [
              Color(0xFF7D2D4D),
              Color(0xFFD65A85),
            ],
          ),
          _playlistCard(
            title: 'Focus Time',
            subtitle: 'Tập trung học tập',
            icon: Icons.auto_awesome_rounded,
            colors: const [
              Color(0xFF245A5D),
              Color(0xFF4CB5AE),
            ],
          ),
        ],
      ),
    );
  }

  Widget _playlistCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: _showPlaylist,
      child: Container(
        width: 205,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF211A31),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF603D91),
                  Color(0xFFD98BC1),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              size: 26,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Until I Found You',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Stephen Sanchez',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
            icon: Icon(
              _isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              size: 38,
            ),
          ),
          IconButton(
            onPressed: _showPlaylist,
            icon: const Icon(
              Icons.queue_music_rounded,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // TRANG KHÁM PHÁ
  // =========================

  Widget _buildExplorePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khám phá',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tìm kiếm âm nhạc phù hợp với tâm trạng của bạn',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 25),
          _buildSearchBar(),
          const SizedBox(height: 28),
          const Text(
            'Thể loại phổ biến',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.35,
            children: [
              _genreCard(
                'Pop',
                Icons.mic_rounded,
                Colors.deepPurple,
              ),
              _genreCard(
                'Chill',
                Icons.cloud_rounded,
                Colors.blue,
              ),
              _genreCard(
                'Love',
                Icons.favorite_rounded,
                Colors.pink,
              ),
              _genreCard(
                'Focus',
                Icons.auto_awesome_rounded,
                Colors.teal,
              ),
              _genreCard(
                'Rock',
                Icons.graphic_eq_rounded,
                Colors.orange,
              ),
              _genreCard(
                'Jazz',
                Icons.music_note_rounded,
                Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _genreCard(
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        _showMessage('Đang mở thể loại $title');
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.35),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              bottom: -10,
              child: Icon(
                icon,
                size: 80,
                color: color.withOpacity(0.25),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // THƯ VIỆN
  // =========================

  Widget _buildLibraryPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thư viện của bạn',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          _libraryItem(
            icon: Icons.favorite_rounded,
            title: 'Bài hát yêu thích',
            subtitle: '12 bài hát',
            color: Colors.pink,
          ),
          _libraryItem(
            icon: Icons.download_rounded,
            title: 'Đã tải xuống',
            subtitle: '8 bài hát',
            color: Colors.blue,
          ),
          _libraryItem(
            icon: Icons.history_rounded,
            title: 'Lịch sử nghe',
            subtitle: 'Xem những bài đã nghe',
            color: Colors.orange,
          ),
          _libraryItem(
            icon: Icons.queue_music_rounded,
            title: 'Danh sách phát',
            subtitle: '3 danh sách phát',
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 25),
          const Text(
            'Bài hát đã lưu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildSongList(),
        ],
      ),
    );
  }

  Widget _libraryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        tileColor: Colors.white.withOpacity(0.06),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.18),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white54,
        ),
        onTap: () {
          _showMessage('Đang mở $title');
        },
      ),
    );
  }

  // =========================
  // THANH ĐIỀU HƯỚNG
  // =========================

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      height: 70,
      backgroundColor: const Color(0xFF15111F),
      indicatorColor: const Color(0xFF49366D),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Trang chủ',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore_rounded),
          label: 'Khám phá',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_music_outlined),
          selectedIcon: Icon(Icons.library_music_rounded),
          label: 'Thư viện',
        ),
      ],
    );
  }

  // =========================
  // DRAWER
  // =========================

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF17121F),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 25, 24, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3B2661),
                    Color(0xFF21152F),
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: Color(0xFF8064D9),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 35,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Music Space',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Âm nhạc dành riêng cho bạn',
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _drawerItem(
              icon: Icons.home_rounded,
              title: 'Trang chủ',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            _drawerItem(
              icon: Icons.explore_rounded,
              title: 'Khám phá âm nhạc',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            _drawerItem(
              icon: Icons.library_music_rounded,
              title: 'Thư viện',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            _drawerItem(
              icon: Icons.queue_music_rounded,
              title: 'Danh sách phát',
              onTap: () {
                Navigator.pop(context);
                _showPlaylist();
              },
            ),
            const Divider(
              color: Colors.white12,
              height: 30,
              indent: 20,
              endIndent: 20,
            ),
            _drawerItem(
              icon: Icons.settings_rounded,
              title: 'Cài đặt',
              onTap: () {
                Navigator.pop(context);
                _showMessage('Đang mở cài đặt');
              },
            ),
            _drawerItem(
              icon: Icons.help_outline_rounded,
              title: 'Trợ giúp',
              onTap: () {
                Navigator.pop(context);
                _showMessage('Đang mở trang trợ giúp');
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Music Space v1.0.0',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 3,
      ),
      leading: Icon(
        icon,
        color: Colors.white70,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }

  // =========================
  // DANH SÁCH PHÁT
  // =========================

  void _showPlaylist() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Danh sách phát',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                ...songs.map(
                  (song) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF594080),
                        child: Icon(Icons.music_note_rounded),
                      ),
                      title: Text(song['title']!),
                      subtitle: Text(
                        song['artist']!,
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                      trailing: Text(
                        song['time']!,
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _playSong(song['title']!);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================
  // TÙY CHỌN BÀI HÁT
  // =========================

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tùy chọn bài hát',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _optionItem(
                  icon: Icons.playlist_add_rounded,
                  title: 'Thêm vào danh sách phát',
                  onTap: () {
                    Navigator.pop(context);
                    _showPlaylist();
                  },
                ),
                _optionItem(
                  icon: Icons.favorite_border_rounded,
                  title: 'Thêm vào yêu thích',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _isFavorite = true;
                    });
                    _showMessage('Đã thêm vào bài hát yêu thích');
                  },
                ),
                _optionItem(
                  icon: Icons.shuffle_rounded,
                  title: 'Phát ngẫu nhiên',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _isShuffle = !_isShuffle;
                    });
                    _showMessage(
                      _isShuffle
                          ? 'Đã bật phát ngẫu nhiên'
                          : 'Đã tắt phát ngẫu nhiên',
                    );
                  },
                ),
                _optionItem(
                  icon: Icons.repeat_rounded,
                  title: 'Lặp lại bài hát',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _isRepeat = !_isRepeat;
                    });
                    _showMessage(
                      _isRepeat
                          ? 'Đã bật chế độ lặp lại'
                          : 'Đã tắt chế độ lặp lại',
                    );
                  },
                ),
                _optionItem(
                  icon: Icons.share_rounded,
                  title: 'Chia sẻ bài hát',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage('Đã sẵn sàng chia sẻ bài hát');
                  },
                ),
                _optionItem(
                  icon: Icons.download_rounded,
                  title: 'Tải xuống bài hát',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage('Đang tải bài hát xuống');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _optionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: Colors.white70,
      ),
      title: Text(title),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.white54,
      ),
      onTap: onTap,
    );
  }
}