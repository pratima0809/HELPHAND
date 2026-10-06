import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../models/signup.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'confirmation_screen.dart';
import '../widgets/progress_cue.dart';

class SignupScreen extends StatefulWidget {
  final Opportunity opportunity;

  const SignupScreen({super.key, required this.opportunity});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _skillsController = TextEditingController();
  final _reasonController = TextEditingController();

  String? _selectedAvailability;
  bool _consentGiven = false;
  bool _isSubmitting = false;

  final List<String> _availabilityOptions = [
    'Morning',
    'Afternoon',
    'Evening',
    'Full Day'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check the consent box to proceed.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to sign up.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final hasSignedUp = await _firestoreService.hasUserSignedUp(
          user.uid, widget.opportunity.id);

      if (hasSignedUp) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have already signed up for this opportunity.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (widget.opportunity.remainingSlots <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sorry, this opportunity is now fully booked.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final signup = Signup(
        id: '', 
        userId: user.uid,
        opportunityId: widget.opportunity.id,
        opportunityTitle: widget.opportunity.title,
        organizationName: widget.opportunity.organizationName,
        category: widget.opportunity.category,
        date: widget.opportunity.date,
        location: widget.opportunity.location,
        volunteerName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        availability: _selectedAvailability!,
        skills: _skillsController.text.trim(),
        reason: _reasonController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _firestoreService.submitSignup(
          signup, widget.opportunity.remainingSlots);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConfirmationScreen(opportunity: widget.opportunity),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing up: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
      ),
      body: _isSubmitting
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProgressCue(currentStep: 3),
                        const SizedBox(height: 16),
                        // Header
                        Text(
                          'Join the Opportunity',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tell us a little about yourself.',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Summary Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.colorScheme.outline),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: theme.colorScheme.primary),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Signing up for',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.opportunity.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // YOUR DETAILS
                        _buildSectionHeader('YOUR DETAILS', theme),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person_outline,
                          theme: theme,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter your full name';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          theme: theme,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter your email';
                            if (!value.contains('@')) return 'Please enter a valid email address';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          theme: theme,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter your phone number';
                            if (value.trim().length < 10) return 'Please enter a valid phone number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // AVAILABILITY
                        _buildSectionHeader('YOUR AVAILABILITY', theme),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Availability',
                            prefixIcon: Icon(Icons.access_time, color: theme.colorScheme.onSurfaceVariant),
                          ),
                          dropdownColor: theme.colorScheme.surface,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                          initialValue: _selectedAvailability,
                          items: _availabilityOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedAvailability = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please select your availability';
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // ABOUT YOU
                        _buildSectionHeader('ABOUT YOU', theme),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _skillsController,
                          label: 'Skills / Experience (Optional)',
                          maxLines: 2,
                          theme: theme,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _reasonController,
                          label: 'Why do you want to volunteer? (Optional)',
                          maxLines: 3,
                          theme: theme,
                        ),
                        const SizedBox(height: 32),

                        // CONFIRMATION
                        _buildSectionHeader('CONFIRMATION', theme),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          title: Text(
                            'I confirm that the information provided is correct and I agree to participate responsibly.',
                            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
                          ),
                          value: _consentGiven,
                          onChanged: (bool? value) {
                            setState(() {
                              _consentGiven = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _submitSignup,
                            child: const Text(
                              'Confirm Sign-up',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.inverseSurface,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: theme.colorScheme.onSurfaceVariant) : null,
      ),
      validator: validator,
    );
  }
}
