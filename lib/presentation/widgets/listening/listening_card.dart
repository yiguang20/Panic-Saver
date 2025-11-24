import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

/// Listening awareness card for grounding technique
/// Guides users to focus on surrounding sounds
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
    
    // Update timer every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _startTime != null) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime!);
          // Enable continue after 2 minutes
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

    return Stack(
      children: [
        // Main content
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            children: [
              // Top spacing for buttons
              const SizedBox(height: AppDimensions.spacingL * 2),
              
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
                ? '闭上眼睛，仔细聆听周围的声音。\n试着识别至少5种不同的声音。'
                : 'Close your eyes and listen carefully to the sounds around you.\nTry to identify at least 5 different sounds.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteWithOpacity(0.8),
                ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // Timer display
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.lilac.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: AppColors.lilac.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: AppColors.lilac,
                  size: 14,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Text(
                  _formatDuration(_elapsedTime),
                  style: TextStyle(
                    color: AppColors.lilac,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // Sound categories guide
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.whiteWithOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.whiteWithOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isChinese ? '你能听到什么？' : 'What can you hear?',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.lilac,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    isChinese 
                        ? '试着识别这些类型的声音：'
                        : 'Try to identify these types of sounds:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.whiteWithOpacity(0.6),
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildSoundCategory(
                          context,
                          Icons.record_voice_over,
                          isChinese ? '人声' : 'Voices',
                          AppColors.aqua,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        _buildSoundCategory(
                          context,
                          Icons.nature,
                          isChinese ? '自然声' : 'Nature',
                          AppColors.mintGreen,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        _buildSoundCategory(
                          context,
                          Icons.settings,
                          isChinese ? '机械声' : 'Mechanical',
                          AppColors.lilac,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        _buildSoundCategory(
                          context,
                          Icons.music_note,
                          isChinese ? '音乐' : 'Music',
                          AppColors.softBlue,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        _buildSoundCategory(
                          context,
                          Icons.air,
                          isChinese ? '环境声' : 'Ambient',
                          AppColors.deepPurple,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // Progress message or continue button
          if (!_canContinue)
            Text(
              isChinese 
                  ? '请继续聆听至少2分钟'
                  : 'Continue listening for at least 2 minutes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.whiteWithOpacity(0.5),
                  ),
              textAlign: TextAlign.center,
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Flexible(
                    child: Text(
                      isChinese 
                          ? '很好！你已经通过聆听让自己平静下来'
                          : 'Great! You\'ve grounded yourself through listening',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.onComplete != null) ...[
              const SizedBox(height: AppDimensions.spacingM),
              ElevatedButton(
                onPressed: widget.onComplete,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                    vertical: AppDimensions.spacingS,
                  ),
                ),
                child: Text(isChinese ? '继续' : 'Continue'),
              ),
            ],
          ],
              
              const SizedBox(height: AppDimensions.spacingS),
            ],
          ),
        ),
        
        // Breathing reminder - top left
        Positioned(
          top: AppDimensions.spacingS,
          left: AppDimensions.spacingS,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.aqua.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: AppColors.aqua.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.air,
                  color: AppColors.aqua,
                  size: 14,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Text(
                  isChinese ? '保持深呼吸' : 'Keep breathing deeply',
                  style: TextStyle(
                    color: AppColors.aqua,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Skip button - top right
        if (widget.onComplete != null)
          Positioned(
            top: AppDimensions.spacingS,
            right: AppDimensions.spacingS,
            child: InkWell(
              onTap: widget.onComplete,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.whiteWithOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.whiteWithOpacity(0.3),
                  ),
                ),
                child: Icon(
                  Icons.skip_next,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSoundCategory(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
