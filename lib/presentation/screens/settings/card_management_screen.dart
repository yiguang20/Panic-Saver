import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/crisis_card.dart';
import '../../../data/models/crisis_step.dart';
import '../../../data/repositories/content_repository.dart';
import 'card_editor_screen.dart';

/// Screen for managing crisis cards
class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({super.key});

  @override
  State<CardManagementScreen> createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen> {
  final ContentRepository _contentRepository = ContentRepository();
  List<CrisisCard> _cards = [];
  bool _isLoading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadCards();
    }
  }

  void _loadCards() {
    // Load cards from ContentRepository (no async database needed)
    final steps = _contentRepository.getCrisisSteps(context);
    final cards = steps.map((s) => CrisisCard.fromStep(s)).toList();
    
    setState(() {
      _cards = cards;
      _isLoading = false;
    });
  }

  Future<void> _toggleCardEnabled(CrisisCard card) async {
    await HapticUtils.light();
    final index = _cards.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      setState(() {
        _cards[index] = card.copyWith(isEnabled: !card.isEnabled);
      });
    }
  }

  Future<void> _editCard(CrisisCard card) async {
    await HapticUtils.light();
    final result = await Navigator.push<CrisisCard>(
      context,
      MaterialPageRoute(
        builder: (context) => CardEditorScreen(card: card),
      ),
    );
    if (result != null) {
      final index = _cards.indexWhere((c) => c.id == card.id);
      if (index != -1) {
        setState(() {
          _cards[index] = result;
        });
      }
    }
  }


  void _resetToDefaults() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.navyDark,
        title: Text(
          _getResetTitle(context),
          style: const TextStyle(color: AppColors.textMain),
        ),
        content: Text(
          _getResetMessage(context),
          style: TextStyle(color: AppColors.textMain.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              _getCancelText(context),
              style: const TextStyle(color: AppColors.textMain),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
              _loadCards(); // Reload defaults
            },
            child: Text(
              _getConfirmText(context),
              style: const TextStyle(color: AppColors.aqua),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_getTitle(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
            tooltip: _getResetTitle(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.aqua),
            )
          : _cards.isEmpty
              ? Center(
                  child: Text(
                    _getEmptyText(context),
                    style: TextStyle(
                      color: AppColors.textMain.withValues(alpha: 0.6),
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  itemCount: _cards.length,
                  onReorder: _onReorder,
                  itemBuilder: (context, index) => _buildCardItem(
                    _cards[index],
                    key: ValueKey(_cards[index].id),
                  ),
                ),
    );
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    await HapticUtils.medium();
    if (newIndex > oldIndex) newIndex--;
    
    setState(() {
      final card = _cards.removeAt(oldIndex);
      _cards.insert(newIndex, card);
    });
  }

  Widget _buildCardItem(CrisisCard card, {Key? key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: card.isEnabled
            ? AppColors.cardBackground.withValues(alpha: 0.5)
            : AppColors.cardBackground.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: card.isEnabled
              ? AppColors.cardBorder.withValues(alpha: 0.3)
              : AppColors.cardBorder.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingS,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTypeColor(card.type).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Icon(
            _getTypeIcon(card.type),
            color: _getTypeColor(card.type),
            size: 24,
          ),
        ),
        title: Text(
          card.title,
          style: TextStyle(
            color: card.isEnabled
                ? AppColors.textMain
                : AppColors.textMain.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _getTypeLabel(context, card.type),
          style: TextStyle(
            color: AppColors.textMain.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: card.isEnabled,
              onChanged: (_) => _toggleCardEnabled(card),
              activeTrackColor: AppColors.aqua.withValues(alpha: 0.5),
              activeColor: AppColors.aqua,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.textMain),
              onPressed: () => _editCard(card),
            ),
            const Icon(Icons.drag_handle, color: AppColors.textMain),
          ],
        ),
      ),
    );
  }


  Color _getTypeColor(CrisisStepType type) {
    switch (type) {
      case CrisisStepType.breathing:
        return AppColors.aqua;
      case CrisisStepType.unwinding:
        return AppColors.lilac;
      case CrisisStepType.listening:
        return AppColors.mintGreen;
      case CrisisStepType.affirmation:
        return AppColors.paleGold;
      default:
        return AppColors.softBlue;
    }
  }

  IconData _getTypeIcon(CrisisStepType type) {
    switch (type) {
      case CrisisStepType.breathing:
        return Icons.air;
      case CrisisStepType.unwinding:
        return Icons.autorenew;
      case CrisisStepType.listening:
        return Icons.hearing;
      case CrisisStepType.affirmation:
        return Icons.favorite;
      default:
        return Icons.article;
    }
  }

  String _getTypeLabel(BuildContext context, CrisisStepType type) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (type) {
      case CrisisStepType.breathing:
        return locale == 'zh' ? '呼吸练习' : 'Breathing';
      case CrisisStepType.unwinding:
        return locale == 'zh' ? '解旋动画' : 'Unwinding';
      case CrisisStepType.listening:
        return locale == 'zh' ? '聆听觉察' : 'Listening';
      case CrisisStepType.affirmation:
        return locale == 'zh' ? '自我肯定' : 'Affirmation';
      default:
        return locale == 'zh' ? '标准卡片' : 'Standard';
    }
  }

  String _getTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '卡片管理' : 'Card Management';
  }

  String _getEmptyText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '没有卡片' : 'No cards';
  }

  String _getResetTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '重置为默认' : 'Reset to Defaults';
  }

  String _getResetMessage(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh'
        ? '这将删除所有自定义更改并恢复默认卡片。确定继续吗？'
        : 'This will remove all customizations and restore default cards. Continue?';
  }

  String _getCancelText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '取消' : 'Cancel';
  }

  String _getConfirmText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '确定' : 'Confirm';
  }
}
