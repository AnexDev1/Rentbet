import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  // Titles for each page
  final List<String> _titles = [
    r"Discover Homes",
    r"Expert Connections",
    r"Hassle-Free Process",
    r"Join the Journey"
  ];

  // Descriptions for each page
  final List<String> _descriptions = [
    r"Find the perfect home that suits your lifestyle.",
    r"Connect with professionals who understand your needs.",
    r"Experience a streamlined and effortless renting process.",
    r"Become part of our community and unlock exclusive benefits."
  ];

  final List<String> _images = [
    r'assets/onboarding2.jpg',
    r'assets/onboarding3.jpg',
    r'assets/onboarding.jpg',
    r'assets/onboarding4.jpg',
  ];
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _titles.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width:_currentPage == index? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white38,
           borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scrollable background images using PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          // Persistent top RentBet text
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                r"RentBet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          // Persistent bottom overlay content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title for the current page.
                  Text(
                    _titles[_currentPage],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description for the current page.
                  Text(
                    _descriptions[_currentPage],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Page indicator dots.
                  _buildPageIndicator(),
                  const SizedBox(height: 36),
                  // Buttons row: Join (filled) and Login (outlined).
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text(r"Join", style: TextStyle(fontSize: 15),),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(150, 0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () {},
                        child: const Text(r"Login", style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}