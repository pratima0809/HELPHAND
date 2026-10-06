import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../screens/opportunity_detail_screen.dart';

class FeaturedOpportunityCard extends StatelessWidget {
  final Opportunity opportunity;

  const FeaturedOpportunityCard({super.key, required this.opportunity});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Environment': return Icons.eco;
      case 'Education': return Icons.school;
      case 'Healthcare': return Icons.medical_services;
      case 'Animal Welfare': return Icons.pets;
      case 'Community': return Icons.groups;
      case 'Food':
      case 'Food & Hunger': return Icons.restaurant;
      case 'Elderly Care': return Icons.elderly;
      default: return Icons.volunteer_activism;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: theme.cardTheme.elevation,
      shadowColor: theme.cardTheme.shadowColor,
      margin: const EdgeInsets.only(bottom: 32),
      color: theme.colorScheme.surface,
      shape: theme.cardTheme.shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OpportunityDetailScreen(opportunity: opportunity),
            ),
          );
        },
        child: isDesktop ? _buildDesktopLayout(theme, isDark) : _buildMobileLayout(theme, isDark),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme, bool isDark) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: _buildImage(theme, isDark),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: _buildContent(theme, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 250, child: _buildImage(theme, isDark)),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildContent(theme, isDark),
        ),
      ],
    );
  }

  Widget _buildImage(ThemeData theme, bool isDark) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: theme.colorScheme.surfaceContainer,
          child: opportunity.imageUrl.isNotEmpty
              ? Image.asset(
                  opportunity.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.image, size: 50, color: theme.colorScheme.outlineVariant)),
                )
              : Center(child: Icon(Icons.image, size: 50, color: theme.colorScheme.outlineVariant)),
        ),
        Positioned(
          top: 24,
          left: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark 
                ? theme.colorScheme.surface.withOpacity(0.85)
                : theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(opportunity.category),
                  color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  opportunity.category,
                  style: TextStyle(
                    color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, bool isDark) {
    final isFullyBooked = opportunity.remainingSlots <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDark 
              ? theme.colorScheme.primary.withOpacity(0.15)
              : theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'FEATURED',
            style: TextStyle(
              color: isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
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
        Row(
          children: [
            Icon(Icons.groups, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              opportunity.organizationName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _buildMetaItem(Icons.calendar_today, opportunity.date, theme),
            _buildMetaItem(Icons.location_on, opportunity.location, theme),
          ],
        ),
        const SizedBox(height: 24),
        if (opportunity.description.isNotEmpty) ...[
          Text(
            opportunity.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.inverseSurface,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
        ],
        Divider(color: theme.colorScheme.outlineVariant, height: 1),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isFullyBooked
                    ? Colors.red.withOpacity(0.1)
                    : (isDark ? theme.colorScheme.primary.withOpacity(0.15) : theme.colorScheme.primaryContainer),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: isFullyBooked
                        ? Colors.red[300]
                        : (isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFullyBooked ? 'Fully Booked' : '${opportunity.remainingSlots} spots left',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isFullyBooked
                          ? Colors.red[300]
                          : (isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
