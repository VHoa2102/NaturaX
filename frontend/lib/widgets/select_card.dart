import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/constants.dart';

const String cardBackgroundPattern = '''
<svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <pattern id="wave-pattern" x="0" y="0" width="80" height="40" patternUnits="userSpaceOnUse">
            <path d="M 0 20 Q 20 0 40 20 T 80 20" stroke="white" stroke-width="0.5" fill="none" stroke-opacity="0.1"/>
            <path d="M 0 30 Q 20 10 40 30 T 80 30" stroke="white" stroke-width="0.5" fill="none" stroke-opacity="0.1"/>
        </pattern>
    </defs>
    <rect width="100%" height="100%" fill="url(#wave-pattern)"/>
</svg>
''';

class SelectCard extends StatelessWidget {
  const SelectCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng ScreenUtilInit ở đầu ứng dụng của bạn để khởi tạo
    // ScreenUtilInit(
    //   designSize: const Size(375, 812),
    //   builder: (context , child) { ... }
    // );

    return SizedBox(
      // Chiều cao tổng thể cho widget, đủ không gian cho hiệu ứng xếp chồng
      height: 220.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Lớp thẻ "bóng" dưới cùng (xanh đậm)
          Positioned(
            bottom: 0,
            left: 8.w,
            right: 8.w,
            child: Container(
              height: 204.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1A535C), // Màu xanh đậm
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
            ),
          ),
          // Lớp thẻ "bóng" ở giữa (xanh lá cây)
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: Container(
              height: 204.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50), // Màu xanh lá cây
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
            ),
          ),
          // Thẻ chính hiển thị nội dung (lớp trên cùng)
          Positioned(
            bottom: 8.h,
            left: 0.w,
            right: 0.w,
            top: 0,
            child: Container(
              height: 204.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E6042), // Màu xanh chủ đạo
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              // Stack bên trong để đặt họa tiết nền phía sau nội dung
              child: Stack(
                children: [
                  // Họa tiết nền của thẻ, sử dụng SvgPicture.string
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      child: SvgPicture.string(
                        cardBackgroundPattern,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Nội dung chính của thẻ
                  Padding(
                    padding: REdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hàng 1: Tên chủ thẻ và icon Wifi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'M Kem Da',
                              style: mediumTextStyle.copyWith(color: whiteColor),
                            ),
                            SvgPicture.asset(
                              'assets/svg/wifi_icon.svg', // Đảm bảo bạn có file này
                              width: 24.w,
                              colorFilter: const ColorFilter.mode(whiteColor, BlendMode.srcIn),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        // Icon Chip
                        SvgPicture.asset(
                          'assets/svg/chip_icon.svg', // Đảm bảo bạn có file này
                          width: 40.w,
                        ),
                        SizedBox(height: 8.h),
                        // Số thẻ
                        Text(
                          '2340  ****  ****  1234',
                          style: largeTextStyle.copyWith(color: whiteColor),
                        ),
                        const Spacer(), // Đẩy nội dung bên dưới xuống cuối
                        // Hàng cuối: Ngày hết hạn, CVV và Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                // Ngày hết hạn
                                _buildCardInfo('VALID\nTHRU', '12/22'),
                                SizedBox(width: 16.w),
                                // Mã CVV
                                _buildCardInfo('CVV\nCVC', '212'),
                              ],
                            ),
                            // Logo "sống xanh" (biểu tượng chiếc lá)
                            Icon(
                              Icons.spa_outlined,
                              color: whiteColor.withValues(alpha: 0.8),
                              size: 40.w,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget phụ để tạo thông tin (VALID THRU, CVV) cho gọn
  Widget _buildCardInfo(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 7.sp,
            fontWeight: FontWeight.w400,
            color: whiteColor.withValues(alpha: 0.7),
            height: 1.2,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
        ),
      ],
    );
  }
}
