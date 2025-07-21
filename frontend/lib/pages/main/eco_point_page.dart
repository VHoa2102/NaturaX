import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Giả sử bạn có package này
import 'package:percent_indicator/circular_percent_indicator.dart'; // Giả sử bạn có package này
import 'package:springr/utils/constants.dart';


//===========================================================
// DỊCH VỤ DỮ LIỆU
//===========================================================
class ChartDataService {
  /// Tải về một bộ dữ liệu mô phỏng trong một khoảng thời gian.
  static Future<List<FlSpot>> fetchChartData({int totalDays = 30}) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(seconds: 1));
    final random = Random();
    // Dữ liệu được tạo từ x=0 (ngày xa nhất) đến x = totalDays-1 (ngày gần nhất)
    final data = List.generate(totalDays, (index) {
      return FlSpot(index.toDouble(), random.nextDouble() * 18 + 2); // Giá trị Y ngẫu nhiên từ 2 đến 20
    });
    return data;
  }
}


//===========================================================
// WIDGET BIỂU ĐỒ ĐƯỜNG (_LineChart)
//===========================================================
class _LineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minX;
  final double maxX;
  final int totalDays;

  const _LineChart({
    required this.spots,
    required this.minX,
    required this.maxX,
    required this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 22, // Đặt cao hơn một chút so với dữ liệu tối đa
        minX: minX,
        maxX: maxX,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(colors: [myColor2, primaryColor]),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  secondaryColor.withValues(alpha: 0.3),
                  primaryColor.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ],
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: _titlesData,
      ),
    );
  }

  /// TÍNH TOÁN ĐỘNG NHÃN TRỤC X
  /// Tính toán tên ngày trong tuần dựa trên giá trị (chỉ số) của dữ liệu.
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: myColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    final today = DateTime.now();
    // Tính ngày thực tế tương ứng với chỉ số 'value'.
    // (totalDays - 1) là chỉ số của ngày hôm nay.
    final dayToShow = today.subtract(Duration(days: (totalDays - 1) - value.toInt()));

    String text;
    // Dùng chữ cái đầu của ngày để tiết kiệm không gian
    switch (dayToShow.weekday) {
      case DateTime.sunday: text = 'Su'; break;
      case DateTime.monday: text = 'Mo'; break;
      case DateTime.tuesday: text = 'Tu'; break;
      case DateTime.wednesday: text = 'We'; break;
      case DateTime.thursday: text = 'Th'; break;
      case DateTime.friday: text = 'Fr'; break;
      case DateTime.saturday: text = 'Sa'; break;
      default: text = ''; break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get _titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1, // Hiển thị nhãn cho mỗi ngày
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );
}

//===========================================================
// TRANG VÍ (WALLET PAGE)
//===========================================================
class EcoPointPage extends StatefulWidget {
  const EcoPointPage({super.key});

  @override
  State<StatefulWidget> createState() => EcoPointPageState();
}

class EcoPointPageState extends State<EcoPointPage> {
  Future<List<FlSpot>>? _fullDataFuture;

  // Các hằng số để điều khiển dữ liệu và cửa sổ xem
  static const int _totalDays = 30; // Tổng số ngày dữ liệu
  static const double _windowSize = 7.0; // Cửa sổ xem là 7 ngày

  // Biến trạng thái cho Slider. Bắt đầu ở vị trí hiển thị tuần gần nhất.
  double _sliderValue = (_totalDays - _windowSize);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _fullDataFuture = ChartDataService.fetchChartData(totalDays: _totalDays);
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo ScreenUtil nếu bạn dùng package này
    // ScreenUtil.init(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: scaffoldColor,
          leadingWidth: 100.w,
          title: Text(
            'Eco Point',
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _walletWidget(),
          ),
        ),
      ),
    );
  }

  Widget _walletWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabBar(
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: <Tab>[
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _weeklyWidget(),
              const Center(child: Text('Dữ liệu tháng.')),
              const Center(child: Text('Dữ liệu năm.')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weeklyWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BIỂU ĐỒ VÀ FUTURE BUILDER
          AspectRatio(
            aspectRatio: 1.6,
            child: FutureBuilder<List<FlSpot>>(
              future: _fullDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có dữ liệu.'));
                }
                // Truyền dữ liệu và các giá trị cần thiết vào _LineChart
                return _LineChart(
                  spots: snapshot.data!,
                  minX: _sliderValue,
                  maxX: _sliderValue + _windowSize - 1,
                  totalDays: _totalDays,
                );
              },
            ),
          ),

          // THANH TRƯỢT (SLIDER)
          Slider(
            value: _sliderValue,
            min: 0,
            max: (_totalDays - _windowSize),
            divisions: (_totalDays - _windowSize.toInt()),
            label: 'Xem từ ngày ${30 - _sliderValue.round()} trước',
            activeColor: primaryColor,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),

          const SizedBox(height: 16),
          Text('Details', style: mediumTextStyle),
          const SizedBox(height: 16),

          // CÁC THẺ CHI TIẾT
          _buildDetailCard(
              title: 'Total Eco Points Earned',
              amount: '\$1,000.00',
              percent: 0.65,
              color: primaryColor,
              progressColor: secondaryColor),
          const SizedBox(height: 16),
          _buildDetailCard(
              title: 'Total Number of Green Activities',
              amount: '\$2,500.00',
              percent: 0.85,
              color: const Color(0xFF7C7C7C),
              progressColor: Colors.green),
          const SizedBox(height: 24),

          // LỊCH SỬ GIAO DỊCH
          Text('History', style: mediumTextStyle),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, index) {
              final isIncome = index % 3 == 0;
              return ListTile(
                leading: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? Colors.green : Colors.red,
                ),
                title: Text(
                  isIncome ? 'Salary Deposit' : 'Groceries',
                  style: smallTextStyle,
                ),
                subtitle: Text(
                  'July ${14 - (index % 5)}, 2025',
                  style: xSmallTextStyle,
                ),
                trailing: Text(
                  isIncome ? '+\$500.00' : '-\$${35 + index}.50',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER ĐỂ TẠO CARD
  Widget _buildDetailCard(
      {required String title,
        required String amount,
        required double percent,
        required Color color,
        required Color progressColor}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(const Radius.circular(6))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: xSmallTextStyle.copyWith(color: whiteColor)),
                const SizedBox(height: 5),
                Text(amount, style: largeTextStyle.copyWith(color: whiteColor)),
              ],
            ),
            CircularPercentIndicator(
              radius: 30,
              lineWidth: 5.0,
              percent: percent,
              backgroundColor: whiteColor.withValues(alpha: 0.5),
              center: Text(
                '${(percent * 100).toInt()}%',
                style: xSmallTextStyle.copyWith(color: whiteColor),
              ),
              progressColor: progressColor,
            ),
          ],
        ));
  }
}