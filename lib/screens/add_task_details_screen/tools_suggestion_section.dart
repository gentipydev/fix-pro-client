import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fit_pro_client/models/task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToolSuggestion {
  final String title;
  final String imagePath;

  ToolSuggestion({required this.title, required this.imagePath});
}

final List<ToolSuggestion> fakeTools = [
  ToolSuggestion(title: 'Furçe Lyerje', imagePath: 'assets/images/furce_lyerje.png'),
  ToolSuggestion(title: 'Sharre Elektrike', imagePath: 'assets/images/sharre_elektrike.png'),
  ToolSuggestion(title: 'Thika', imagePath: 'assets/images/thika.png'),
  ToolSuggestion(title: 'Trapan', imagePath: 'assets/images/trapan.png'),
];

class ToolSuggestionSection extends StatefulWidget {
  final Task task;

  const ToolSuggestionSection({
    super.key,
    required this.task,
  });

  @override
  State<ToolSuggestionSection> createState() => _ToolSuggestionSectionState();
}

class _ToolSuggestionSectionState extends State<ToolSuggestionSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text(
            'Profesionisti do të sjell veglat e veta',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey700,
            ),
          ),
          trailing: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: widget.task.bringOwnTools,
              onChanged: (bool? value) {
                setState(() {
                  widget.task.bringOwnTools = value ?? true;
                });
              },
              activeColor: AppColors.tomatoRed,
              checkColor: AppColors.white,
              side: const BorderSide(
                color: AppColors.grey700,
                width: 2.0,
              ),
            ),
          ),
        ),

        if (!widget.task.bringOwnTools)
          ExpansionTile(
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
            tilePadding: EdgeInsets.zero,
            iconColor: AppColors.tomatoRed,
            trailing: Icon(
              Icons.expand_more,
              size: 36.sp
            ),
            children: [
              if (widget.task.taskTools != null && widget.task.taskTools!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.task.taskTools!.map((tool) {
                      return Chip(
                        label: Text(
                          tool,
                          style: const TextStyle(
                            color: AppColors.grey700,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: AppColors.tomatoRedLighter,
                        deleteIcon: const Icon(Icons.close, size: 20),
                        onDeleted: () {
                          setState(() {
                            widget.task.taskTools!.remove(tool);
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: BorderSide.none,
                        ),
                      );
                    }).toList(),
                  ),
                ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fakeTools.length,
                itemBuilder: (context, index) {
                  final tool = fakeTools[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: Image.asset(
                        tool.imagePath,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      tool.title,
                      style: TextStyle(
                        color: AppColors.grey700,
                        fontSize: 16.sp,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        widget.task.taskTools ??= [];
                        if (!widget.task.taskTools!.contains(tool.title)) {
                          widget.task.taskTools!.add(tool.title);
                        }
                      });
                    },
                  );
                },
              ),
            ],
          ),
      ],
    );
  }
}
