import 'dart:math' as math;
import 'package:flutter/material.dart';

class MayTinhApp extends StatelessWidget {
  const MayTinhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff2563eb),
        ),
        scaffoldBackgroundColor: const Color(0xfff5f7fb),
      ),
      home: const MayTinhScreen(),
    );
  }
}

class MayTinhScreen extends StatefulWidget {
  const MayTinhScreen({super.key});

  @override
  State<MayTinhScreen> createState() => _MayTinhScreenState();
}

class _MayTinhScreenState extends State<MayTinhScreen> {
  String display = '0';
  String expression = '';
  double firstNumber = 0;
  String operator = '';
  bool clearNext = false;
  int selectedIndex = 0;
  bool darkMode = false;

  final List<String> modes = [
    'Standard',
    'Scientific',
    'Graphing',
    'Programmer',
    'Currency',
    'Length',
    'Weight and mass',
  ];

  void input(String value) {
    setState(() {
      if (display == '0' || clearNext || display == 'Error') {
        display = value;
        clearNext = false;
      } else {
        display += value;
      }
    });
  }

  void clear() {
    setState(() {
      display = '0';
      expression = '';
      firstNumber = 0;
      operator = '';
      clearNext = false;
    });
  }

  void delete() {
    setState(() {
      if (display.length <= 1 || display == 'Error') {
        display = '0';
      } else {
        display = display.substring(0, display.length - 1);
      }
    });
  }

  void chooseOperator(String value) {
    setState(() {
      firstNumber = double.tryParse(display) ?? 0;
      operator = value;
      expression = '$display $value';
      clearNext = true;
    });
  }

  void calculate() {
    final secondNumber = double.tryParse(display) ?? 0;
    double result;

    switch (operator) {
      case '+':
        result = firstNumber + secondNumber;
        break;
      case '−':
        result = firstNumber - secondNumber;
        break;
      case '×':
        result = firstNumber * secondNumber;
        break;
      case '÷':
        if (secondNumber == 0) {
          setState(() {
            display = 'Error';
          });
          return;
        }
        result = firstNumber / secondNumber;
        break;
      default:
        return;
    }

    setState(() {
      display = result == result.roundToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(6);
      expression = '';
      operator = '';
      clearNext = true;
    });
  }

  void openMode(String mode) {
    Navigator.pop(context);

    if (mode == 'Scientific') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ScientificScreen(),
        ),
      );
    } else if (mode == 'Graphing') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const GraphingScreen(),
        ),
      );
    } else if (mode == 'Programmer') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProgrammerScreen(),
        ),
      );
    } else if (mode == 'Currency') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CurrencyScreen(),
        ),
      );
    } else if (mode == 'Length') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LengthScreen(),
        ),
      );
    } else if (mode == 'Weight and mass') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const WeightScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xff2563eb),
              ),
              scaffoldBackgroundColor: const Color(0xfff5f7fb),
            ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                'Standard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.history_rounded),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
            drawer: Drawer(
              width: 310,
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
                              Icons.calculate_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Calculator Pro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Smart calculation workspace',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(12),
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'CALCULATOR',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...modes.map(
                            (mode) => ListTile(
                              leading: Icon(
                                _getIcon(mode),
                                color: mode == 'Standard'
                                    ? const Color(0xff2563eb)
                                    : null,
                              ),
                              title: Text(mode),
                              selected: mode == 'Standard',
                              selectedTileColor: const Color(0xffdbeafe),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onTap: () => openMode(mode),
                            ),
                          ),
                          const Divider(height: 28),
                          ListTile(
                            leading: const Icon(Icons.settings_outlined),
                            title: const Text('Settings'),
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (_) {
                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Settings',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SwitchListTile(
                                              title: const Text('Dark mode'),
                                              secondary: const Icon(
                                                Icons.dark_mode_outlined,
                                              ),
                                              value: darkMode,
                                              onChanged: (value) {
                                                setState(() {
                                                  darkMode = value;
                                                });
                                                setModalState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text('About'),
                            onTap: () {
                              Navigator.pop(context);
                              showAboutDialog(
                                context: context,
                                applicationName: 'Calculator Pro',
                                applicationVersion: '1.0.0',
                                children: const [
                                  Text(
                                    'Ứng dụng máy tính được xây dựng bằng Flutter.',
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            avatar: Icon(
                              Icons.check_circle,
                              size: 17,
                              color: Colors.blue,
                            ),
                            label: Text('Ready'),
                          ),
                        ),
                        const Spacer(),
                        if (expression.isNotEmpty)
                          Text(
                            expression,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        const SizedBox(height: 8),
                        FittedBox(
                          child: Text(
                            display,
                            style: const TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(26),
                    ),
                  ),
                  child: Column(
                    children: [
                      _row([
                        _button('%', () {
                          setState(() {
                            display =
                                ((double.tryParse(display) ?? 0) / 100)
                                    .toString();
                          });
                        }),
                        _button('CE', clear),
                        _button('C', clear),
                        _button('⌫', delete),
                      ]),
                      _row([
                        _button('¹⁄ₓ', () {
                          final value = double.tryParse(display) ?? 0;
                          if (value != 0) {
                            setState(() {
                              display = (1 / value).toString();
                            });
                          }
                        }),
                        _button('x²', () {
                          final value = double.tryParse(display) ?? 0;
                          setState(() {
                            display = (value * value).toString();
                          });
                        }),
                        _button('²√x', () {
                          final value = double.tryParse(display) ?? 0;
                          if (value >= 0) {
                            setState(() {
                              display = math.sqrt(value).toString();
                            });
                          }
                        }),
                        _button('÷', () => chooseOperator('÷'),
                            operator: true),
                      ]),
                      _row([
                        _button('7', () => input('7'), number: true),
                        _button('8', () => input('8'), number: true),
                        _button('9', () => input('9'), number: true),
                        _button('×', () => chooseOperator('×'),
                            operator: true),
                      ]),
                      _row([
                        _button('4', () => input('4'), number: true),
                        _button('5', () => input('5'), number: true),
                        _button('6', () => input('6'), number: true),
                        _button('−', () => chooseOperator('−'),
                            operator: true),
                      ]),
                      _row([
                        _button('1', () => input('1'), number: true),
                        _button('2', () => input('2'), number: true),
                        _button('3', () => input('3'), number: true),
                        _button('+', () => chooseOperator('+'),
                            operator: true),
                      ]),
                      _row([
                        _button('±', () {
                          setState(() {
                            if (display.startsWith('-')) {
                              display = display.substring(1);
                            } else {
                              display = '-$display';
                            }
                          });
                        }),
                        _button('0', () => input('0'), number: true),
                        _button('.', () => input('.'), number: true),
                        _button('=', calculate, equal: true),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: 0,
              onDestinationSelected: (index) {
                if (index == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chưa có lịch sử tính toán.'),
                    ),
                  );
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.calculate_outlined),
                  selectedIcon: Icon(Icons.calculate),
                  label: 'Calculator',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined),
                  label: 'History',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String mode) {
    switch (mode) {
      case 'Scientific':
        return Icons.science_outlined;
      case 'Graphing':
        return Icons.show_chart_rounded;
      case 'Programmer':
        return Icons.code_rounded;
      case 'Currency':
        return Icons.currency_exchange_rounded;
      case 'Length':
        return Icons.straighten_rounded;
      case 'Weight and mass':
        return Icons.monitor_weight_outlined;
      default:
        return Icons.calculate_outlined;
    }
  }

  Widget _row(List<Widget> children) {
    return Row(children: children);
  }

  Widget _button(
    String text,
    VoidCallback onPressed, {
    bool operator = false,
    bool equal = false,
    bool number = false,
  }) {
    return Expanded(
      child: Container(
        height: 65,
        margin: const EdgeInsets.all(3),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: equal
                ? const Color(0xff2563eb)
                : Theme.of(context).colorScheme.surface,
            foregroundColor: equal
                ? Colors.white
                : operator
                    ? const Color(0xff2563eb)
                    : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: number ? 21 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ScientificScreen extends StatelessWidget {
  const ScientificScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific'),
      ),
      body: const Center(
        child: Text(
          'Scientific Calculator\n\nsin • cos • tan • log • ln • √ • x²',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class GraphingScreen extends StatelessWidget {
  const GraphingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Graphing Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: CustomPaint(
                  painter: _GraphPainter(),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nhập hàm số',
                hintText: 'Ví dụ: sin(x)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    final axis = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5;

    final curve = Paint()
      ..color = const Color(0xff2563eb)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final centerY = size.height / 2;
    final centerX = size.width / 2;

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      axis,
    );

    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      axis,
    );

    final path = Path();

    for (double x = 0; x <= size.width; x++) {
      final value = (x - centerX) / 35;
      final y = centerY - math.sin(value) * 90;

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, curve);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProgrammerScreen extends StatelessWidget {
  const ProgrammerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programmer'),
      ),
      body: const Center(
        child: Text(
          'BIN   OCT   DEC   HEX\n\nChuyển đổi hệ cơ số',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleConverterPage(
      title: 'Currency',
      icon: Icons.currency_exchange_rounded,
      units: const ['USD', 'EUR', 'VND', 'JPY', 'GBP'],
    );
  }
}

class LengthScreen extends StatelessWidget {
  const LengthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleConverterPage(
      title: 'Length',
      icon: Icons.straighten_rounded,
      units: const [
        'Meter',
        'Kilometer',
        'Centimeter',
        'Millimeter',
        'Mile',
        'Foot',
      ],
    );
  }
}

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleConverterPage(
      title: 'Weight and mass',
      icon: Icons.monitor_weight_outlined,
      units: const [
        'Kilogram',
        'Gram',
        'Milligram',
        'Pound',
        'Ounce',
      ],
    );
  }
}

class _SimpleConverterPage extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> units;

  const _SimpleConverterPage({
    required this.title,
    required this.icon,
    required this.units,
  });

  @override
  State<_SimpleConverterPage> createState() => _SimpleConverterPageState();
}

class _SimpleConverterPageState extends State<_SimpleConverterPage> {
  double value = 1;
  String from = '';
  String to = '';

  @override
  void initState() {
    super.initState();
    from = widget.units.first;
    to = widget.units.length > 1 ? widget.units[1] : widget.units.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              widget.icon,
              size: 65,
              color: const Color(0xff2563eb),
            ),
            const SizedBox(height: 15),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá trị',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  value = double.tryParse(text) ?? 0;
                });
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: from,
              decoration: const InputDecoration(
                labelText: 'Từ đơn vị',
                border: OutlineInputBorder(),
              ),
              items: widget.units
                  .map(
                    (unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  from = value!;
                });
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: to,
              decoration: const InputDecoration(
                labelText: 'Sang đơn vị',
                border: OutlineInputBorder(),
              ),
              items: widget.units
                  .map(
                    (unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  to = value!;
                });
              },
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff2563eb),
                    Color(0xff4f46e5),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                '${value.toStringAsFixed(2)} $from\n\n≈\n\n${value.toStringAsFixed(2)} $to',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}