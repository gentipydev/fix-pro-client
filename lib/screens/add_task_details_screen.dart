import 'package:fit_pro_client/models/task.dart';
import 'package:fit_pro_client/providers/map_provider.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/screens/home_screen.dart';
import 'package:fit_pro_client/screens/profile_screen/payments_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/widgets/select_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';


class ToolSuggestion {
  final String title;
  final String imagePath;

  ToolSuggestion({required this.title, required this.imagePath});
}

final List<ToolSuggestion> fakeTools = [
  ToolSuggestion(title: 'Furçe Lyerje', imagePath: 'assets/images/furce_lyerje.png'),
  ToolSuggestion(title: 'Sharre Elektrike', imagePath: 'assets/images/sharre_elektrike.png'),
  ToolSuggestion(title: 'Thika', imagePath: 'assets/images/thika.png'),
  ToolSuggestion(title: 'Trapan', imagePath: 'assets/images/trapan.png'),
];


class AddTaskDetails extends ConsumerStatefulWidget {
  final Task task;

  const AddTaskDetails({super.key, required this.task});

  @override
  ConsumerState<AddTaskDetails> createState() => _AddTaskDetailsState();
}

class _AddTaskDetailsState extends ConsumerState<AddTaskDetails> {
  Logger logger = Logger();
  final TextEditingController _detailsController = TextEditingController();
  String? selectedPaymentMethod = 'Shto mënyrën e pagesës';

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        title: const Text(
          'Rishiko dhe konfirmo',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16
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
                  colors: [AppColors.white, AppColors.grey100],
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
                        widget.task.taskWorkGroup.title,
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
                            width: 3.w,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundImage: AssetImage(widget.task.tasker.profileImage),
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
           _buildDetailsSection(), 
           SizedBox(height: 10.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    'Profesionisti do të sjell veglat e veta',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey700,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: widget.task.bringOwnTools,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.task.bringOwnTools = value ?? true;
                        });
                      },
                      activeColor: AppColors.tomatoRed,
                      checkColor: AppColors.white,
                      side: const BorderSide(
                        color: AppColors.grey700,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),

                if (!widget.task.bringOwnTools)
                  ExpansionTile(
                    title: const Text(
                      'Zgjidhni Veglat',
                      style: TextStyle(fontSize: 14, color: AppColors.grey700),
                    ),
                    tilePadding: EdgeInsets.zero,
                    iconColor: AppColors.tomatoRed,
                    children: [
                      if (widget.task.taskTools != null && widget.task.taskTools!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: widget.task.taskTools!.map((tool) {
                              return Chip(
                                label: Text(
                                  tool,
                                  style: const TextStyle(
                                    color: AppColors.grey700,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: AppColors.tomatoRedLighter,
                                deleteIcon: const Icon(Icons.close, size: 20),
                                onDeleted: () {
                                  setState(() {
                                    widget.task.taskTools!.remove(tool);
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  side: BorderSide.none,
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: fakeTools.length,
                        itemBuilder: (context, index) {
                          final tool = fakeTools[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Image.asset(
                                tool.imagePath,
                                width: 50.w,
                                height: 50.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              tool.title,
                              style: TextStyle(
                                color: AppColors.grey700,
                                fontSize: 16.sp,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                widget.task.taskTools ??= [];
                                if (!widget.task.taskTools!.contains(tool.title)) {
                                  widget.task.taskTools!.add(tool.title);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
            
            SizedBox(height: 80.h)
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
            String newDetails = _detailsController.text;

            if (newDetails.isNotEmpty) {
              if (widget.task.taskDetails == null || widget.task.taskDetails!.isEmpty) {
                widget.task.taskDetails = newDetails;
              } else {
                widget.task.taskDetails = '${widget.task.taskDetails!}\n$newDetails';
              }
            }

            final taskStateNotifier = ref.read(taskStateProvider.notifier);
            final mapStateNotifier = ref.read(mapStateProvider.notifier);

            taskStateNotifier.resetTask();
            mapStateNotifier.clearPolylines();

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
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: true,
                builder: (context) => PaymentBottomSheet(
                  onPaymentMethodSelected: (method) {
                    setState(() {
                      selectedPaymentMethod = method; 
                    });
                  },
                ),
              );
            },
            child: Text(
              selectedPaymentMethod ?? 'Shto mënyrën e pagesës',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.tomatoRed,
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
            '${widget.task.tasker.skills.first.taskGroup.feePerHour.round()} lek/orë pune',
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

  Widget _buildDetailsSection() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.grey100],
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
            controller: _detailsController,
            maxLines: 3,
            cursorColor: AppColors.grey700,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.grey700,
            ),
            decoration: InputDecoration(
              hintText:
                  'Për shembull, çfarë mjetesh pune janë të nevojshme, ku mund të parkojë, apo detaje të tjera...',
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
    );
  }
}



