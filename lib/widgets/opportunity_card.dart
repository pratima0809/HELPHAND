import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../screens/opportunity_detail_screen.dart';

class OpportunityCard extends StatefulWidget {
  final Opportunity opportunity;

  const OpportunityCard({super.key, required this.opportunity});

  @override
  State<OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<OpportunityCard> {
  bool _isBookmarked = false;

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Environment':
        return Icons.eco;
      case 'Education':
        return Icons.school;
      case 'Healthcare':
        return Icons.medical_services;
      case 'Animal Welfare':
        return Icons.pets;
      case 'Community':
        return Icons.groups;
      case 'Food & Hunger':
        return Icons.restaurant;
      case 'Elderly Care':
        return Icons.elderly;
      default:
        return Icons.volunteer_activism;
    }
  }

  List<Map<String, dynamic>> _getImpactHighlights(String category) {
    if (category == 'Environment') {
      return [
        {
          'icon': Icons.eco,
          'title': 'Environment',
          'subtitle': 'Reduce waste'
        },
        {
          'icon': Icons.water,
          'title': 'Protect Life',
          'subtitle': 'Keep oceans healthy'
        },
        {
          'icon': Icons.groups,
          'title': 'Build Community',
          'subtitle': 'Work together'
        },
        {
          'icon': Icons.public,
          'title': 'Greener Future',
          'subtitle': 'For generations'
        },
      ];
    } else if (category == 'Education') {
      return [
        {
          'icon': Icons.computer,
          'title': 'Learn',
          'subtitle': 'New skills'
        },
        {
          'icon': Icons.groups,
          'title': 'Support',
          'subtitle': 'Underprivileged kids'
        },
        {
          'icon': Icons.favorite,
          'title': 'Create Impact',
          'subtitle': 'Build a future'
        },
      ];
    } else {
      return [
        {
          'icon': Icons.volunteer_activism,
          'title': 'Make Impact',
          'subtitle': 'Help others'
        },
        {
          'icon': Icons.groups,
          'title': 'Community',
          'subtitle': 'Work together'
        },
        {
          'icon': Icons.favorite,
          'title': 'Support',
          'subtitle': 'Those in need'
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final opportunity = widget.opportunity;
    final isFullyBooked = opportunity.remainingSlots <= 0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: theme.cardTheme.elevation,
      shadowColor: theme.cardTheme.shadowColor,
      margin: const EdgeInsets.only(bottom: 24),
      color: theme.colorScheme.surface,
      shape: theme.cardTheme.shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OpportunityDetailScreen(opportunity: opportunity),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Hero(
                  tag: 'opp_img_${opportunity.id}',
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: theme.colorScheme.surfaceContainer,
                    child: opportunity.imageUrl.isNotEmpty
                        ? Image.asset(
                            opportunity.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                    child: Icon(Icons.image,
                                        size: 50, color: theme.colorScheme.outlineVariant)),
                          )
                        : Center(
                            child: Icon(Icons.image,
                                size: 50, color: theme.colorScheme.outlineVariant)),
                  ),
                ),
                // Category Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
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
                // Bookmark Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.transparent : Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: _isBookmarked ? theme.colorScheme.primary : (isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant),
                        size: 26,
                      ),
                      onPressed: () {
                        setState(() {
                          _isBookmarked = !_isBookmarked;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isBookmarked ? 'Opportunity saved!' : 'Opportunity removed from saved.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Wrap content tightly
                children: [
                  // Title and Slots Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          opportunity.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
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
                              size: 14,
                              color: isFullyBooked
                                  ? Colors.red[300]
                                  : (isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isFullyBooked
                                  ? 'Fully Booked'
                                  : '${opportunity.remainingSlots} slots left',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isFullyBooked
                                    ? Colors.red[300]
                                    : (isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimaryContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Organization
                  Row(
                    children: [
                      Icon(Icons.groups,
                          size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        opportunity.organizationName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Metadata and View Details
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildMetaItem(
                          Icons.calendar_today, opportunity.date, theme),
                      _buildMetaItem(Icons.location_on, opportunity.location, theme),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: theme.colorScheme.onPrimary,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  if (opportunity.description.isNotEmpty) ...[
                    Text(
                      opportunity.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.inverseSurface,
                        height: 1.5,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Divider
                  Divider(color: theme.colorScheme.outlineVariant, height: 1),
                  const SizedBox(height: 16),
                  // Impact Highlights
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _getImpactHighlights(opportunity.category)
                          .map((highlight) => Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: _buildImpactItem(highlight, theme, isDark),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactItem(Map<String, dynamic> highlight, ThemeData theme, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.outline : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            highlight['icon'] as IconData,
            size: 18,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              highlight['title'] as String,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              highlight['subtitle'] as String,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
