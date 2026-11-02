import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../data/service/invitation.dart';

class InviteDialog extends StatefulWidget {
  const InviteDialog({super.key});

  @override
  State<InviteDialog> createState() => _InviteDialogState();

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const InviteDialog());
  }
}

class _InviteDialogState extends State<InviteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isSending = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "Please enter an email";
    if (!RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v))
      return "Enter a valid email";
    return null;
  }

  Future<void> _sendInvitation() async {
    if (!_formKey.currentState!.validate() || _isSending) return;

    setState(() {
      _isSending = true;
      _errorText = null;
    });

    final email = _emailController.text.trim();

    try {
      await InvitationService.instance.sendInvite(email);
      if (mounted) Navigator.of(context).pop();

      // Get.snackbar (not a context-bound SnackBar) so it still shows
      // cleanly after the dialog above has already been popped/disposed.
      Get.snackbar(
        "Invitation sent",
        "An invite has been sent to $email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
    } on ApiException catch (e) {
      setState(() {
        _isSending = false;
        _errorText = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Send Invitation"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isSending,
              decoration: const InputDecoration(
                hintText: "Enter email address",
                border: OutlineInputBorder(),
              ),
              validator: _validateEmail,
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _isSending ? null : _sendInvitation,
          child: _isSending
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text("Send"),
        ),
        TextButton(
          onPressed: _isSending ? null : () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}