import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Calendar view widget for displaying monthly calendar with session markers
class CalendarView extends StatelessWidget {
  final DateTime currentMonth;
  final Set<DateTime> datesWithSessions;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarView({
    super.key,
    required this.currentMonth,
    required this.datesWithSessions,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMonthHeader(context),
          const SizedBox(height: 16),
          _buildWeekdayHeader(context),
          const SizedBox(height: 8),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textMain),
          onPressed: () {
            final newMonth = DateTime(
              currentMonth.year,
              currentMonth.month - 1,
            );
            onMonthChanged(newMonth);
          },
        ),
        Text(
          _getMonthYearText(context),
          style: const TextStyle(
            color: AppColors.textMain,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.textMain),
          onPressed: () {
            final newMonth = DateTime(
              currentMonth.year,
              currentMonth.month + 1,
            );
            onMonthChanged(newMonth);
          },
        ),
      ],
    );
  }


  String _getMonthYearText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final months = _getMonthNames(locale);
    return '${months[currentMonth.month - 1]} ${currentMonth.year}';
  }

  List<String> _getMonthNames(String locale) {
    switch (locale) {
      case 'zh':
        return ['一月', '二月', '三月', '四月', '五月', '六月',
                '七月', '八月', '九月', '十月', '十一月', '十二月'];
      case 'es':
        return ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
      case 'fr':
        return ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
                'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
      case 'de':
        return ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
                'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];
      default:
        return ['January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December'];
    }
  }

  Widget _buildWeekdayHeader(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final weekdays = _getWeekdayNames(locale);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) => SizedBox(
        width: 40,
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textMain.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  List<String> _getWeekdayNames(String locale) {
    switch (locale) {
      case 'zh':
        return ['日', '一', '二', '三', '四', '五', '六'];
      case 'es':
        return ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      case 'fr':
        return ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
      case 'de':
        return ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'];
      default:
        return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    }
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday
    final daysInMonth = lastDayOfMonth.day;
    
    final today = DateTime.now();
    final isCurrentMonth = today.year == currentMonth.year && 
                           today.month == currentMonth.month;

    List<Widget> dayWidgets = [];
    
    // Add empty cells for days before the first day of month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }
    
    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final hasSession = datesWithSessions.contains(date);
      final isToday = isCurrentMonth && today.day == day;
      
      dayWidgets.add(_buildDayCell(day, hasSession, isToday, date));
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(int day, bool hasSession, bool isToday, DateTime date) {
    return GestureDetector(
      onTap: hasSession ? () => onDateSelected(date) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isToday 
              ? AppColors.aqua.withValues(alpha: 0.3)
              : hasSession 
                  ? AppColors.lilac.withValues(alpha: 0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isToday 
              ? Border.all(color: AppColors.aqua, width: 2)
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: hasSession 
                    ? AppColors.textMain 
                    : AppColors.textMain.withValues(alpha: 0.6),
                fontSize: 14,
                fontWeight: hasSession ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (hasSession)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.aqua,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
