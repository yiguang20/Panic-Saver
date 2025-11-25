import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/session_record.dart';

/// Bottom sheet for displaying session details for a specific date
class SessionDetailSheet extends StatelessWidget {
  final DateTime date;
  final List<SessionRecord> sessions;

  const SessionDetailSheet({
    super.key,
    required this.date,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: AppColors.navyDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          const Divider(color: AppColors.cardBorder, height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) => _buildSessionItem(
                context,
                sessions[index],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textMain.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.aqua.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: AppColors.aqua,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(context, date),
                style: const TextStyle(
                  color: AppColors.textMain,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _getSessionCountText(context),
                style: TextStyle(
                  color: AppColors.textMain.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final months = _getMonthNames(locale);
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  List<String> _getMonthNames(String locale) {
    switch (locale) {
      case 'zh':
        return ['一月', '二月', '三月', '四月', '五月', '六月',
                '七月', '八月', '九月', '十月', '十一月', '十二月'];
      default:
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    }
  }

  String _getSessionCountText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final count = sessions.length;
    switch (locale) {
      case 'zh':
        return '$count 次会话';
      case 'es':
        return '$count sesiones';
      case 'fr':
        return '$count sessions';
      case 'de':
        return '$count Sitzungen';
      default:
        return '$count session${count > 1 ? 's' : ''}';
    }
  }

  Widget _buildSessionItem(BuildContext context, SessionRecord session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lilac.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.self_improvement,
              color: AppColors.lilac,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.formattedTime,
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getDurationText(context, session),
                  style: TextStyle(
                    color: AppColors.textMain.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.aqua.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${session.stepsCompleted} ${_getStepsText(context)}',
                  style: const TextStyle(
                    color: AppColors.aqua,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDurationText(BuildContext context, SessionRecord session) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '时长: ${session.formattedDuration}';
      case 'es':
        return 'Duración: ${session.formattedDuration}';
      case 'fr':
        return 'Durée: ${session.formattedDuration}';
      case 'de':
        return 'Dauer: ${session.formattedDuration}';
      default:
        return 'Duration: ${session.formattedDuration}';
    }
  }

  String _getStepsText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '步';
      case 'es':
        return 'pasos';
      case 'fr':
        return 'étapes';
      case 'de':
        return 'Schritte';
      default:
        return 'steps';
    }
  }
}
