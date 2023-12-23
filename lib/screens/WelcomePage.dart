import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:green_quest/screens/Login.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildWelcomeScreen(
            'Welcome to GreenQuest!',
            'Discover the joy of making a positive impact on the environment.',
            'assets/images/logo.png',
            showGetStartedButton: false,
          ),
          _buildWelcomeScreen(
            'Easy and Fun Tasks',
            'Complete simple tasks to earn points and contribute to a greener world.',
            'assets/images/logo.png',
            showGetStartedButton: false,
          ),
          _buildWelcomeScreen(
            'Plant Real Trees',
            'Exchange your points for real trees that we will plant on your behalf.',
            'assets/images/logo.png',
            showGetStartedButton: true, // Show button on the last screen
          ),
        ],
      ),
      bottomSheet: _currentPage == 2
          ? Container(
              width: double.infinity,
              // color: Colors.green,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                 style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF609966)), // Custom color for the button
                    elevation: MaterialStateProperty.all<double>(9.0),
                  ),
                onPressed: () {
                  // Navigate to the login screen after the last welcome screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text('Get Started', style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            )
          : _currentPage == 0 || _currentPage == 1
              ? Container(
                  width: double.infinity,
                  // color: Colors.green,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_currentPage > 0) ...[
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF609966)), // Custom color for the button
                            elevation: MaterialStateProperty.all<double>(9.0),
                  ),
                          onPressed: () {
                            // Go to the previous page
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Previous', style: TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                        const Gap(8),
                      ],
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF609966)), // Custom color for the button
                          elevation: MaterialStateProperty.all<double>(9.0),
                  ),
                        onPressed: () {
                          // Go to the next page
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next', style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : null,
    );
  }

  Widget _buildWelcomeScreen(
    String title,
    String description,
    String imageAsset, {
    bool showGetStartedButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAsset,
            width: 150,
            height: 150,
          ),
          const Gap(20),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Gap(40),
          Text(
            description,

            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
