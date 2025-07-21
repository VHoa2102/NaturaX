// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:springr/utils/constants.dart';

import '../dashboard/dashboard_page.dart';
import '../auth/profile/profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      // Quay lại sử dụng Stack để có thể định vị nút Scan tự do
      body: Stack(
        children: [
          Center(child: _widgetOptions.elementAt(_selectedIndex)),

          // Dùng Positioned để đặt nút Scan ở vị trí 50/50
          Positioned(
            right: 16,
            // ✅ Giá trị đã được tính toán cho vị trí 50/50
            // (chiều cao thanh bar - 1/2 chiều cao nút)
            bottom: 0,
            child: FloatingActionButton(
              heroTag: 'scan_fab',
              backgroundColor: const Color(0xFF004969), // Màu xanh đậm hơn
              mini: true, // Dùng nút nhỏ hơn cho cân đối
              child: SvgPicture.asset(
                'assets/svg/scan_icon.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                // Xử lý sự kiện nhấn nút Scan
              },
            ),
          ),
        ],
      ),

      // Nút Camera vẫn là nút nổi chính, được dock vào giữa
      floatingActionButton: FloatingActionButton(
        heroTag: 'camera_fab',
        backgroundColor: primaryColor,
        elevation: 4.0,
        child: const Icon(Icons.camera_alt, size: 28, color: Colors.white),
        onPressed: () {
          // Xử lý sự kiện nhấn nút Camera
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Thanh điều hướng với nền đậm hơn
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 8.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.person_outline_outlined,
                label: 'Profile',
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper để tạo các mục điều hướng
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _selectedIndex == index
                  ? primaryColor
                  : navigationIconColor,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: _selectedIndex == index
                    ? primaryColor
                    : navigationIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
