import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

const Color scaffoldColor = Color(0xFFF5F5F5);
const Color primaryColor = Color(0xFF609966);
const Color secondaryColor = Color(0xFF9DC08B);
const Color thirdColor = Color(0xFFEDF1D6);
const Color boxColor = Color(0xFFDDF6D2);
const Color secondaryButtonColor = Color(0xFF40513B);
const Color buttonColorGey = Color(0xFFE0E0E0);
const Color myColor = Color(0xFF1E6042);
const Color myColor2 = Color(0xFF4CAF50);

// BỔ SUNG: Các sắc thái xanh lá khác
const Color vibrantGreen = Color(0xFF4CAF50); // Xanh lá cây tươi, rực rỡ
const Color lightGreen = Color(
  0xFFC8E6C9,
); // Xanh lá cây rất nhạt, dùng cho nền
const Color darkGreen = Color(
  0xFF2E7D32,
); // Xanh lá cây đậm, dùng cho chữ hoặc nền tối
const Color accentGreen = Color(
  0xFF69F0AE,
); // Xanh lá cây nhấn, dùng cho các yếu tố nổi bật
const Color primaryGreen = Color(0xFF2E7D32); // Một màu xanh lá đậm, sang trọng
const Color lightGreenBackground = Color(
  0xFFF1F8E9,
); // Màu nền xanh lá rất nhạt

// --- Màu cơ bản (Basic Colors) ---
const Color fillColor = Color(0xFFFFFFFF);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blackColor = Color(0xFF000000);

// --- Màu chức năng (Functional Colors) ---
const Color orangeColor = Color(0xFFCA7842);
const Color navigationIconColor = Color(0xFF757575);
const Color goldColor = Color(0xFFFFD700);
const Color silverColor = Color(0xFFC0C0C0);
const Color bronzeColor = Color(0xFFCD7F32);
// =================================================================
// BỔ SUNG: CÁC MÀU HỮU ÍCH KHÁC
// =================================================================

// --- Màu cho văn bản (Text Colors) ---
// Màu chữ chính trên nền sáng
const Color primaryTextColor = Color(0xFF212121);
// Màu chữ phụ, cho các mô tả hoặc chú thích
const Color secondaryTextColor = Color(0xFF757575);

// --- Màu trạng thái (Status Colors) ---
// Màu cho thông báo lỗi
const Color errorColor = Color(0xFFD32F2F);
// Màu cho thông báo thành công
const Color successColor = Color(0xFF388E3C);
// Màu cho cảnh báo
const Color warningColor = Color(0xFFFFA000);

// --- Màu trung tính (Neutral Colors) ---
// Màu cho các đường kẻ phân chia (dividers)
const Color dividerColor = Color(0xFFE0E0E0);
// Màu nền cho các trạng thái vô hiệu hóa (disabled)
const Color disabledColor = Color(0xFFBDBDBD);

const String fontName = 'Plus Jakarta Sans';

final heading1 = TextStyle(
  fontFamily: fontName,
  fontSize: 32.sp,
  fontWeight: FontWeight.w700,
  color: fillColor,
);

final heading2 = TextStyle(
  fontFamily: fontName,
  fontSize: 24.sp,
  fontWeight: FontWeight.w700,
  color: fillColor,
);

final TextStyle heading2Dark = heading2.copyWith(color: Colors.black87);

final descriptionStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 16.sp,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF767D88),
);

final largeTextStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 20.sp,
  fontWeight: FontWeight.w600,
  color: const Color(0xFF160D07),
);

final smallTextStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 14.sp,
  fontWeight: FontWeight.w600,
  color: const Color(0xFF160D07),
);

final TextStyle linkText = smallTextStyle.copyWith(
  color: primaryGreen,
  fontWeight: FontWeight.bold,
);

final mediumTextStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: const Color(0xFF160D07),
);

final xSmallTextStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 12.sp,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF767D88),
);

final xXSmallTextStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 10.sp,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF767D88),
);

final TextStyle xSmallTextDark = xSmallTextStyle.copyWith(
  color: Colors.grey[700],
);
final TextStyle smallTextDark = smallTextStyle.copyWith(color: Colors.black54);

final hintTextStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 12.sp,
  fontWeight: FontWeight.w500,
  color: const Color(0xFF9FA4AB),
);

final inputTextStyle = TextStyle(
  fontFamily: fontName,
  fontSize: 12.sp,
  fontWeight: FontWeight.w500,
  color: const Color(0xFF160D07),
);

launchURLFunction(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw Exception('Could not launch $url');
  }
}

List<BoxShadow> kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.grey.withValues(alpha: 0.2),
    spreadRadius: 0,
    blurRadius: 16,
    offset: const Offset(0, -4),
  ),
];

List<BoxShadow> kGreenBoxShadow = [
  BoxShadow(
    color: boxColor.withValues(alpha: 0.8),
    spreadRadius: 0,
    blurRadius: 16,
    offset: const Offset(0, -4),
  ),
];

final listViewSeparator = Divider(color: const Color(0xFFEDEEF0), height: 2.h);
