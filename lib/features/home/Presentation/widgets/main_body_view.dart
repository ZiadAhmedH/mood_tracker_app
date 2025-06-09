import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/image_emotion_detection/presentation/camera_emotion_view.dart';

class MainBodyView extends StatelessWidget {
  const MainBodyView({super.key});
  static const String routeName = '/main';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 48), 
                      SizedBox( 
                        child: SvgPicture.asset(
                          'assets/icons/mood_mate_logo.svg',
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 78), 
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9, 
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                               Navigator.pushNamed(
                                  context, 
                                  CameraEmotionView.routeName,
                                );
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/camera.svg',
                              ), 
                              label: CustomText(text:
                                "Take a Picture",
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), 
                                ),
                                minimumSize: const Size(double.infinity, 72),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => QuestionScreen()), // الانتقال إلى شاشة الأسئلة
                                // );
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/edit-2.svg',
                              ), // أيقونة الكامير // أيقونة القلم
                              label:  CustomText(text:
                                "Answer Questions",
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF1F1F1),
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), // الحواف متساوية
                                ),
                                minimumSize: const Size(double.infinity, 72),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => EmotionTextDetectionScreen()), // الانتقال إلى شاشة كتابة المشاعر
                                // );
                              },
                              icon:SvgPicture.asset(
                                'assets/icons/smallcaps.svg',
                              ), // أيقونة الكاميرص
                              label:  CustomText(text:
                                "Write What Do You Feel",
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF1F1F1),
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), // الحواف متساوية
                                ),
                                minimumSize: const Size(double.infinity, 72),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // زر النكست
            Container(
              width: double.infinity,
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 24), 
              child: ElevatedButton(
                onPressed: () {}, // يمكنك إضافة أي وظيفة هنا
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(double.infinity, 72), 
                ),
                child: CustomText(text: "Next", color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 15),
          ],
    );
  }
}


