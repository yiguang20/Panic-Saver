import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

/// Listening awareness card for grounding technique
class ListeningCard extends StatefulWidget {
  final VoidCallback? onComplete;

  const ListeningCard({
    super.key,
    this.onComplete,
  });

  @override
  State<ListeningCard> createState() => _ListeningCardState();
}

class _ListeningCardState extends State<ListeningCard> {
  DateTime? _startTime;
  Duration _elapsedTime = Duration.zero;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _startTime != null) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime!);
          if (_elapsedTime.inSeconds >= 120 && !_canContinue) {
            _canContinue = true;
          }
        });
        return true;
      }
      return false;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final isChinese = locale == 'zh';

    // No top buttons here - they are in the parent _buildSpecialCard
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            isChinese ? '聆听觉察' : 'Listening Awareness',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingS),

          // Instructions
          Text(
            isChinese
                ? '闭上眼睛，仔细聆听周围的声音'
                : 'Close your eyes and listen to the sounds around you',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteWithOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Timer display
          Text(
            _formatDuration(_elapsedTime),
            style: TextStyle(
              color: AppColors.lilac,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Sound categories
          _buildSoundCategories(context, isChinese),

          const SizedBox(height: AppDimensions.spacingL),

          // Progress message or continue button
          if (!_canContinue)
            Text(
              isChinese ? '请继续聆听至少2分钟' : 'Continue listening for at least 2 minutes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.whiteWithOpacity(0.5),
                  ),
              textAlign: TextAlign.center,
            )
          else ...[
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              isChinese ? '很好！你已经平静下来' : 'Great! You\'ve grounded yourself',
              style: TextStyle(
                color: AppColors.success,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.onComplete != null) ...[
              const SizedBox(height: AppDimensions.spacingL),
              ElevatedButton(
                onPressed: widget.onComplete,
                child: Text(isChinese ? '继续' : 'Continue'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSoundCategories(BuildContext context, bool isChinese) {
    final categories = [
      (Icons.record_voice_over, isChinese ? '人声' : 'Voices', AppColors.aqua),
      (Icons.nature, isChinese ? '自然声' : 'Nature', AppColors.mintGreen),
      (Icons.settings, isChinese ? '机械声' : 'Mechanical', AppColors.lilac),
      (Icons.music_note, isChinese ? '音乐' : 'Music', AppColors.softBlue),
      (Icons.air, isChinese ? '环境声' : 'Ambient', AppColors.deepPurple),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isChinese ? '试着识别这些声音：' : 'Try to identify these sounds:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.whiteWithOpacity(0.6),
              ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        ...categories.map((cat) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: Row(
                children: [
                  Icon(cat.$1, color: cat.$3, size: 20),
                  const SizedBox(width: AppDimensions.spacingM),
                  Text(cat.$2, style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            )),
      ],
    );
  }
}
