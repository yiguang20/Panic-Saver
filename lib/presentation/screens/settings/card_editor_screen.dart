import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/crisis_card.dart';

/// Screen for editing a crisis card
class CardEditorScreen extends StatefulWidget {
  final CrisisCard card;

  const CardEditorScreen({super.key, required this.card});

  @override
  State<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends State<CardEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _mainTextController;
  late TextEditingController _subTextController;
  late TextEditingController _buttonTextController;
  
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.card.title);
    _mainTextController = TextEditingController(text: widget.card.mainText);
    _subTextController = TextEditingController(text: widget.card.subText);
    _buttonTextController = TextEditingController(text: widget.card.buttonText);
    
    _titleController.addListener(_onTextChanged);
    _mainTextController.addListener(_onTextChanged);
    _subTextController.addListener(_onTextChanged);
    _buttonTextController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainTextController.dispose();
    _subTextController.dispose();
    _buttonTextController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  void _saveCard() {
    if (!_formKey.currentState!.validate()) return;
    
    HapticUtils.light();
    
    final updatedCard = widget.card.copyWith(
      title: _titleController.text.trim(),
      mainText: _mainTextController.text.trim(),
      subText: _subTextController.text.trim(),
      buttonText: _buttonTextController.text.trim(),
    );
    
    Navigator.pop(context, updatedCard);
  }


  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.navyDark,
        title: Text(
          _getUnsavedTitle(context),
          style: const TextStyle(color: AppColors.textMain),
        ),
        content: Text(
          _getUnsavedMessage(context),
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
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              _getDiscardText(context),
              style: const TextStyle(color: AppColors.aqua),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.navyDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(_getEditTitle(context)),
          actions: [
            if (_hasChanges)
              TextButton(
                onPressed: _saveCard,
                child: Text(
                  _getSaveText(context),
                  style: const TextStyle(color: AppColors.aqua),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            children: [
              _buildPreviewCard(),
              const SizedBox(height: AppDimensions.spacingXl),
              _buildTextField(
                controller: _titleController,
                label: _getTitleLabel(context),
                maxLines: 1,
                validator: (v) => v?.trim().isEmpty == true
                    ? _getRequiredError(context)
                    : null,
              ),
              const SizedBox(height: AppDimensions.spacingL),
              _buildTextField(
                controller: _mainTextController,
                label: _getMainTextLabel(context),
                maxLines: 4,
                validator: (v) => v?.trim().isEmpty == true
                    ? _getRequiredError(context)
                    : null,
              ),
              const SizedBox(height: AppDimensions.spacingL),
              _buildTextField(
                controller: _subTextController,
                label: _getSubTextLabel(context),
                maxLines: 2,
              ),
              const SizedBox(height: AppDimensions.spacingL),
              _buildTextField(
                controller: _buttonTextController,
                label: _getButtonTextLabel(context),
                maxLines: 1,
                validator: (v) => v?.trim().isEmpty == true
                    ? _getRequiredError(context)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getPreviewLabel(context),
            style: TextStyle(
              color: AppColors.textMain.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            _titleController.text.isEmpty ? '...' : _titleController.text,
            style: const TextStyle(
              color: AppColors.textMain,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            _mainTextController.text.isEmpty ? '...' : _mainTextController.text,
            style: TextStyle(
              color: AppColors.textMain.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
          if (_subTextController.text.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              _subTextController.text,
              style: TextStyle(
                color: AppColors.textMain.withValues(alpha: 0.6),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spacingL),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingL,
              vertical: AppDimensions.spacingM,
            ),
            decoration: BoxDecoration(
              color: AppColors.aqua.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Text(
              _buttonTextController.text.isEmpty
                  ? '...'
                  : _buttonTextController.text,
              style: const TextStyle(
                color: AppColors.aqua,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.textMain),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textMain.withValues(alpha: 0.6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: AppColors.cardBorder.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.aqua),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.warning),
        ),
        filled: true,
        fillColor: AppColors.cardBackground.withValues(alpha: 0.3),
      ),
    );
  }


  // Localization helpers
  String _getEditTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '编辑卡片' : 'Edit Card';
  }

  String _getSaveText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '保存' : 'Save';
  }

  String _getPreviewLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '预览' : 'Preview';
  }

  String _getTitleLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '标题' : 'Title';
  }

  String _getMainTextLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '主要内容' : 'Main Text';
  }

  String _getSubTextLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '副标题（可选）' : 'Subtitle (optional)';
  }

  String _getButtonTextLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '按钮文字' : 'Button Text';
  }

  String _getRequiredError(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '此字段为必填' : 'This field is required';
  }

  String _getUnsavedTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '未保存的更改' : 'Unsaved Changes';
  }

  String _getUnsavedMessage(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh'
        ? '您有未保存的更改。确定要放弃吗？'
        : 'You have unsaved changes. Discard them?';
  }

  String _getCancelText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '取消' : 'Cancel';
  }

  String _getDiscardText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh' ? '放弃' : 'Discard';
  }
}
