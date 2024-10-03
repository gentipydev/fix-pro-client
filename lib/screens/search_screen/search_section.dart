import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_pro_client/utils/constants.dart';
import 'package:fit_pro_client/providers/task_state_provider.dart';

class SearchSection extends ConsumerWidget { 
  final TextEditingController searchController;
  final bool isAddressSelected;
  final List<String> filteredAddresses;
  final Function(String) onSearch;
  final Function(String) onSelectLocation;
  final Future<void> Function(String) performSearch;
  final VoidCallback useCurrentLocation;
  final VoidCallback showAddressNotification;
  final Animation<Offset> slideAnimation;
  final String statusText;

  const SearchSection({
    super.key,
    required this.searchController,
    required this.isAddressSelected,
    required this.filteredAddresses,
    required this.onSearch,
    required this.onSelectLocation,
    required this.performSearch,
    required this.useCurrentLocation,
    required this.showAddressNotification,
    required this.slideAnimation,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskStateProvider);

    return SlideTransition(
      position: slideAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.tomatoRedLight, AppColors.tomatoRed],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text transition for status
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                statusText,
                key: const ValueKey<String>('request_status'),
                style: GoogleFonts.roboto(
                  color: AppColors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),

            // Location input container sliding up
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: taskState.isLocationSelected ? 0 : 1,
              child: taskState.isLocationSelected
                  ? const SizedBox()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: const LinearGradient(
                          colors: [AppColors.white, AppColors.grey100],
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
                      child: Column(
                        children: [
                          // Search Input Field
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.tomatoRed,
                                  size: 24.sp,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    cursorColor: AppColors.grey700,
                                    style: TextStyle(fontSize: 16.sp),
                                    decoration: InputDecoration(
                                      hintText: 'Kërkoni një vendodhje tjetër...',
                                      hintStyle: TextStyle(
                                        color: AppColors.grey300,
                                        fontSize: 16.sp,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      onSearch(value);
                                    },
                                    onSubmitted: (value) {
                                      onSearch(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Display filtered suggestions
                          if (filteredAddresses.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: SizedBox(
                                height: 200.h,
                                child: ListView.separated(
                                  itemCount: filteredAddresses.length,
                                  itemBuilder: (context, index) {
                                    final suggestion = filteredAddresses[index];
                                    return ListTile(
                                      title: Text(
                                        suggestion,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      onTap: () {
                                        onSelectLocation(suggestion);
                                      },
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: AppColors.grey100,
                                      thickness: 1.0,
                                      height: 1.0,
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 20.h),
            
            // Use current location button sliding up
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: taskState.isLocationSelected ? 0 : 1,
              child: taskState.isLocationSelected
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        if (isAddressSelected) {
                          performSearch(searchController.text);
                        } else {
                          useCurrentLocation();
                        }
                      },
                      child: Column(
                        children: [
                          Text(
                            'Përdor Vendodhjen Aktuale',
                            style: GoogleFonts.roboto(
                              color: AppColors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          SizedBox(
                            height: 45.h, 
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  bottom: -25.h, 
                                  child: Material(
                                    color: Colors.transparent,
                                    shape: const CircleBorder(),
                                    elevation: 6,
                                    child: Container(
                                      width: 70.w,
                                      height: 70.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.tomatoRed,
                                          width: 4.w,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.searchengin,
                                          color: AppColors.tomatoRed,
                                          size: 35.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
