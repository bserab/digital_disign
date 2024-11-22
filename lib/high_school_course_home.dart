import 'package:flutter/material.dart';
import 'course_maker.dart';

//高校生キャンパスツアーの順番表示するページ（仮）
class HighSchoolCourseHome extends CourseMaker {
  const HighSchoolCourseHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("高校生：学校見学"),
      ),
      body: const Center(
        child: Text("学校見学の詳細ページ"),
      ),
    );
  }
}