import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import 'signup_screen.dart';
import '../widgets/progress_cue.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final isFullyBooked = opportunity.remainingSlots <= 0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: opportunity.imageUrl.isNotEmpty
                  ? Hero(
                      tag: 'opp_img_${opportunity.id}',
                      child: Image.asset(
                        opportunity.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(color: theme.colorScheme.surfaceContainer),
            ),
            iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          ),
          // Content
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProgressCue(currentStep: 2),
                      const SizedBox(height: 16),
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? theme.colorScheme.surface : theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: isDark ? theme.colorScheme.outline : Colors.transparent),
                        ),
                        child: Text(
                          opportunity.category,
                          style: TextStyle(
                            color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        opportunity.title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Organization
                      Text(
                        opportunity.organizationName,
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Metadata Grid
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.outline),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMetaStat('DATE', opportunity.date, theme),
                            _buildMetaStat('LOCATION', opportunity.location, theme),
                            _buildMetaStat(
                              'SPOTS',
                              isFullyBooked ? '0 LEFT' : '${opportunity.remainingSlots} LEFT',
                              theme,
                              isHighlight: !isFullyBooked,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // About
                      Text(
                        'About this opportunity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        opportunity.description.isNotEmpty ? opportunity.description : 'No description provided.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Responsibilities
                      Text(
                        "What you'll do",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        opportunity.responsibilities.isNotEmpty ? opportunity.responsibilities : 'General volunteering.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Requirements
                      Text(
                        "What you'll need",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        opportunity.requirements.isNotEmpty ? opportunity.requirements : 'None.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isFullyBooked
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignupScreen(opportunity: opportunity),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor: theme.colorScheme.surfaceContainer,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  isFullyBooked ? 'Fully Booked' : 'Sign up to volunteer',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaStat(String label, String value, ThemeData theme, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: theme.colorScheme.inverseSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isHighlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
