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
      padding: EdgeInsets.all(8.w),
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
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        tasker.fullName.length > 15
                          ? '${tasker.fullName.substring(0, 10)}...'
                          : tasker.fullName,
                        style: TextStyle(
                          fontSize: 18.sp,
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
                      SizedBox(width: tasker.isFavorite ? 10.w : 60.w),
                      Text(
                        '2000 lek/ora',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.tomatoRed,
                        size: 20.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${tasker.rating} (27 vleresime)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '23 montime mobiliesh ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '47 pune ne total',
                    style: TextStyle(
                      fontSize: 16.sp,
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
            color: AppColors.grey200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasker.bio,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.grey700,
                  ),
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                TextButton(
                  onPressed: onViewProfile,
                  child: Text(
                    'Shiko Profilin',
                    style: TextStyle(
                      color: AppColors.tomatoRed,
                      fontSize: 16.sp,
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
