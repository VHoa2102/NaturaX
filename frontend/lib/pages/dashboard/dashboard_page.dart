import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:springr/pages/main/eco_point_page.dart';
import 'package:springr/pages/main/green_activity_page.dart';
import 'package:springr/pages/main/green_society.dart';
import 'package:springr/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/balance_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldColor,
        toolbarHeight: 50.h,
        title: RPadding(
          padding: REdgeInsets.only(left: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Hello     Kem da',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF160D07),
                ),
              ),
              Text('Wellcome Back!', style: smallTextStyle),
            ],
          ),
        ),


        actions: [
          Padding(
            padding: REdgeInsets.only(top: 20.h),
            child: InkWell(
              onTap: () {
                // Logic nút thông báo
              },
              child: Container(
                margin: REdgeInsets.all(5),
                // padding: REdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: kDefaultBoxShadow,
                  color: whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(3.r)),
                ),
                child: SvgPicture.asset(
                'assets/svg/notifications_icon.svg',
                width: 25.w,
                height: 25.h,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
        ],
      ),

      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: REdgeInsets.all(22),
        children: [
          const BalanceCard(),
          SizedBox(
            height: 24.h,
          ),
          // SizedBox(
          //   height: 90.h,
          //   child: ListView.separated(
          //     scrollDirection: Axis.horizontal,
          //     physics: const BouncingScrollPhysics(),
          //     itemCount: 5,
          //     itemBuilder: (context, index) {
          //       switch(index) {
          //         case 0:
          //           return _card('assets/svg/chip_icon.svg', 'Account', () {
          //           // Logic
          //           });
          //         case 1:
          //           return _card('assets/svg/loan_icon.svg', 'Analyze', () {
          //           // Logic
          //           });
          //         case 2:
          //           return _card('assets/svg/time_icon.svg', 'Deadline', () {
          //           // logic
          //           });
          //         case 3:
          //           return _card('assets/svg/delete_icon.svg', 'Garbage', () {
          //             // Logic
          //           });
          //         case 4:
          //           return _card('assets/svg/bill_icon.svg', 'Bill', () {
          //             // Logic
          //           });
          //       }
          //     },
          //     separatorBuilder: (context, index) => SizedBox(width: 16.w),
          //   ),
          // ),
          // SizedBox(
          //   height: 16.h,
          // ),
          Text(
            'Main function',
            style: mediumTextStyle,
          ),
          SizedBox(
            height: 16.h,
          ),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            children: [
              _buildGridButton('GREEN ACTIVITY','assets/svg/hanh_dong_xanh.svg', primaryColor, () {
                // Logic
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GreenActivityPage()),
                );//
              }),
              _buildGridButton('GREEN SOCIETY', 'assets/svg/tich_luy_xanh.svg', buttonColorGey, () {
                // Logic
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GreenSocietyPage()),
                );// Để deb
              }),
              _buildGridButton('ECO POINT', 'assets/svg/xa_hoi_xanh.svg', buttonColorGey, () {
                // Logic
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EcoPointPage()),
                );// Để deb
              }),
              _buildGridButton('GREEN OFFER', 'assets/svg/uu_dai_xanh.svg', primaryColor,() {
                // Logic
              }),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildGridButton(String title, String iconPath, Color backgroundColor, VoidCallback onPressed) {
  // Tự động xác định màu chữ dựa trên độ sáng của màu nền
  final bool isDarkBackground = backgroundColor.computeLuminance() < 0.5;
  final Color textColor = isDarkBackground ? Colors.white : Colors.black87;

  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(16.r),
    child: Ink(
      padding: REdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Dòng chữ ở trên
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 8.h),
          // Hình ảnh SVG ở dưới, tự động co giãn để lấp đầy không gian
          Expanded(
            child: SvgPicture.asset(
              iconPath,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red.shade100,
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}