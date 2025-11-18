import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/features/onboarding/data/models/onboarding_data.dart';
import 'package:stiv/core/router/router.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/onboarding_pages/onboarding_back1.svg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  itemCount: contentData.length,
                  controller: _controller,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset(contentData[index].image, height: 400),
                        const Spacer(),
                        Text(
                          contentData[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0663EF),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          contentData[index].description,
                          textAlign:  TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight:  FontWeight.normal,
                            color: Color.fromARGB(255, 36, 38, 44),
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },

                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    ElevatedButton(
                      onPressed: () async {
                        if (currentIndex < contentData.length - 1) {
                          _controller!.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                    
                          await onboardingState.markDone();

                          if (!mounted) return;
                          // ignore: use_build_context_synchronously
                          context.go('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0663EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        child: Text(
                          currentIndex == contentData.length - 1
                              ? "Comienza ahora"
                              : "Siguiente",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contentData.length,
                        (index) => buildDot(index, context),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 6,
      width: currentIndex == index ? 24 : 6,
      margin: const EdgeInsets.only(right: 7),
      decoration: BoxDecoration(
        color: currentIndex == index
            ? Color(0xFF0663EF)
            : Color.fromARGB(255, 82, 85, 95),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
