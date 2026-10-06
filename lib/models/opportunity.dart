class Opportunity {
  final String id;
  final String title;
  final String organizationName;
  final String category;
  final String date;
  final String time;
  final String location;
  final int totalSlots;
  final int remainingSlots;
  final String description;
  final String responsibilities;
  final String requirements;
  final String _originalImageUrl;

  String get imageUrl {
    if (title == 'Beach Cleanup Drive') {
      return 'assets/images/opportunities/beach_cleanup_final.jpg';
    }
    if (_originalImageUrl == 'assets/images/opportunities/beach_cleanup.jpg') {
      return 'assets/images/opportunities/beach_cleanup_final.jpg';
    }
    if (_originalImageUrl == 'assets/images/opportunities/computer_teaching.jpg') {
      return 'assets/images/opportunities/computer_teaching_final.jpg';
    }
    return _originalImageUrl;
  }

  Opportunity({
    required this.id,
    required this.title,
    required this.organizationName,
    required this.category,
    required this.date,
    this.time = '',
    required this.location,
    required this.totalSlots,
    required this.remainingSlots,
    this.description = '',
    this.responsibilities = '',
    this.requirements = '',
    String imageUrl = '',
  }) : _originalImageUrl = imageUrl;

  static String getDefaultImageForCategory(String category) {
    switch (category) {
      case 'Environment':
        return 'assets/images/opportunities/tree_plantation.jpg';
      case 'Education':
        return 'assets/images/opportunities/computer_teaching.jpg';
      case 'Food & Hunger':
        return 'assets/images/opportunities/food_distribution.jpg';
      case 'Animal Welfare':
        return 'assets/images/opportunities/animal_care.jpg';
      case 'Healthcare':
        return 'assets/images/opportunities/health_camp.jpg';
      case 'Elderly Care':
        return 'assets/images/opportunities/senior_support.jpg';
      case 'Community':
        return 'assets/images/opportunities/community_workshop.jpg';
      default:
        return 'assets/images/opportunities/community_workshop.jpg';
    }
  }

  factory Opportunity.fromFirestore(String id, Map<String, dynamic> data) {
    final cat = data['category'] ?? '';
    final imgUrl = data['imageUrl'] ?? '';
    return Opportunity(
      id: id,
      title: data['title'] ?? '',
      organizationName: data['organizationName'] ?? '',
      category: cat,
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      totalSlots: data['totalSlots'] ?? 0,
      remainingSlots: data['remainingSlots'] ?? 0,
      description: data['description'] ?? '',
      responsibilities: data['responsibilities'] ?? '',
      requirements: data['requirements'] ?? '',
      imageUrl: imgUrl.isNotEmpty ? imgUrl : getDefaultImageForCategory(cat),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'organizationName': organizationName,
      'category': category,
      'date': date,
      'time': time,
      'location': location,
      'totalSlots': totalSlots,
      'remainingSlots': remainingSlots,
      'description': description,
      'responsibilities': responsibilities,
      'requirements': requirements,
      'imageUrl': _originalImageUrl,
    };
  }
}
