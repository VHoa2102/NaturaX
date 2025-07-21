import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Giả sử bạn có package này
import 'package:springr/utils/constants.dart';

// --- Giả lập Data Models và Dữ liệu mẫu ---
class User {
  final String name;
  final String avatarUrl;
  final int points;

  User({required this.name, required this.avatarUrl, required this.points});
}

class Activity {
  final User user;
  final String action;
  final String timestamp;

  Activity({required this.user, required this.action, required this.timestamp});
}

// Dữ liệu mẫu
final List<User> leaderboardUsers = [
  User(name: 'An Nguyen', avatarUrl: 'https://i.pravatar.cc/150?img=1', points: 1250),
  User(name: 'Binh Tran', avatarUrl: 'https://i.pravatar.cc/150?img=2', points: 1100),
  User(name: 'Chi Le', avatarUrl: 'https://i.pravatar.cc/150?img=3', points: 980),
  User(name: 'Dung Pham', avatarUrl: 'https://i.pravatar.cc/150?img=4', points: 850),
  User(name: 'Emi Ho', avatarUrl: 'https://i.pravatar.cc/150?img=5', points: 720),
];

final List<Activity> recentActivities = [
  Activity(user: leaderboardUsers[3], action: 'đã tái chế 5 chai nhựa.', timestamp: '2 phút trước'),
  Activity(user: leaderboardUsers[0], action: 'đã trồng một cây xanh.', timestamp: '15 phút trước'),
  Activity(user: leaderboardUsers[1], action: 'đã sử dụng phương tiện công cộng.', timestamp: '1 giờ trước'),
  Activity(user: leaderboardUsers[4], action: 'đã mua hàng từ thương hiệu xanh.', timestamp: '3 giờ trước'),
  Activity(user: leaderboardUsers[2], action: 'đã phân loại rác tại nhà.', timestamp: '5 giờ trước'),
];
// --- Kết thúc phần dữ liệu mẫu ---


class GreenSocietyPage extends StatelessWidget {
  const GreenSocietyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dùng DefaultTabController để quản lý các tab
    return DefaultTabController(
      length: 2, // Có 2 tab: Hoạt động và Bảng xếp hạng
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: scaffoldColor,
          leadingWidth: 100.w,
          title: Text(
            'Green Society',
            style: mediumTextStyle,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
              size: 20.r,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Activities'),
              Tab(text: 'Rank'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Thẻ thống kê chung
            _buildStatsHeader(),
            // Nội dung của các tab
            Expanded(
              child: TabBarView(
                children: [
                  _buildActivityFeed(),
                  _buildLeaderboard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget cho thẻ thống kê
  Widget _buildStatsHeader() {
    return Container(
      margin: REdgeInsets.all(16),
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16.r),
          image: const DecorationImage(
            image: NetworkImage('https://www.toptal.com/designers/subtlepatterns/uploads/leaves-pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Green Score', '15,7K', Icons.star_rounded),
          _buildStatItem('Green Activity', '3,2K', Icons.local_activity_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28.sp),
        SizedBox(height: 8.h),
        Text(value, style: mediumTextStyle.copyWith(color: Colors.white, fontSize: 20.sp)),
        SizedBox(height: 4.h),
        Text(label, style: smallTextStyle.copyWith(color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }

  // Widget cho danh sách hoạt động
  Widget _buildActivityFeed() {
    return ListView.builder(
      padding: REdgeInsets.symmetric(horizontal: 16),
      itemCount: recentActivities.length,
      itemBuilder: (context, index) {
        final activity = recentActivities[index];
        return Card(
          margin: REdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Padding(
            padding: REdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(activity.user.avatarUrl),
                  radius: 24.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: smallTextStyle,
                          children: [
                            TextSpan(text: activity.user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' ${activity.action}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(activity.timestamp, style: smallTextStyle.copyWith(color: Colors.grey, fontSize: 12.sp)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget cho bảng xếp hạng
  Widget _buildLeaderboard() {
    return ListView.builder(
      padding: REdgeInsets.symmetric(horizontal: 16),
      itemCount: leaderboardUsers.length,
      itemBuilder: (context, index) {
        final user = leaderboardUsers[index];
        final rank = index + 1;
        Color? rankColor;
        if (rank == 1) rankColor = goldColor;
        if (rank == 2) rankColor = silverColor;
        if (rank == 3) rankColor = bronzeColor;

        return Card(
          margin: REdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$rank',
                  style: mediumTextStyle.copyWith(color: rankColor ?? Colors.grey, fontSize: 16.sp),
                ),
                if (rankColor != null) Icon(Icons.military_tech, color: rankColor, size: 16.sp),
              ],
            ),
            title: Text(user.name, style: smallTextStyle.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text('${user.points} điểm', style: smallTextStyle.copyWith(color: primaryColor)),
            trailing: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
              radius: 24.r,
            ),
          ),
        );
      },
    );
  }
}