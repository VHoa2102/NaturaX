import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Giả sử bạn có package này
import 'package:flutter_svg/svg.dart';
import 'package:springr/utils/constants.dart';


class GreenActivityPage extends StatefulWidget {
  const GreenActivityPage({super.key});

  @override
  State<StatefulWidget> createState() => GreenActivityPageState();
}

class GreenActivityPageState extends State<GreenActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: scaffoldColor,
        leadingWidth: 100.w,
        title: Text(
          'Green Activity', // Đổi tiêu đề cho phù hợp
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
      ),
      body: ListView(
        padding: REdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // Phần card xanh ở trên
          _buildDottedCard(),
          SizedBox(height: 24.h),

          // Danh sách các hoạt động
          _buildActivityListItem(
            icon: Icons.water_drop_outlined,
            title: 'Use Personal Bottle',
            points: 5,
          ),
          SizedBox(height: 12.h),
          _buildActivityListItem(
            icon: Icons.shopping_cart_outlined,
            title: 'Shop from Green Brands',
            points: 5,
          ),
          SizedBox(height: 12.h),
          _buildActivityListItem(
            icon: Icons.train_outlined,
            title: 'Green Transport',
            points: 5,
          ),
          SizedBox(height: 12.h),
          _buildActivityListItem(
            icon: Icons.recycling_outlined,
            title: 'Recycling',
            points: 5,
          ),
          SizedBox(height: 12.h),
          _buildActivityListItem(
            icon: Icons.recycling_outlined,
            title: 'Sort Waste',
            points: 1,
          ),
          SizedBox(height: 12.h),
          _buildActivityListItem(
            icon: Icons.recycling_outlined,
            title: 'Green Volunteering',
            points: 10,
          ),
          SizedBox(height: 12.h),
          _buildActivityListItem(
            icon: Icons.recycling_outlined,
            title: 'Use Paper Bags',
            points: 2,
          ),
          SizedBox(height: 12.h),
          _buildActivityListItem(
            icon: Icons.recycling_outlined,
            title: ' Plant Trees',
            points: 5,
          ),
        ],
      ),
    );
  }

  // Widget cho card thông tin màu xanh ở trên cùng
  Widget _buildDottedCard() {
    return DottedBorder(
      color: Colors.grey.shade600,
      strokeCap: StrokeCap.butt,
      dashPattern: const [8, 6],
      borderType: BorderType.RRect,
      strokeWidth: 2,
      radius: Radius.circular(6.r),
      padding: REdgeInsets.all(0), // Đặt padding của DottedBorder là 0
      child: InkWell(
        onTap: () {
          // Xử lý sự kiện nhấn vào đây
        },
        child: Container(
          // Dùng container để thêm padding bên trong cho các icon
          padding: REdgeInsets.all(16),
          // Không có color để nền được trong suốt
          color: Color(0xFF66CDAA),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Dàn đều 2 icon
            children: [
              // Icon SVG thứ nhất
              SvgPicture.asset(
                'assets/svg/qr_code.svg', // Thay bằng đường dẫn icon của bạn
                width: 150.w,
                height: 150.h,
              ),
              // Icon SVG thứ hai
              SvgPicture.asset(
                'assets/svg/camera_bro.svg', // Thay bằng đường dẫn icon của bạn
                width: 150.w,
                height: 150.h,
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Widget cho một mục trong danh sách hoạt động
  Widget _buildActivityListItem({
    required IconData icon,
    required String title,
    required int points,
  }) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      child: ListTile(
        leading: Icon(icon, color: primaryColor, size: 32.sp),
        title: Text(title, style: smallTextStyle.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '+$points điểm',
          style: smallTextStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey, size: 28.sp),
        onTap: () {
          // Xử lý sự kiện khi nhấn vào một mục
        },
      ),
    );
  }
}