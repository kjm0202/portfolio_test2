import 'package:flutter/material.dart';
import 'app_localizations.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isHoveringSubmit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!mounted) return const SizedBox.shrink();
        final theme = Theme.of(context);

        final isSmallScreen = constraints.maxWidth < 800;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 40,
            vertical: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(theme),
              const SizedBox(height: 48),
              isSmallScreen
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactForm(theme),
                      const SizedBox(height: 48),
                      _buildContactInfo(theme),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _buildContactForm(theme)),
                      const SizedBox(width: 48),
                      Expanded(flex: 4, child: _buildContactInfo(theme)),
                    ],
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    if (!mounted) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              localizations.getInTouch,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(localizations.contactTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          width: 600,
          child: Text(
            localizations.contactDescription,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(ThemeData theme) {
    if (!mounted) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.sendMessage, style: theme.textTheme.titleMedium),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _nameController,
            label: localizations.nameLabel,
            hint: localizations.nameHint,
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.pleaseEnterName;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _emailController,
            label: localizations.emailLabel,
            hint: localizations.emailHint,
            icon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.pleaseEnterEmail;
              } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ).hasMatch(value)) {
                return localizations.pleaseEnterValidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _messageController,
            label: localizations.messageLabel,
            hint: localizations.messageHint,
            icon: Icons.message_outlined,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.pleaseEnterMessage;
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          MouseRegion(
            onEnter: (_) {
              if (mounted) setState(() => _isHoveringSubmit = true);
            },
            onExit: (_) {
              if (mounted) setState(() => _isHoveringSubmit = false);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform:
                  _isHoveringSubmit
                      ? (Matrix4.identity()..scale(1.05))
                      : Matrix4.identity(),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form submission logic would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          localizations.messageSentSuccess,
                          style: TextStyle(color: theme.colorScheme.onPrimary),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    );
                    _nameController.clear();
                    _emailController.clear();
                    _messageController.clear();
                  }
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: theme.colorScheme.onPrimary,
                ),
                label: Text(
                  localizations.sendMessageButton,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  minimumSize: const Size(200, 54),
                ),
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
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      validator: validator,
    );
  }

  Widget _buildContactInfo(ThemeData theme) {
    if (!mounted) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context);
    final contactInfos = [
      {
        'icon': Icons.email_outlined,
        'title': localizations.email,
        'content': 'john.developer@example.com',
      },
      {
        'icon': Icons.phone_outlined,
        'title': localizations.phone,
        'content': '+1 234 567 890',
      },
      {
        'icon': Icons.location_on_outlined,
        'title': localizations.location,
        'content': 'San Francisco, CA',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.contactInformation,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        ...contactInfos.map((info) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    info['icon'] as IconData,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info['title'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        info['content'] as String,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 32),
        Text(localizations.socialProfiles, style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 12.0,
          children: [
            _buildSocialButton(
              Icons.facebook_outlined,
              localizations.facebook,
              theme,
            ),
            _buildSocialButton(
              Icons.beach_access,
              localizations.twitter,
              theme,
            ),
            _buildSocialButton(Icons.work, localizations.linkedin, theme),
            _buildSocialButton(Icons.code, localizations.github, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
