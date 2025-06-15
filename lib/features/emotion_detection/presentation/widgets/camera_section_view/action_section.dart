import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodtracker_app/core/utils/constants/logo_assets.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import '../../feeling_selection_screen.dart';

class ActionSection extends StatefulWidget {
  final bool isProcessing;
  final String? imagePath;
  final String? prediction;
  final String? error;
  final VoidCallback onPickImage;
  final VoidCallback onTakePicture;
  final VoidCallback onClearImage;

  const ActionSection({
    super.key,
    required this.isProcessing,
    required this.imagePath,
    required this.prediction,
    required this.error,
    required this.onPickImage,
    required this.onTakePicture,
    required this.onClearImage,
  });

  @override
  State<ActionSection> createState() => _ActionSectionState();
}

class _ActionSectionState extends State<ActionSection> {
  bool _isButtonLoading = false;

  void _onDonePressed(BuildContext context) async {
    if (widget.prediction == null) return;

    setState(() => _isButtonLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    if (mounted) {
      Navigator.pushNamed(
        context,
        FeelingView.routeName,
        arguments: {'userFeeling': widget.prediction},
      );
      setState(() => _isButtonLoading = false); // Reset if user returns
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = widget.isProcessing || _isButtonLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircleButton(
                icon: Icons.photo_library,
                onTap: isButtonDisabled ? null : widget.onPickImage,
                enabled: !isButtonDisabled,
              ),
              _buildCircleButton(
                icon: Icons.camera_alt,
                onTap: isButtonDisabled ? null : widget.onTakePicture,
                enabled: !isButtonDisabled,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.imagePath != null) _buildFileInfo(context),
          if (widget.error != null) _buildErrorBox(),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: isButtonDisabled ? null : () => _onDonePressed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonDisabled ? AppColors.gray : AppColors.primary,
              minimumSize: Size(double.infinity, MediaQuery.of(context).size.height * 0.07),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: isButtonDisabled
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const CustomText(
                    text: "Done",
                    color: AppColors.graylight,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    VoidCallback? onTap,
    required bool enabled,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? AppColors.primaryLight : AppColors.gray.withOpacity(0.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 36, color: enabled ? AppColors.primary : AppColors.gray),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildFileInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grayHeavyLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              text: widget.imagePath!.split('/').last,
              color: AppColors.gray,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(Assets.assetsIconsTrash, width: 20),
            onPressed: widget.isProcessing ? null : widget.onClearImage,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBox() => Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.error!,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          ],
        ),
      );
}

