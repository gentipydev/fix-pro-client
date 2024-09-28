import 'package:fit_pro_client/cards/tasker_card.dart';
import 'package:fit_pro_client/models/tasker.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/providers/taskers_provider.dart';
import 'package:flutter/cupertino.dart';

class FavouriteTaskersScreen extends StatefulWidget {
  const FavouriteTaskersScreen({super.key});

  @override
  FavouriteTaskersScreenState createState() => FavouriteTaskersScreenState();
}

class FavouriteTaskersScreenState extends State<FavouriteTaskersScreen> with SingleTickerProviderStateMixin {
  String _sortBy = 'Emri (A-Z)';
  int _currentIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _sortTaskers(String criteria) {
    setState(() {
      _sortBy = criteria;
    });
  }

  void _showSortOptions() {
    List<String> sortOptions = [
      'Emri (A-Z)',
      'Emri (Z-A)',
      'Vlerësimet (më të lartat fillimisht)',
      'Vlerësimet (më të ulëtat fillimisht)',
    ];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      'Rendit sipas',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ...sortOptions.map((String value) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: _sortBy == value ? AppColors.tomatoRed : AppColors.grey700,
                              ),
                            ),
                            trailing: _sortBy == value
                                ? const Icon(Icons.check, color: AppColors.tomatoRed)
                                : null,
                            onTap: () {
                              _sortTaskers(value);
                              Navigator.pop(context);
                            },
                          ),
                          Divider(color: AppColors.grey300, thickness: 0.5.w),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10.h,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    size: 30.w,
                    color: AppColors.grey300,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _currentIndex,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.tomatoRed,
          iconTheme: const IconThemeData(
            color: AppColors.white,
          ),
          title: const Text(
            'Profesionistët',
            style: TextStyle(color: AppColors.white, fontSize: 18),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Container(
              color: AppColors.white,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                labelColor: AppColors.tomatoRed,
                unselectedLabelColor: AppColors.grey700,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: AppColors.tomatoRed, width: 4.w),
                  insets: EdgeInsets.symmetric(horizontal: 100.w),
                ),
                tabs: const [
                  Tab(text: 'PREFERUAR'),
                  Tab(text: 'KALUAR'),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<TaskersProvider>(
          builder: (context, taskersProvider, child) {
            final favoriteTaskers = taskersProvider.favoriteTaskers;
            final pastTaskers = taskersProvider.pastTaskers;

            return TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTaskersList(favoriteTaskers, taskersProvider),
                _buildTaskersList(pastTaskers, taskersProvider),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        floatingActionButton: _currentIndex == 1
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.tomatoRed,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: InkWell(
                    onTap: _showSortOptions,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Rendit sipas',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Icon(Icons.sort, color: AppColors.white),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildTaskersList(List<Tasker> taskers, TaskersProvider taskersProvider) {
    if (taskers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Nuk ka asnjë profesionistë për momentin',
            style: TextStyle(fontSize: 18.sp, color: AppColors.grey700),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: taskers.length,
      itemBuilder: (context, index) {
        final tasker = taskers[index];
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: TaskerCard(
            tasker: tasker,
            onViewProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskerProfileScreen(tasker: tasker),
                ),
              );
            },
            onRemove: () {
              taskersProvider.removeTaskerFromFavorites(tasker);
            },
          ),
        );
      },
    );
  }
}
