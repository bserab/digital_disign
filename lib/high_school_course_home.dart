import 'package:flutter/material.dart';
import 'high_school_course_setting.dart';
import 'util.dart';
import 'course_maker.dart';

// 高校生キャンパスツアーの順番表示するページ（仮）
class HighSchoolCourseHome extends CourseMaker {
  const HighSchoolCourseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("高校生：学校見学"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "学校見学の詳細ページ",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // 丸いボタンを表示
                CircleButton(
                  icon: Icons.add, // アイコン
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HighSchoolCourseSetting(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
