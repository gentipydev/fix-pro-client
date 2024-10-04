import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsSection extends StatefulWidget {
  final TextEditingController detailsController;
  final String? initialDetails;

  const DetailsSection({
    super.key,
    required this.detailsController,
    this.initialDetails,
  });

  @override
  DetailsSectionState createState() => DetailsSectionState();
}

class DetailsSectionState extends State<DetailsSection> {
  final List<String> suggestions = [
    'Nuk ka vend parkimi pranë shtëpisë',
    'Muret kanë nevojë për riparime të vogla përpara',
    'Gjitha mobiliet duhet të zhvendosen ose mbulohen',
    'Duhen dy shtresa boje për mbulim të plotë',
    'Do preferoja që punëtorët të sjellin bojën me vete',
    'Lyerje vetëm e një dhome',
    'Lyerje për të gjithë shtëpinë',
  ];

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Load the initial details into the controller if they exist
    if (widget.initialDetails != null && widget.initialDetails!.isNotEmpty) {
      widget.detailsController.text = widget.initialDetails!;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
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
              'Përshkrimi i Punës',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Detajet shtesë ndihmojnë profesionistin të përgatitet për punën',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey500,
              ),
            ),
            SizedBox(height: 20.h),

            // Text input field
            TextField(
              controller: widget.detailsController,
              focusNode: _focusNode,
              maxLines: 6,
              cursorColor: AppColors.grey700,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.grey700,
              ),
              decoration: InputDecoration(
                hintText:
                    'Për shembull, çfarë pune duhet të kryhet konkretisht, çfarë mjetesh janë të nevojshme, ku mund të parkojë, apo detaje të tjera...',
                hintStyle: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: AppColors.grey200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.tomatoRed, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // ExpansionTile for suggestions
            ExpansionTile(
              iconColor: AppColors.tomatoRed,
              trailing: Icon(
                Icons.expand_more,
                size: 36.sp
              ),
              title: Text(
                'Shiko sugjerimet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.grey700,
                ),
              ),
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide.none,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide.none,
              ),
              children: [
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: suggestions.map((suggestion) {
                    return ChoiceChip(
                      label: Text(
                        suggestion,
                        style: TextStyle(
                          color: AppColors.grey700,
                          fontSize: 14.sp,
                        ),
                      ),
                      labelPadding: EdgeInsets.zero,
                      backgroundColor: AppColors.grey200,
                      selectedColor: AppColors.tomatoRed.withOpacity(0.2),
                      selected: widget.detailsController.text.contains(suggestion),
                      shape: const BeveledRectangleBorder(
                        side: BorderSide(
                          color: AppColors.grey200,
                          width: 0.6,
                        ),
                      ),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            widget.detailsController.text +=
                                (widget.detailsController.text.isEmpty ? '' : '\n') +
                                    suggestion;
                          } else {
                            widget.detailsController.text = widget.detailsController.text
                                .replaceAll(suggestion, '')
                                .trim();
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
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
      ),
    );
  }
}
