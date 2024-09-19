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
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(tasker.profileImage),
                    radius: 35.r,
                  ),
                  SizedBox(height: 10.h),
                  if (tasker.isSuperPunetor) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.tomatoRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: AppColors.tomatoRed, width: 1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Super Punëtor',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.grey700,
                            ),
                          ),
                          Icon(
                            Icons.military_tech,
                            color: AppColors.tomatoRed,
                            size: 18.sp,
                          ),
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tasker.fullName,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey700,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: AppColors.tomatoRed,
                            size: 24.sp,
                          ),
                          onPressed: onRemove,
                        )
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.tomatoRed,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${tasker.rating} (227 vleresime)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '223 montime mobiliesh ',
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
                      '447 pune ne total',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            tasker.bio,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          TextButton.icon(
            onPressed: onViewProfile,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.tomatoRed,
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(
              Icons.person, 
              color: AppColors.grey700,
              size: 16,
              ),
            label: Text(
              'Shiko profilin',
              style: TextStyle(
                color: AppColors.tomatoRed,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
