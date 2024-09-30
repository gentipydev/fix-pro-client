import 'package:fit_pro_client/providers/task_state_provider.dart';
import 'package:fit_pro_client/providers/tasks_provider.dart';
import 'package:fit_pro_client/screens/favourite_taskers_screen.dart';
import 'package:fit_pro_client/screens/profile_screen.dart';
import 'package:fit_pro_client/screens/search_screen/search_screen.dart';
import 'package:fit_pro_client/screens/tasks_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:fit_pro_client/services/fake_data.dart';
import 'package:fit_pro_client/models/task_group.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const TasksScreen(),
    const FavouriteTaskersScreen(),
    const UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int acceptedTaskCount = context.watch<TasksProvider>().acceptedTaskCount;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const ImageIcon(AssetImage('assets/icons/tasks.png')),
                if (acceptedTaskCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.tomatoRed,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.white, width: 1),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        acceptedTaskCount > 2 ? '2+' : '$acceptedTaskCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Punët',
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/taskers.png')),
            label: 'Profesionist',
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/profile.png')),
            label: 'Profili',
          ),
        ],
        selectedItemColor: AppColors.tomatoRed,
        unselectedItemColor: AppColors.grey700,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Logger logger = Logger();
  FakeData fakeData = FakeData(); 
  List<TaskGroup> displayedTaskGroups = [];
  List<TaskGroup> filteredSuggestions = [];
  final TextEditingController _controller = TextEditingController();
  final int itemsPerPage = 6;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
   bool _imagesPrecached = false;

  @override
  void initState() {
    super.initState();
    _controller.clear();
    filteredSuggestions.clear();
    
    // Load the initial 6 items
    _loadMoreItems();

    // Add listener to the scroll controller
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoadingMore) {
        _loadMoreItems();
      }
    });
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_imagesPrecached) {
      for (var taskGroup in fakeData.fakeTaskGroups) {
        precacheImage(AssetImage(taskGroup.imagePath), context);
      }
      _imagesPrecached = true;
    }
  }

  void _loadMoreItems() {
    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final nextIndex = displayedTaskGroups.length;
      final remainingItems = fakeData.fakeTaskGroups.length - nextIndex;
      final count = remainingItems > itemsPerPage ? itemsPerPage : remainingItems;

      setState(() {
        displayedTaskGroups.addAll(fakeData.fakeTaskGroups.sublist(nextIndex, nextIndex + count));
        _isLoadingMore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.tomatoRedLight, AppColors.tomatoRed],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Përshëndetje Alexa!',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Për çfarë ju nevojitet ndihmë sot...',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        filteredSuggestions.clear();
                      } else {
                        filteredSuggestions = fakeData.fakeTaskGroups
                            .where((category) =>
                                category.title.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      }
                    });
                  },
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 16.sp,
                  ),
                  cursorColor: AppColors.grey700,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grey100,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                    hintText: "Provoni 'montim mobiliesh' ose 'lyerje'",
                    hintStyle: TextStyle(
                      color: AppColors.grey300,
                      fontSize: 16.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 22.sp,
                      color: AppColors.grey700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                // Display filtered suggestions with images
                if (filteredSuggestions.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = filteredSuggestions[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.asset(
                              suggestion.imagePath,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            suggestion.title,
                            style: TextStyle(
                              color: AppColors.grey700,
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _controller.clear();
                              filteredSuggestions.clear();
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategorite e puneve',
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Flexible or Expanded to make GridView take remaining space
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: _buildCategoryGrid(),
          ),
          if (_isLoadingMore) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 20.h,
          childAspectRatio: 1.2,
        ),
        itemCount: displayedTaskGroups.length,
        itemBuilder: (context, index) {
          final category = displayedTaskGroups[index];
          return GestureDetector(
            onTap: () {
              context.read<TaskStateProvider>().setSelectedTaskGroup(category);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      category.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  category.title,
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

Widget _buildLoadingIndicator() {
    return const Center(
      child: SpinKitThreeBounce(
        color: AppColors.tomatoRed,
        size: 16.0,
      ),
    );
  }
}
