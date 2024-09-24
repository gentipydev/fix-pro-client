import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerCard extends StatelessWidget {
  final Tasker tasker;
  final Function() onViewProfile;
  final Function() onRemove;

  const TaskerCard({
    super.key,
    required this.tasker,
    required this.onViewProfile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.grey200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(tasker.profileImage),
                radius: 40.r,
              ),
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        tasker.fullName,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey700,
                        ),
                      ),
                      tasker.isFavorite
                      ? IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: AppColors.tomatoRed,
                            size: 24.sp,
                          ),
                          onPressed: onRemove,
                        )
                      : const SizedBox.shrink(),
                      SizedBox(width: 20.w),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '2000 ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.tomatoRed,
                              ),
                            ),
                            TextSpan(
                              text: 'lek/ora',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.tomatoRed,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${tasker.rating} (27 vleresime)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '23 montime mobiliesh ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.tomatoRed,
                          ),
                        ),
                        TextSpan(
                          text: 'te perfunduara',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '47 pune ne total',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(12.w),

            decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.grey200, AppColors.grey250],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasker.bio,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey700,
                  ),
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: onViewProfile,
                  child: Text(
                    'Shiko Profilin',
                    style: TextStyle(
                      color: AppColors.tomatoRed,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
