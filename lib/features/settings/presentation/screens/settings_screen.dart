import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_contacts.dart';
import '../../../../core/services/data_service.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/notification_provider.dart';
import '../../../../shared/providers/providers.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Debug mode - set to false for production
  static const bool isDebugEnabled = true;
  
  bool _notificationsEnabled = true;
  bool _quietHoursEnabled = true;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  int _reminderMinutesBefore = 15;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _quietHoursEnabled = prefs.getBool('quietHoursEnabled') ?? true;
      _reminderMinutesBefore = prefs.getInt('reminderMinutesBefore') ?? 15;
      
      final quietStartHour = prefs.getInt('quietHoursStartHour') ?? 22;
      final quietStartMinute = prefs.getInt('quietHoursStartMinute') ?? 0;
      _quietHoursStart = TimeOfDay(hour: quietStartHour, minute: quietStartMinute);
      
      final quietEndHour = prefs.getInt('quietHoursEndHour') ?? 7;
      final quietEndMinute = prefs.getInt('quietHoursEndMinute') ?? 0;
      _quietHoursEnd = TimeOfDay(hour: quietEndHour, minute: quietEndMinute);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('quietHoursEnabled', _quietHoursEnabled);
    await prefs.setInt('reminderMinutesBefore', _reminderMinutesBefore);
    await prefs.setInt('quietHoursStartHour', _quietHoursStart.hour);
    await prefs.setInt('quietHoursStartMinute', _quietHoursStart.minute);
    await prefs.setInt('quietHoursEndHour', _quietHoursEnd.hour);
    await prefs.setInt('quietHoursEndMinute', _quietHoursEnd.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          _buildLanguageSection(l10n),
          const SizedBox(height: AppConstants.paddingLarge),
          _buildNotificationsSection(l10n),
          const SizedBox(height: AppConstants.paddingLarge),
          _buildAppearanceSection(l10n),
          const SizedBox(height: AppConstants.paddingLarge),
          _buildDataSection(l10n),
          const SizedBox(height: AppConstants.paddingLarge),
          _buildAboutSection(l10n),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(AppLocalizations l10n) => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Consumer(
              builder: (context, ref, child) {
                final currentLanguage = ref.watch(currentLanguageProvider);
                final supportedLanguages = ref.watch(supportedLanguagesProvider);

                return SettingsTile(
                  title: l10n.selectLanguage,
                  subtitle: currentLanguage.nativeName,
                  trailing: DropdownButton<SupportedLanguage>(
                    value: currentLanguage,
                    items: supportedLanguages.map((language) => DropdownMenuItem<SupportedLanguage>(
                        value: language,
                        child: Text(language.nativeName),
                      )).toList(),
                    onChanged: (language) {
                      if (language != null) {
                        ref.read(localeProvider.notifier).setLocaleFromCode(language.code);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

  Widget _buildNotificationsSection(AppLocalizations l10n) => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notifications,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SettingsTile(
              title: l10n.enableNotifications,
              subtitle: l10n.receiveReminders,
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _saveSettings();
                },
              ),
            ),
            SettingsTile(
              title: l10n.reminderBefore,
              subtitle: l10n.minutesBeforeIntake(_reminderMinutesBefore),
              trailing: DropdownButton<int>(
                value: _reminderMinutesBefore,
                items: [
                  DropdownMenuItem(value: 5, child: Text(l10n.minutesShort(5))),
                  DropdownMenuItem(value: 10, child: Text(l10n.minutesShort(10))),
                  DropdownMenuItem(value: 15, child: Text(l10n.minutesShort(15))),
                  DropdownMenuItem(value: 30, child: Text(l10n.minutesShort(30))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _reminderMinutesBefore = value;
                    });
                    _saveSettings();
                  }
                },
              ),
            ),
            SettingsTile(
              title: l10n.quietHours,
              subtitle: l10n.doNotDisturbAtNight,
              trailing: Switch(
                value: _quietHoursEnabled,
                onChanged: (value) {
                  setState(() {
                    _quietHoursEnabled = value;
                  });
                  _saveSettings();
                },
              ),
            ),
            if (_quietHoursEnabled) ...[
              SettingsTile(
                title: l10n.quietHoursStart,
                subtitle: _formatTimeOfDay(_quietHoursStart),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _quietHoursStart,
                  );
                  if (time != null) {
                    setState(() {
                      _quietHoursStart = time;
                    });
                    _saveSettings();
                  }
                },
              ),
              SettingsTile(
                title: l10n.quietHoursEnd,
                subtitle: _formatTimeOfDay(_quietHoursEnd),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _quietHoursEnd,
                  );
                  if (time != null) {
                    setState(() {
                      _quietHoursEnd = time;
                    });
                    _saveSettings();
                  }
                },
              ),
            ],
            if (isDebugEnabled) ...[
              const Divider(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.notifications_active),
                label: Text('🧪 ${l10n.testNotification}'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  final notificationService = ref.read(notificationServiceProvider);
                  await notificationService.showImmediateNotification(
                    title: '🧪 ${l10n.test}',
                    body: l10n.notificationsWorkingCorrectly,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✅ ${l10n.testNotificationSent}')),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text('🔄 ${l10n.rescheduleAll}'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  final notificationService = ref.read(notificationServiceProvider);
                  await notificationService.rescheduleAllNotifications();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✅ ${l10n.notificationsRescheduled}')),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.list),
                label: Text('📋 ${l10n.showScheduled}'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  final notificationService = ref.read(notificationServiceProvider);
                  await notificationService.printAllPendingNotifications();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('📋 ${l10n.checkLogsInConsole}')),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );

  Widget _buildAppearanceSection(AppLocalizations l10n) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appearance,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SettingsTile(
              title: l10n.darkTheme,
              subtitle: l10n.useDarkTheme,
              trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(AppLocalizations l10n) => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.data,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SettingsTile(
              title: l10n.exportData,
              subtitle: l10n.saveDataToFile,
              trailing: const Icon(Icons.download),
              onTap: _exportData,
            ),
            SettingsTile(
              title: l10n.importData,
              subtitle: l10n.loadDataFromFile,
              trailing: const Icon(Icons.upload),
              onTap: _importData,
            ),
            SettingsTile(
              title: l10n.backup,
              subtitle: l10n.createBackup,
              trailing: const Icon(Icons.backup),
              onTap: _createBackup,
            ),
            SettingsTile(
              title: l10n.clearData,
              subtitle: l10n.deleteAllData,
              trailing: const Icon(Icons.delete_forever, color: AppConstants.errorColor),
              onTap: _clearData,
            ),
          ],
        ),
      ),
    );

  Widget _buildAboutSection(AppLocalizations l10n) => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutApp,
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SettingsTile(
              title: l10n.version,
              subtitle: AppConstants.appVersion,
            ),
            SettingsTile(
              title: l10n.privacyPolicy,
              subtitle: l10n.readPrivacyPolicy,
              trailing: const Icon(Icons.open_in_new),
              onTap: _showPrivacyPolicy,
            ),
            SettingsTile(
              title: l10n.termsOfService,
              subtitle: l10n.readTermsOfService,
              trailing: const Icon(Icons.open_in_new),
              onTap: _showTermsOfService,
            ),
            SettingsTile(
              title: l10n.feedback,
              subtitle: l10n.contactDevelopers,
              trailing: const Icon(Icons.email),
              onTap: _sendFeedback,
            ),
          ],
        ),
      ),
    );

  String _formatTimeOfDay(TimeOfDay time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _exportData() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final database = ref.read(appDatabaseProvider);
      final dataService = DataService(database);
      final file = await dataService.exportData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.dataExported}\n${file.path}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  Future<void> _importData() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.importData),
            content: Text(l10n.importDataWarning),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.import),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          final database = ref.read(appDatabaseProvider);
          final dataService = DataService(database);
          await dataService.importData(file);
          
          // Refresh all providers
          ref.invalidate(medicationsProvider);
          ref.invalidate(activeSchedulesProvider);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.dataImported)),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  Future<void> _createBackup() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final database = ref.read(appDatabaseProvider);
      final dataService = DataService(database);
      await dataService.shareData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  void _clearData() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearData),
        content: Text(l10n.clearDataConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement data clearing
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.dataCleared)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _showPrivacyPolicy() async {
    final uri = Uri.parse(AppContacts.privacyPolicyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cannotOpenUrl)),
        );
      }
    }
  }

  Future<void> _showTermsOfService() async {
    final uri = Uri.parse(AppContacts.termsOfServiceUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cannotOpenUrl)),
        );
      }
    }
  }

  Future<void> _sendFeedback() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Show options: Email or Telegram
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.contactUs),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(AppContacts.feedbackEmail),
              onTap: () => Navigator.pop(context, 'email'),
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Telegram'),
              subtitle: Text('@${AppContacts.telegramUsername}'),
              onTap: () => Navigator.pop(context, 'telegram'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );

    if (choice == 'email') {
      final emailUri = Uri(
        scheme: 'mailto',
        path: AppContacts.feedbackEmail,
        query: 'subject=PillBull Feedback&body=',
      );
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cannotOpenEmail)),
          );
        }
      }
    } else if (choice == 'telegram') {
      final telegramUri = Uri.parse(AppContacts.telegramUrl);
      if (await canLaunchUrl(telegramUri)) {
        await launchUrl(telegramUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cannotOpenTelegram)),
          );
        }
      }
    }
  }
}