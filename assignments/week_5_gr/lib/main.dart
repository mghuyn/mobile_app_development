import 'package:flutter/material.dart';

void main() {
  runApp(const MoMoApp());
}

class MoMoApp extends StatelessWidget {
  const MoMoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoMo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MoMoHomePage(),
    );
  }
}

class Service {
  final String image;
  final String title;

  const Service(this.image, this.title);
}

class MoMoHomePage extends StatefulWidget {
  const MoMoHomePage({super.key});

  @override
  State<MoMoHomePage> createState() => _MoMoHomePageState();
}

class _MoMoHomePageState extends State<MoMoHomePage> {
  int bottomIndex = 0;

  // =========================
  // DỊCH VỤ CHÍNH
  // =========================
  final services = const [
    Service('assets/chuyentien.png', 'Chuyển tiền'),
    Service('assets/thanhtoanhoadon.png', 'Thanh toán\nhóa đơn'),
    Service('assets/naptiendienthoai.png', 'Nạp tiền điện\nthoại'),
    Service('assets/muamathedidong.png', 'Mua mã thẻ\ndi động'),
    Service('assets/heodatMoMo.png', 'Heo Đất MoMo'),
    Service('assets/dibocungMoMo.png', 'Đi bộ cùng\nMoMo'),
    Service('assets/thanhtoannuoc.png', 'Thanh toán\nnước'),
    Service('assets/quanlychitieu.png', 'Quản lý chi\ntiêu'),
    Service('assets/quynhom.png', 'Quỹ nhóm'),
    Service('assets/chungkhoan.png', 'Chứng khoán'),
    Service('assets/vietlottSMS.png', 'Vietlott SMS'),
    Service('assets/xemthemdichvu.png', 'Xem thêm\ndịch vụ'),
  ];

  // =========================
  // MOMO ĐỀ XUẤT
  // =========================
  final suggested = const [
    Service('assets/vaynhanh.png', 'Vay nhanh'),
    Service('assets/muavexemphim.png', 'Mua vé xem phim'),
    Service('assets/tuithantai.png', 'Túi Thần Tài'),
    Service('assets/vitrasau.png', 'Ví Trả Sau'),
  ];

  void tap(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name — mô phỏng'),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: bottomIndex,
          children: [
            _home(),
            _emptyPage(icon: Icons.local_offer_outlined, title: 'Ưu đãi'),
            _emptyPage(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Quét mọi QR',
            ),
            _emptyPage(icon: Icons.history_rounded, title: 'Lịch sử giao dịch'),
            _emptyPage(icon: Icons.person_outline_rounded, title: 'Tôi'),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  // =========================
  // TRANG CHỦ
  // =========================
  Widget _home() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _serviceGrid()),

        SliverToBoxAdapter(child: _sectionTitle('Sự kiện đang diễn ra')),

        SliverToBoxAdapter(child: _eventBanner()),

        SliverToBoxAdapter(child: _sectionTitle('MoMo đề xuất')),

        SliverToBoxAdapter(child: _suggested()),

        SliverToBoxAdapter(child: _aiBanner()),

        SliverToBoxAdapter(child: _sectionTitle('Có thể bạn quan tâm')),

        const SliverToBoxAdapter(child: SizedBox(height: 18)),
      ],
    );
  }

  // =========================
  // GRID DỊCH VỤ
  // =========================
  Widget _serviceGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 92,
          crossAxisSpacing: 2,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (_, i) {
          final item = services[i];

          return InkWell(
            onTap: () => tap(item.title.replaceAll('\n', ' ')),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),

                const SizedBox(height: 6),

                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10.5,
                    height: 1.1,
                    color: Color(0xFF444444),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================
  // TIÊU ĐỀ SECTION
  // =========================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 7),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF222222),
        ),
      ),
    );
  }

  // =========================
  // BANNER SỰ KIỆN
  // =========================
  Widget _eventBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () => tap('Sự kiện'),
        borderRadius: BorderRadius.circular(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/banner_event.png',
            width: double.infinity,
            height: 76,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // =========================
  // MOMO ĐỀ XUẤT
  // =========================
  Widget _suggested() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 7, 9),
      child: Row(
        children: suggested.map((item) {
          return Expanded(
            child: InkWell(
              onTap: () => tap(item.title),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(item.image, fit: BoxFit.contain),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================
  // AI BANNER
  // =========================
  Widget _aiBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 7),
      child: InkWell(
        onTap: () => tap('Gieo ngay'),
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 43,
          padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5A9),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0xFFFFD82E)),
          ),
          child: Row(
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 17,
                  color: Color(0xFFE8A900),
                ),
              ),

              const SizedBox(width: 7),

              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2025 nhờ ai mà nở hoa?',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Gieo quẻ với AI, tìm quý nhân của bạn',
                      style: TextStyle(fontSize: 7.2, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Gieo ngay',
                  style: TextStyle(
                    fontSize: 7.2,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE09B00),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // BOTTOM NAVIGATION
  // =========================
  Widget _bottomBar() {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'MoMo'),
      (
        Icons.account_balance_wallet_rounded,
        Icons.account_balance_wallet_outlined,
        'Ưu đãi',
      ),
      (Icons.qr_code_scanner_rounded, Icons.qr_code_2_rounded, 'Quét mọi QR'),
      (Icons.history_rounded, Icons.history_outlined, 'Lịch sử GD'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Tôi'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9E9E9))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == bottomIndex;
              final item = items[i];

              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      bottomIndex = i;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected ? item.$1 : item.$2,
                        size: selected ? 22 : 20,
                        color: selected
                            ? const Color(0xFFE83E70)
                            : const Color(0xFFAAAAAA),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        item.$3,
                        style: TextStyle(
                          fontSize: 7.5,
                          color: selected
                              ? const Color(0xFFE83E70)
                              : const Color(0xFF999999),
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // =========================
  // TRANG PHỤ
  // =========================
  Widget _emptyPage({required IconData icon, required String title}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 34, color: const Color(0xFFE83E70)),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 6),

          const Text(
            'Tính năng đang được mô phỏng',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
