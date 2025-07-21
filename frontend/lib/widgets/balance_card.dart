import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:springr/pages/card/card_page.dart';

import '../utils/constants.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 5.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              width: 319.w,
              height: 135.h,
              decoration: BoxDecoration(
                // boxShadow: kDefaultBoxShadow,
                color: lightGreen,
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: 3327.w,
              height: 128.h,
              decoration: BoxDecoration(
                // boxShadow: kDefaultBoxShadow,
                color: myColor,
                borderRadius: BorderRadius.all(Radius.circular(6.r)),
              ),
            ),
          ),
          Positioned(
            child: SvgPicture.asset(
              'assets/svg/dashboard_card.svg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            child: RPadding(
              padding: REdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/chip_icon.svg', // Đường dẫn đến tệp SVG của bạn
                        width: 25.w,
                        height: 25.h,
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Balance',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans', // Thêm dòng này
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Hành động điều hướng
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CardPage(),
                            ), // Điều hướng đến CardPage
                          ); // Để debug
                        },
                        child: const Icon(
                          // Icon là con của GestureDetector
                          Icons.more_horiz,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VNĐ 46,120',
                        style: heading2.copyWith(color: lightGreenBackground),
                      ),
                      Text(
                        '1233 **** **** 1234',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
