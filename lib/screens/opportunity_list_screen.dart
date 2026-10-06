import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/opportunity_card.dart';
import '../widgets/featured_opportunity_card.dart';
import '../widgets/category_filter.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'my_signups_screen.dart';

class OpportunityListScreen extends StatefulWidget {
  const OpportunityListScreen({super.key});

  @override
  State<OpportunityListScreen> createState() => _OpportunityListScreenState();
}

class _OpportunityListScreenState extends State<OpportunityListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _selectedIndex = 0;

  final List<String> _categories = [
    'All',
    'Education',
    'Environment',
    'Healthcare',
    'Animal Welfare',
    'Community',
    'Food & Hunger',
    'Elderly Care',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MySignupsScreen(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _toggleTheme() {
    if (AppTheme.themeNotifier.value == ThemeMode.light) {
      AppTheme.themeNotifier.value = ThemeMode.dark;
    } else {
      AppTheme.themeNotifier.value = ThemeMode.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.volunteer_activism, size: 28, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'HelpHand',
              style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              AppTheme.themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: theme.colorScheme.onSurface,
            ),
            tooltip: 'Toggle Theme',
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: theme.colorScheme.onSurface),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: CustomScrollView(
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
                  child: isDesktop ? _buildDesktopHero(theme) : _buildMobileHero(theme),
                ),
              ),
              
              // Find your way to help
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find your way to help',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose a cause that matters to you.',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search for opportunities, skills, or organizations...',
                      hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: theme.colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                      ),
                    ),
                  ),
                ),
              ),

              // Categories Filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 8),
                  child: CategoryFilter(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
                ),
              ),

              // Opportunities Stream
              StreamBuilder<List<Opportunity>>(
                stream: _firestoreService.getOpportunities(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(color: theme.colorScheme.primary),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error loading opportunities: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text('No opportunities available right now.', style: TextStyle(color: theme.colorScheme.onSurface)),
                        ),
                      ),
                    );
                  }

                  final opportunities = snapshot.data!;
                  
                  // Featured Opportunity (first one)
                  final featuredOpportunity = opportunities.first;
                  final remainingOpportunities = opportunities.length > 1 
                      ? opportunities.sublist(1) 
                      : <Opportunity>[];
                  
                  // Filtering logic
                  List<Opportunity> filteredOpportunities = remainingOpportunities;

                  if (_selectedCategory != 'All') {
                    filteredOpportunities = opportunities
                        .where((opp) => opp.category == _selectedCategory)
                        .toList();
                  }

                  if (_searchQuery.isNotEmpty) {
                    filteredOpportunities = filteredOpportunities.where((opp) {
                      return opp.title.toLowerCase().contains(_searchQuery) ||
                             opp.description.toLowerCase().contains(_searchQuery) ||
                             opp.organizationName.toLowerCase().contains(_searchQuery);
                    }).toList();
                  }

                  // Determine if we should show featured
                  bool showFeatured = _selectedCategory == 'All' && _searchQuery.isEmpty;
                  
                  return SliverMainAxisGroup(
                    slivers: [
                      if (showFeatured) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: Text(
                              'Featured opportunity',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: FeaturedOpportunityCard(opportunity: featuredOpportunity),
                          ),
                        ),
                      ],

                      if (filteredOpportunities.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
                            child: Text(
                              showFeatured ? 'Explore opportunities' : 'Search Results',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverLayoutBuilder(
                            builder: (BuildContext context, constraints) {
                              int crossAxisCount = constraints.crossAxisExtent > 650 ? 2 : 1;
                              
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int rowIndex) {
                                    int firstIndex = rowIndex * crossAxisCount;
                                    int secondIndex = firstIndex + 1;

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 24),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: OpportunityCard(opportunity: filteredOpportunities[firstIndex]),
                                            ),
                                            if (crossAxisCount == 2) ...[
                                              const SizedBox(width: 24),
                                              Expanded(
                                                child: secondIndex < filteredOpportunities.length
                                                    ? OpportunityCard(opportunity: filteredOpportunities[secondIndex])
                                                    : const SizedBox(),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: (filteredOpportunities.length / crossAxisCount).ceil(),
                                ),
                              );
                            },
                          ),
                        ),
                      ] else if (!showFeatured) ...[
                        SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                'No opportunities found matching your criteria.',
                                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'My Sign-ups',
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHero(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make an impact.\nOne opportunity at a time.',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Discover meaningful ways to contribute\nto your community.',
                style: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 4,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/opportunities/tree_plantation.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHero(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Make an impact.\nOne opportunity at a time.',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Discover meaningful ways to contribute\nto your community.',
          style: TextStyle(
            fontSize: 18,
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/opportunities/tree_plantation.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
