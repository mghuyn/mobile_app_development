import 'package:flutter/material.dart';

class ViDienTuApp extends StatelessWidget {
  const ViDienTuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ví điện tử',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff2563eb),
        ),
        scaffoldBackgroundColor: const Color(0xfff5f7fb),
      ),
      home: const ViDienTuScreen(),
    );
  }
}

class ViDienTuScreen extends StatefulWidget {
  const ViDienTuScreen({super.key});

  @override
  State<ViDienTuScreen> createState() => _ViDienTuScreenState();
}

class _ViDienTuScreenState extends State<ViDienTuScreen> {
  int selectedIndex = 0;
  bool hideBalance = false;
  double balance = 1250000;

  final transactions = [
    {
      'title': 'Nạp tiền',
      'subtitle': 'Từ tài khoản ngân hàng',
      'amount': '+500.000đ',
      'icon': Icons.add_card_rounded,
      'color': Color(0xff16a34a),
    },
    {
      'title': 'Thanh toán điện nước',
      'subtitle': 'Hóa đơn tháng 09/2026',
      'amount': '-230.000đ',
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xfff97316),
    },
    {
      'title': 'Chuyển tiền',
      'subtitle': 'Nguyễn Minh Anh',
      'amount': '-150.000đ',
      'icon': Icons.send_rounded,
      'color': Color(0xff2563eb),
    },
    {
      'title': 'Hoàn tiền',
      'subtitle': 'Giao dịch mua sắm',
      'amount': '+80.000đ',
      'icon': Icons.replay_rounded,
      'color': Color(0xff7c3aed),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Ví của tôi',
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
              backgroundColor: Color(0xffdbeafe),
              child: Icon(
                Icons.person_rounded,
                color: Color(0xff2563eb),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff2563eb),
                      Color(0xff4f46e5),
                    ],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'MyWallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Quản lý tài chính cá nhân',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard_rounded),
                title: const Text('Tổng quan'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.history_rounded),
                title: const Text('Lịch sử giao dịch'),
                onTap: () {
                  Navigator.pop(context);
                  showTransactions();
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card_rounded),
                title: const Text('Thẻ ngân hàng'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.security_rounded),
                title: const Text('Bảo mật'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Cài đặt'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildHome(),
          buildTransactionPage(),
          buildProfilePage(),
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
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Giao dịch',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Tài khoản',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openTransferSheet,
        backgroundColor: const Color(0xff2563eb),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.send_rounded),
        label: const Text('Chuyển tiền'),
      ),
    );
  }

  Widget buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 5, 18, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff2563eb),
                  Color(0xff4f46e5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff2563eb).withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Số dư khả dụng',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    Text(
                      hideBalance
                          ? '••••••••'
                          : '${balance.toStringAsFixed(0)}đ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          hideBalance = !hideBalance;
                        });
                      },
                      icon: Icon(
                        hideBalance
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 15,
                      color: Colors.white70,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Số dư được bảo mật',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Thao tác nhanh',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              quickAction(
                Icons.add_card_rounded,
                'Nạp tiền',
                const Color(0xff16a34a),
                () {
                  showMessage('Mở chức năng nạp tiền');
                },
              ),
              quickAction(
                Icons.send_rounded,
                'Chuyển tiền',
                const Color(0xff2563eb),
                openTransferSheet,
              ),
              quickAction(
                Icons.receipt_long_rounded,
                'Thanh toán',
                const Color(0xfff97316),
                () {
                  showMessage('Mở chức năng thanh toán');
                },
              ),
              quickAction(
                Icons.qr_code_scanner_rounded,
                'Quét mã',
                const Color(0xff7c3aed),
                () {
                  showMessage('Mở trình quét QR');
                },
              ),
            ],
          ),
          const SizedBox(height: 27),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ...transactions.take(3).map(transactionTile),
        ],
      ),
    );
  }

  Widget quickAction(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionTile(Map<String, dynamic> item) {
    final amount = item['amount'] as String;
    final isPositive = amount.startsWith('+');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item['icon'] as IconData,
              color: item['color'] as Color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'] as String,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isPositive
                  ? const Color(0xff16a34a)
                  : const Color(0xffdc2626),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Lịch sử giao dịch',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        ...transactions.map(transactionTile),
      ],
    );
  }

  Widget buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundColor: Color(0xffdbeafe),
          child: Icon(
            Icons.person_rounded,
            size: 45,
            color: Color(0xff2563eb),
          ),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Nguyễn Minh Anh',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Center(
          child: Text(
            'minhanh@email.com',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 25),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Thông tin cá nhân'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.security_outlined),
          title: const Text('Bảo mật tài khoản'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Cài đặt'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }

  void openTransferSheet() {
    final receiverController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            10,
            20,
            MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chuyển tiền',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: receiverController,
                decoration: const InputDecoration(
                  labelText: 'Tên người nhận',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  prefixIcon: Icon(Icons.payments_outlined),
                  suffixText: 'VNĐ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final amount =
                        double.tryParse(amountController.text) ?? 0;

                    if (amount <= 0 || amount > balance) {
                      showMessage('Số tiền không hợp lệ');
                      return;
                    }

                    setState(() {
                      balance -= amount;
                    });

                    Navigator.pop(context);
                    showMessage('Chuyển tiền thành công');
                  },
                  child: const Text('Xác nhận chuyển'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showTransactions() {
    setState(() {
      selectedIndex = 1;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}