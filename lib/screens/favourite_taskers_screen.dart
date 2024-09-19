import 'package:fit_pro_client/cards/tasker_card.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/providers/taskers_provider.dart';

class FavouriteTaskersScreen extends StatelessWidget {
  const FavouriteTaskersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tomatoRed,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        title: const Text(
          'Profesionistët e preferuar',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<TaskersProvider>(
        builder: (context, taskersProvider, child) {
          final taskers = taskersProvider.taskers;

          if (taskers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Nuk ka asnjë profesionistë të preferuar për momentin',
                  style: TextStyle(fontSize: 18.sp, color: AppColors.grey700),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: taskers.length,
            itemBuilder: (context, index) {
              final tasker = taskers[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TaskerCard(
                  tasker: tasker,
                  onViewProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskerProfileScreen(),
                      ),
                    );
                  },
                  // Handle tasker removal
                  onRemove: () {
                    taskersProvider.removeTasker(tasker);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
