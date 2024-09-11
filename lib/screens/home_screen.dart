import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_pro_client/providers/taskers_provider.dart';
import 'package:fit_pro_client/screens/tasker_profile_screen.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const HomeContent(),
    const HomeContent(),
    const HomeContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/tasks.png')),
            label: 'Punët',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/taskers.png')),
            label: 'Preferuarit',
          ),
          BottomNavigationBarItem(
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
  List<Map<String, String>> filteredSuggestions = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  bool _hasPrecachedImages = false;

  final List<Map<String, String>> categories = [
    {'name': 'Montim mobiliesh', 'imagePath': 'assets/images/montim_mobiliesh.jpg'},
    {'name': 'Patinime muresh', 'imagePath': 'assets/images/patinime_muresh.jpg'},
    {'name': 'Lyerje muresh', 'imagePath': 'assets/images/lyerje_muresh.jpg'},
    {'name': 'Punime ne kopesht', 'imagePath': 'assets/images/punime_ne_kopesht.jpg'},
    {'name': 'Montime Dyer/Dritare', 'imagePath': 'assets/images/montim_dyer_dritare.jpg'},
    {'name': 'Montim Kondicioneri', 'imagePath': 'assets/images/montim_kondicioneri.jpg'},
    {'name': 'Pastrim shtepie', 'imagePath': 'assets/images/pastrim_shtepie.jpg'},
    {'name': 'Pastrim zyre', 'imagePath': 'assets/images/pastrim_zyre.jpg'},
    {'name': 'Punime hidraulike', 'imagePath': 'assets/images/punime_hidraulike.jpg'},
    {'name': 'Punime elektrike', 'imagePath': 'assets/images/punime_elektrike.jpg'},
    {'name': 'Punime druri', 'imagePath': 'assets/images/punime_druri.jpg'},
    {'name': 'Vjelje ullinjsh', 'imagePath': 'assets/images/vjelje_ullinjsh.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPrecachedImages) {
      _precacheImages();
      _hasPrecachedImages = true;
    }
  }

  // Precache the images from assets
  Future<void> _precacheImages() async {
    for (var category in categories) {
      await precacheImage(AssetImage(category['imagePath']!), context);
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    await _precacheImages();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchTasker(BuildContext context, dynamic tasker) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Profesionisti me afër jush është ...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.tomatoRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SpinKitFadingCircle(
                  color: AppColors.tomatoRed,
                  size: 80.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.of(context).pop();

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskerProfileScreen(tasker: tasker),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskersProvider = Provider.of<TaskersProvider>(context, listen: false);
    var tasker = taskersProvider.taskers.first;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            color: AppColors.tomatoRedLight,
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Përshëndetje Genti !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Për çfarë ju nevojitet ndihmë sot...',
                  style: TextStyle(
                    color: Colors.white,
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
                        filteredSuggestions = categories
                            .where((category) => category['name']!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
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
                      itemCount: filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = filteredSuggestions[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.asset(
                              suggestion['imagePath']!,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            suggestion['name']!,
                            style: TextStyle(
                              color: AppColors.grey700,
                              fontSize: 16.sp,
                            ),
                          ),
                          onTap: () {
                            // Handle the suggestion tap
                            _fetchTasker(context, tasker);
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
                SizedBox(height: 16.h),
                _isLoading
                    ? _buildShimmerGrid()
                    : _buildCategoryGrid(tasker),
              ],
            ),
          ),
          SizedBox(height: 120.h),
        ],
      ),
    );
  }

  // Build the shimmer effect grid
  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey300,
          highlightColor: AppColors.grey100,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                height: 16.h,
                color: AppColors.grey300,
              ),
            ],
          ),
        );
      },
    );
  }

  // Build the actual category grid with images after loading
  Widget _buildCategoryGrid(dynamic tasker) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            _fetchTasker(context, tasker);
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    category['imagePath']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                category['name']!,
                style: TextStyle(
                  color: AppColors.grey700,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
