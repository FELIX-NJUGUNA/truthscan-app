import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthscan_app/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Welcome to TruthScan',
      'description': 'Analyze documents easily!',
    },
    {'title': 'Secure', 'description': 'Your data is safe with us.'},
    {'title': 'Get Started', 'description': 'Let\'s begin!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => _completeOnboarding(context),
            child: const Text("Skip", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildPage(
              context,
              onboardingData[index]['title']!,
              onboardingData[index]['description']!,
              key: ValueKey(index),
            ),
          );
        },
      ),
      floatingActionButton:
          _currentPage == onboardingData.length - 1
              ? FloatingActionButton(
                onPressed: () => _completeOnboarding(context),
                child: const Icon(Icons.arrow_forward),
              )
              : null,
      bottomNavigationBar:
          onboardingData.length > 1
              ? Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => _buildDot(index, context),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildPage(
    BuildContext context,
    String title,
    String description, {
    Key? key,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.document_scanner,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 40),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color:
            _currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
