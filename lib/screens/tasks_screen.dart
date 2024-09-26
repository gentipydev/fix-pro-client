import 'package:fit_pro_client/cards/task_card.dart';
import 'package:fit_pro_client/providers/tasks_provider.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'task_details_screen.dart';


class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  Logger logger = Logger();
  String _sortBy = 'Data (më të rejat fillimisht)';
  int _currentIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TasksProvider>(context, listen: false).fetchTasks();
    });
  }

  void _sortTasks(String criteria) {
    setState(() {
      _sortBy = criteria;
      // Implement your sorting logic here based on the criteria
    });
  }

  void _showSortOptions() {
    List<String> sortOptions;
    if (_currentIndex == 1) {
      sortOptions = [
        'Data (më të rejat fillimisht)',
        'Data (më të vjetrat fillimisht)',
      ];
    } else if (_currentIndex == 2) {
      sortOptions = [
        'Data (më të rejat fillimisht)',
        'Data (më të vjetrat fillimisht)',
        'Shuma e Faturuar (më të lartat fillimisht)',
        'Shuma e Faturuar (më të ulëtat fillimisht)',
      ];
    } else {
      sortOptions = [
        'Data (më të rejat fillimisht)',
        'Data (më të vjetrat fillimisht)',
      ];
    }

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
                              _sortTasks(value);
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
          title: const Text(
            'Punët e Mia',
            style: TextStyle(color: AppColors.white, fontSize: 18),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
                  Tab(text: 'POROSITURA'),
                  Tab(text: 'PËRFUNDUARA'),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<TasksProvider>(
          builder: (context, tasksProvider, child) {
            if (tasksProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.tomatoRed),
              );
            }
            return TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Current tasks tab content
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PUNËT E REJA (${tasksProvider.currentTasks.length})',
                          style: TextStyle(fontSize: 16.sp, color: AppColors.grey700),
                        ),
                        SizedBox(height: 16.h),
                        if (tasksProvider.currentTasks.isEmpty)
                          Center(
                            child: Text(
                              'Nuk ka asnjë punë për momentin',
                              style: TextStyle(fontSize: 18.sp, color: AppColors.grey700),
                            ),
                          )
                        else
                          Column(
                            children: tasksProvider.currentTasks.map((task) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetailsScreen(task: task),
                                      ),
                                    );
                                  },
                                  child: TaskCard(
                                    title: task.title,
                                    warningText: 'Kjo punë është në proçes',
                                    date: task.date,
                                    time: task.time,
                                    location: task.taskArea!,
                                    clientName: task.clientName,
                                    clientImage: task.clientImage,
                                    showLottieIcon: true,
                                    isUrgent: true,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
                // Past tasks tab content
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'PUNËT E KALUARA (${tasksProvider.pastTasks.length})',
                                style: TextStyle(fontSize: 16.sp, color: AppColors.grey700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        if (tasksProvider.pastTasks.isEmpty)
                          Center(
                            child: Text(
                              'Nuk ka asnjë punë të kaluar',
                              style: TextStyle(fontSize: 18.sp, color: AppColors.grey700),
                            ),
                          )
                        else
                          Column(
                            children: tasksProvider.pastTasks.map((task) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetailsScreen(task: task),
                                      ),
                                    );
                                  },
                                  child: TaskCard(
                                    title: task.title,
                                    warningText: 'Puna u përfundua',
                                    date: task.date,
                                    time: task.time,
                                    location: task.location,
                                    clientName: task.clientName,
                                    clientImage: task.clientImage,
                                    showLottieIcon: false,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (_currentIndex == 1 || _currentIndex == 2)
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
}
