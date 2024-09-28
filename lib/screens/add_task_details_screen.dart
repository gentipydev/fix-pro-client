import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/home_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/select_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AddTaskDetails extends StatelessWidget {
  const AddTaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: const Text(
          'Rishiko dhe konfirmo',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.white, AppColors.grey200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40.w, 
                        height: 40.h, 
                        child: Lottie.asset(
                          'assets/animations/credit_card_payment.json',
                          repeat: false,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Mos u shqetësoni, ju do të paguani vetëm\nne përfundim te punës',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Montim mobiliesh",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.grey700
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.grey300,
                            width: 3.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundImage: const AssetImage('assets/images/client3.png'),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: AppColors.grey100, thickness: 1.w),
                  SizedBox(height: 10.h),
                  const SelectTime(),
                  Divider(color: AppColors.grey200, thickness: 1.w),
                  SizedBox(height: 10.h),
                  _buildPaymentSection(context),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            
            // Section for adding details
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.white, AppColors.grey200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detajet e Punës',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Detajet shtesë ndihmojnë profesionistin të përgatitet për punën',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    maxLines: 3,
                    cursorColor: AppColors.grey700,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey700,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Për shembull, çfarë mjetesh pune janë të nevojshme, ku mund të parkojë, apo detaje të tjera...',
                      hintStyle: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 14.sp,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey300, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey300, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey300, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '*Ju lutemi ndani disa detaje me profesionistin tuaj. Sigurisht që më vonë mund të bisedoni për të bërë ndryshime',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.tomatoRed,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tomatoRed,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            final taskStateProvider = Provider.of<TaskStateProvider>(context, listen: false);
            final mapProvider = Provider.of<MapProvider>(context, listen: false);
            taskStateProvider.resetTask(); 
            mapProvider.clearPolylines();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            'Ruaj Detajet e Punës',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            'Pagesa',
            style: TextStyle(
              fontSize: 18.sp, 
              color: AppColors.grey700
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              // Handle payment action
            },
            child: Text(
              'Shto mënyrën e pagesës',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.tomatoRed
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Promo',
              style: TextStyle(
              fontSize: 18.sp, 
              color: AppColors.grey700
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              // Handle promo code action
            },
            child: Text(
              'Shto kodin promocional',
                style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.tomatoRed
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Tarifa për orë',
            style: TextStyle(
              fontSize: 18.sp, 
              color: AppColors.grey700
            ),
          ),
          trailing: Text(
            '2.000 lek/orë pune',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.grey700
              ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Ju mund të shihni një detyrim të përkohshëm në shumën prej 2.000 lekë. Por mos u shqetësoni -- pagesa do të bëhet vetëm kur puna juaj të përfundojë!',
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.grey700,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.tomatoRed,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Nëse anulloni punë tuaj brenda 4 orëve para kohës së caktuar, ne mund t\'ju tarifojmë një penalitet anullimi prej një ore sipas tarifes përkatëse te profesionistit',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.grey700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
