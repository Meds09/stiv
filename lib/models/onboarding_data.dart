class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingContent> contentData = [
  OnboardingContent(
    image: 'assets/images/onboarding_pages/onboarding-1.png',
    title: "Bienvenido a Stiv",
    description:
        "Tu asistente inteligente para diagnostico y soporte en sistemas electronicos.",
  ),
  OnboardingContent(
    image: 'assets/images/onboarding_pages/onboarding-2.png',
    title: "Detecta y analiza fallas al instante",
    description:
        "Stiv identifica problemas en cámaras, redes PoE o sensores mediante análisis guiado paso a paso.",
  ),
  OnboardingContent(
    image: 'assets/images/onboarding_pages/onboarding-3.png',
    title: "Sigue guías prácticas y seguras",
    description:
        "Recibe pasos claros para reparar, configurar o optimizar tus dispositivos sin complicaciones.",
  ),
];
