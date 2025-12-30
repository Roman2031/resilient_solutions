import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../courses/data/models/course.dart';

/// Widget for selecting a course from LearnDash
class CourseSelector extends StatelessWidget {
  final List<Course> courses;
  final Course? selectedCourse;
  final ValueChanged<Course?> onCourseSelected;
  final bool isLoading;

  const CourseSelector({
    super.key,
    required this.courses,
    this.selectedCourse,
    required this.onCourseSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (courses.isEmpty) {
      return Center(
        child: Text(
          'No courses available',
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Course',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xff023C7B),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white54),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Course>(
              value: selectedCourse,
              hint: Text(
                'Choose a course...',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              isExpanded: true,
              dropdownColor: const Color(0xff023C7B),
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: courses.map((course) {
                return DropdownMenuItem<Course>(
                  value: course,
                  child: Text(
                    course.title.rendered,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onCourseSelected,
            ),
          ),
        ),
        if (selectedCourse != null) ...[
          Gap(12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xff00519A),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCourse!.title.rendered,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (selectedCourse!.excerpt.rendered.isNotEmpty) ...[
                  Gap(8.h),
                  Text(
                    selectedCourse!.excerpt.rendered
                        .replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
