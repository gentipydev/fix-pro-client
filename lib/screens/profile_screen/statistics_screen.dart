import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class UserStatisticsScreen extends StatelessWidget {
  const UserStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: const Text(
          'Statistikat e punëve',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserKeyMetricsOverview(),
            UserTaskPerformance(),
            SpendingAndFavoriteTaskers(),
          ],
        ),
      ),
    );
  }
}

class UserKeyMetricsOverview extends StatelessWidget {
  const UserKeyMetricsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey100,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Treguesit kryesorë',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Monitoroni këto numra për të optimizuar kërkesat tuaja për punë",
            style: TextStyle(fontSize: 14.sp, color: AppColors.grey700),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            children: [
              _buildKeyMetricCard('5', 'Punët e kërkuara', ''),
              _buildKeyMetricCard('3', 'Punët e përfunduara', ''),
              _buildKeyMetricCard('80%', 'Norna e përfundimit të punëve', 'Syno for 100%'),
              _buildKeyMetricCard('Lek 12,000', 'Totali i shpenzuar', ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetricCard(String value, String label, String target) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(label, style: TextStyle(fontSize: 16.sp, color: AppColors.grey700)),
            if (target.isNotEmpty)
              SizedBox(height: 8.h),
            if (target.isNotEmpty)
              Text(target, style: TextStyle(fontSize: 14.sp, color: AppColors.grey700)),
          ],
        ),
      ),
    );
  }
}

class UserTaskPerformance extends StatelessWidget {
  const UserTaskPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performanca e punëve',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            children: [
              _buildPerformanceMetricCard('10', 'Totali i punëve te postuara'),
              _buildPerformanceMetricCard('7', 'Totali i punëve të përfunduara'),
              _buildPerformanceMetricCard('70%', 'Norma e përfundimit të punëve'),
              _buildPerformanceMetricCard('3', 'Punët e anulluara'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetricCard(String value, String label) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(label, style: TextStyle(fontSize: 16.sp, color: AppColors.grey700)),
          ],
        ),
      ),
    );
  }
}

class SpendingAndFavoriteTaskers extends StatefulWidget {
  const SpendingAndFavoriteTaskers({super.key});

  @override
  SpendingAndFavoriteTaskersState createState() => SpendingAndFavoriteTaskersState();
}

class SpendingAndFavoriteTaskersState extends State<SpendingAndFavoriteTaskers> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shpenzimet dhe profesionistët',
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 20.sp, 
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 8.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildFavoriteTaskersInfo(),
              SizedBox(height: 20.h),
              _buildSpendingInfo(),
            ]
          ),
          SizedBox(height: 20.h),
          _buildSpendingChart(),
        ],
      ),
    );
  }

  Widget _buildSpendingInfo() {
    return Row(
      children: [
        Icon(Icons.account_balance_wallet_outlined, size: 24.w),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Totali i shpenzuar',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey700,
              ),
            ),
            Text(
              'Lek 12,000',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoriteTaskersInfo() {
    return Row(
      children: [
        Icon(Icons.favorite_outline, size: 24.w),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profesionisti më i zgjedhur',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey700,
              ),
            ),
            Text(
              'Arben G.',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

Widget _buildSpendingChart() {
  return Container(
    height: 250.h,
    padding: EdgeInsets.all(16.w),
    child: LineChart(
      LineChartData(
        minY: 0,
        maxY: 30000, 
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 5000,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: AppColors.grey300,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: AppColors.grey300,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'Jan';
                    break;
                  case 1:
                    text = 'Shk';
                    break;
                  case 2:
                    text = 'Mar';
                    break;
                  case 3:
                    text = 'Pri';
                    break;
                  case 4:
                    text = 'Maj';
                    break;
                  case 5:
                    text = 'Qer';
                    break;
                  default:
                    text = '';
                }
                return Text(text, style: style);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5000, 
              getTitlesWidget: (value, meta) {
                final formatter = NumberFormat('#,###', 'en_US');
                int intValue = value.toInt();
                return Text(
                  formatter.format(intValue),
                  style: TextStyle(fontSize: 12.sp),
                );
              },
              reservedSize: 60, 
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color(0xff37434d), width: 2),
            left: BorderSide(color: Color(0xff37434d), width: 2),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((barSpot) {
                final formatter = NumberFormat('#,###', 'en_US');
                final formattedValue = formatter.format(barSpot.y);
                return LineTooltipItem(
                  'Lek $formattedValue',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _getSpendingSpots(),
            isCurved: true,
            color: AppColors.tomatoRed,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.tomatoRed.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.tomatoRed,
                strokeWidth: 0,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Define spending data spots
List<FlSpot> _getSpendingSpots() {
  return const [
    FlSpot(0, 10000),
    FlSpot(1, 12000),
    FlSpot(2, 9000),
    FlSpot(3, 15000), 
    FlSpot(4, 16000),
    FlSpot(5, 20000),
  ];
}
}
