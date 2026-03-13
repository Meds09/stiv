import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/auth/providers/bottom_nav_bar_provider.dart';
import 'package:stiv/features/diagnostic/domain/entities/ai_chat_context.dart';
import 'package:stiv/features/diagnostic/presentation/pages/ai_chat_page/chat_bubble.dart';
import 'package:stiv/features/diagnostic/presentation/providers/ai_chat_provider.dart';

/// Pantalla de chat con el asistente IA de diagnóstico.
///
/// Recibe un [AiChatContext] con el tipo de dispositivo y usuario,
/// que alimenta el system prompt antes de la primera pregunta.
class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key, required this.chatContext});

  final AiChatContext chatContext;

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    ref.read(aiChatProvider(widget.chatContext).notifier).sendMessage(text);
    _textCtrl.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiChatProvider(widget.chatContext));

    // scroll to bottom whenever messages update
    ref.listen(aiChatProvider(widget.chatContext), (_, _) => _scrollToBottom());

    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE4),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty && state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    itemCount: state.messages.length,
                    itemBuilder: (_, i) {
                      final msg = state.messages[i];
                      final isStreaming = msg.id == state.streamingMessageId;
                      return ChatBubble(
                        text: msg.text,
                        isUser: msg.isUser,
                        isStreaming: isStreaming,
                      );
                    },
                  ),
          ),

          // ── Error banner ───────────────────────────────────
          if (state.errorMessage != null)
            _ErrorBanner(message: state.errorMessage!),

          // ── Input bar ──────────────────────────────────────
          _InputBar(
            controller: _textCtrl,
            focusNode: _focusNode,
            isLoading: state.isLoading,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.aiGradient),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Asistente STIV IA',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Powered by Gemini',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(menuIndexProvider.notifier).state = 0;
                router.go('/home');
              },
              child: const Text(
                'Terminar',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// ── Error banner ──────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.danger.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 8,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: AppColors.danger,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: !isLoading,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: isLoading
                      ? 'La IA está respondiendo'
                      : 'Escribe tu pregunta',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.brLg,
                    borderSide: BorderSide(
                      color: Colors.black.withValues(alpha: 0.12),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.brLg,
                    borderSide: BorderSide(
                      color: Colors.black.withValues(alpha: 0.12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.brLg,
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.4,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.brLg,
                    borderSide: const BorderSide(color: AppColors.outline),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: AppDurations.fast,
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Material(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: onSend,
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
