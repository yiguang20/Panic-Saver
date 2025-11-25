import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/repositories/session_repository.dart';

/// Widget for displaying session statistics
class SessionStatisticsCard extends StatelessWidget {
  final SessionStatistics statistics;

  const SessionStatisticsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    if (statistics.totalSessions == 0) {
      return _buildEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getTitle(context),
            style: const TextStyle(
              color: AppColors.textMain,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.self_improvement,
                  value: '${statistics.totalSessions}',
                  label: _getTotalSessionsLabel(context),
                  color: AppColors.aqua,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.timer,
                  value: statistics.formattedAverageDuration,
                  label: _getAvgDurationLabel(context),
                  color: AppColors.lilac,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.schedule,
                  value: statistics.formattedMostCommonTime,
                  label: _getMostCommonTimeLabel(context),
                  color: AppColors.mintGreen,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.local_fire_department,
                  value: '${statistics.longestStreak}',
                  label: _getStreakLabel(context),
                  color: AppColors.paleGold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMain.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.insights,
            color: AppColors.textMain.withValues(alpha: 0.3),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateText(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMain.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '统计数据';
      case 'es':
        return 'Estadísticas';
      case 'fr':
        return 'Statistiques';
      case 'de':
        return 'Statistiken';
      default:
        return 'Statistics';
    }
  }

  String _getTotalSessionsLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '总会话';
      case 'es':
        return 'Total';
      case 'fr':
        return 'Total';
      case 'de':
        return 'Gesamt';
      default:
        return 'Total Sessions';
    }
  }

  String _getAvgDurationLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '平均时长';
      case 'es':
        return 'Duración Prom.';
      case 'fr':
        return 'Durée Moy.';
      case 'de':
        return 'Durchschn. Dauer';
      default:
        return 'Avg Duration';
    }
  }

  String _getMostCommonTimeLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '常见时段';
      case 'es':
        return 'Hora Común';
      case 'fr':
        return 'Heure Commune';
      case 'de':
        return 'Häufigste Zeit';
      default:
        return 'Common Time';
    }
  }

  String _getStreakLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '最长连续';
      case 'es':
        return 'Racha Máx.';
      case 'fr':
        return 'Série Max.';
      case 'de':
        return 'Längste Serie';
      default:
        return 'Longest Streak';
    }
  }

  String _getEmptyStateText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '还没有记录\n完成一次会话后将显示统计数据';
      case 'es':
        return 'Sin registros aún\nLas estadísticas aparecerán después de completar una sesión';
      case 'fr':
        return 'Pas encore de données\nLes statistiques apparaîtront après une session';
      case 'de':
        return 'Noch keine Daten\nStatistiken erscheinen nach einer Sitzung';
      default:
        return 'No records yet\nStatistics will appear after completing a session';
    }
  }
}
