import 'package:flutter/material.dart';
import '../models/signup.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';

class MySignupsScreen extends StatefulWidget {
  const MySignupsScreen({super.key});

  @override
  State<MySignupsScreen> createState() => _MySignupsScreenState();
}

class _MySignupsScreenState extends State<MySignupsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Sign-ups')),
        body: Center(child: Text('Please log in to view your sign-ups.', style: TextStyle(color: theme.colorScheme.onSurface))),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Sign-ups',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: StreamBuilder<List<Signup>>(
            stream: _firestoreService.getUserSignups(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading sign-ups: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(theme, isDark);
              }

              final signups = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: signups.length,
                itemBuilder: (context, index) {
                  final signup = signups[index];
                  return _buildSignupCard(signup, theme, isDark);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.volunteer_activism,
            size: 60,
            color: isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No Sign-ups Yet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You haven\'t volunteered for any opportunities yet.',
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('Find Opportunities'),
        )
      ],
    );
  }

  Widget _buildSignupCard(Signup signup, ThemeData theme, bool isDark) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(signup.createdAt);

    return Card(
      elevation: theme.cardTheme.elevation,
      shadowColor: theme.cardTheme.shadowColor,
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.colorScheme.surface,
      shape: theme.cardTheme.shape,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? theme.colorScheme.primary.withOpacity(0.15) : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    signup.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Text(
                  'Signed up: $formattedDate',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.inverseSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              signup.opportunityTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.groups, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  signup.organizationName,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoBadge(Icons.calendar_today, signup.date, theme, isDark),
                const SizedBox(width: 16),
                _buildInfoBadge(Icons.location_on, signup.location, theme, isDark),
                const SizedBox(width: 16),
                _buildInfoBadge(Icons.access_time, signup.availability, theme, isDark),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, ThemeData theme, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
