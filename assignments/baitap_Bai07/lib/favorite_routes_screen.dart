import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'favorite_route.dart';

class FavoriteRoutesScreen extends StatefulWidget {
  const FavoriteRoutesScreen({super.key});

  @override
  State<FavoriteRoutesScreen> createState() => _FavoriteRoutesScreenState();
}

class _FavoriteRoutesScreenState extends State<FavoriteRoutesScreen> {
  List<FavoriteRoute> _routes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final routes = await DatabaseHelper.instance.getFavorites();

    if (!mounted) return;

    setState(() {
      _routes = routes;
      _isLoading = false;
    });
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'WALK':
        return 'Đi bộ';
      case 'TWO_WHEELER':
        return 'Xe máy';
      case 'DRIVE':
      default:
        return 'Ô tô';
    }
  }

  IconData _modeIcon(String mode) {
    switch (mode) {
      case 'WALK':
        return Icons.directions_walk;
      case 'TWO_WHEELER':
        return Icons.two_wheeler;
      case 'DRIVE':
      default:
        return Icons.directions_car;
    }
  }

  Future<void> _deleteRoute(FavoriteRoute route) async {
    if (route.id == null) return;

    await DatabaseHelper.instance.deleteFavorite(route.id!);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuyến đường yêu thích'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _routes.isEmpty
              ? const Center(
                  child: Text(
                    'Chưa có tuyến đường yêu thích.\nHãy tìm đường và nhấn nút Lưu tuyến.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _routes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final route = _routes[index];
                    final createdAt = DateTime.tryParse(route.createdAt);
                    final createdText = createdAt == null
                        ? route.createdAt
                        : '${createdAt.day.toString().padLeft(2, '0')}/'
                            '${createdAt.month.toString().padLeft(2, '0')}/'
                            '${createdAt.year} '
                            '${createdAt.hour.toString().padLeft(2, '0')}:'
                            '${createdAt.minute.toString().padLeft(2, '0')}';

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(_modeIcon(route.travelMode)),
                        ),
                        title: Text(
                          '${_modeLabel(route.travelMode)} • ${route.distance} • ${route.duration}',
                        ),
                        subtitle: Text(
                          'Từ: ${route.startLat.toStringAsFixed(5)}, ${route.startLng.toStringAsFixed(5)}\n'
                          'Đến: ${route.endLat.toStringAsFixed(5)}, ${route.endLng.toStringAsFixed(5)}\n'
                          'Lưu lúc: $createdText',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.pop(context, route);
                        },
                        trailing: IconButton(
                          tooltip: 'Xóa tuyến',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteRoute(route),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
