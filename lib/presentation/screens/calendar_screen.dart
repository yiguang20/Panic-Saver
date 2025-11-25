import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../data/repositories/session_repository.dart';
import '../widgets/calendar/calendar_view.dart';
import '../widgets/calendar/session_statistics.dart';

/// Calendar screen for viewing session history
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();
  // Demo data - in production this would come from database
  final Set<DateTime> _datesWithSessions = {};
  late SessionStatistics _statistics;

  @override
  void initState() {
    super.initState();
    _statistics = SessionStatistics.empty();
    // Add some demo dates for visualization
    _addDemoData();
  }

  void _addDemoData() {
    // Add a few demo dates to show the calendar works
    final now = DateTime.now();
    _datesWithSessions.add(DateTime(now.year, now.month, now.day - 2));
    _datesWithSessions.add(DateTime(now.year, now.month, now.day - 5));
    _datesWithSessions.add(DateTime(now.year, now.month, now.day - 7));
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() => _currentMonth = newMonth);
  }

  void _onDateSelected(DateTime date) {
    // Show a simple message for now
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getDateSelectedText(context, date)),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.cardBackground,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CalendarView(
                        currentMonth: _currentMonth,
                        datesWithSessions: _datesWithSessions,
                        onMonthChanged: _onMonthChanged,
                        onDateSelected: _onDateSelected,
                      ),
                      const SizedBox(height: 24),
                      SessionStatisticsCard(statistics: _statistics),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Text(
            _getLocalizedTitle(context),
            style: const TextStyle(
              color: AppColors.textMain,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'zh':
        return '使用记录';
      case 'es':
        return 'Historial';
      case 'fr':
        return 'Historique';
      case 'de':
        return 'Verlauf';
      default:
        return 'History';
    }
  }

  String _getDateSelectedText(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = '${date.month}/${date.day}';
    switch (locale) {
      case 'zh':
        return '选择了 $dateStr';
      default:
        return 'Selected $dateStr';
    }
  }
}
