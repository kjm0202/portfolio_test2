import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en', ''));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ko', ''), // Korean
  ];

  // App Title
  String get appTitle => locale.languageCode == 'ko' ? '포트폴리오' : 'Portfolio';

  // Navigation
  String get navHome => locale.languageCode == 'ko' ? '홈' : 'Home';
  String get navProjects => locale.languageCode == 'ko' ? '프로젝트' : 'Projects';
  String get navContact => locale.languageCode == 'ko' ? '연락처' : 'Contact';
  String get navAbout => locale.languageCode == 'ko' ? '소개' : 'About';

  // Developer Info
  String get developerName =>
      locale.languageCode == 'ko' ? '존 개발자' : 'John Developer';

  // Intro Section
  String get introGreeting =>
      locale.languageCode == 'ko' ? '안녕하세요, 저는' : "Hello, I'm";
  String get jobTitle =>
      locale.languageCode == 'ko'
          ? '풀스택 개발자 & UI/UX 디자이너'
          : 'Full Stack Developer & UI/UX Designer';
  String get introDescription =>
      locale.languageCode == 'ko'
          ? '현대적인 기술로 아름답고 반응형 웹 애플리케이션을 만듭니다. 깔끔한 코드와 직관적인 디자인을 통해 뛰어난 사용자 경험을 제공하는 것에 중점을 둡니다.'
          : 'I create beautiful, responsive web applications with modern technologies. My focus is on delivering exceptional user experiences through clean code and intuitive design.';
  String get downloadCV =>
      locale.languageCode == 'ko' ? 'CV 다운로드' : 'Download CV';
  String get contactMe => locale.languageCode == 'ko' ? '연락하기' : 'Contact Me';
  String get yearsExperience =>
      locale.languageCode == 'ko' ? '5년+ 경력' : '5+ Years Experience';

  // Projects Section
  String get portfolioLabel =>
      locale.languageCode == 'ko' ? '포트폴리오' : 'PORTFOLIO';
  String get featuredProjects =>
      locale.languageCode == 'ko' ? '주요 프로젝트' : 'Featured Projects';
  String get projectsDescription =>
      locale.languageCode == 'ko'
          ? '최근 프로젝트들입니다. 각각은 세심한 주의와 사용자 경험을 고려하여 신중하게 제작되었습니다.'
          : 'Here are some of my recent projects. Each one was carefully crafted with attention to detail and user experience.';
  String get viewProject =>
      locale.languageCode == 'ko' ? '프로젝트 보기' : 'View Project';
  String get noProjectsFound =>
      locale.languageCode == 'ko'
          ? '이 카테고리에서 프로젝트를 찾을 수 없습니다.'
          : 'No projects found in this category.';

  // Project Categories
  String get categoryAll => locale.languageCode == 'ko' ? '전체' : 'All';
  String get categoryWeb => locale.languageCode == 'ko' ? '웹' : 'Web';
  String get categoryMobile => locale.languageCode == 'ko' ? '모바일' : 'Mobile';
  String get categoryUIUX => locale.languageCode == 'ko' ? 'UI/UX' : 'UI/UX';
  String get categoryBackend => locale.languageCode == 'ko' ? '백엔드' : 'Backend';

  // Project Titles and Descriptions
  String get projectECommerceTitle =>
      locale.languageCode == 'ko' ? '이커머스 앱' : 'E-Commerce App';
  String get projectECommerceDesc =>
      locale.languageCode == 'ko'
          ? '원활한 결제 프로세스를 갖춘 깔끔하고 현대적인 이커머스 앱입니다.'
          : 'A clean, modern e-commerce app with a seamless checkout process.';

  String get projectPortfolioTitle =>
      locale.languageCode == 'ko' ? '포트폴리오 웹사이트' : 'Portfolio Website';
  String get projectPortfolioDesc =>
      locale.languageCode == 'ko'
          ? 'Flutter 웹으로 구축된 반응형 포트폴리오 웹사이트입니다.'
          : 'Responsive portfolio website built with Flutter web.';

  String get projectTaskManagerTitle =>
      locale.languageCode == 'ko' ? '작업 관리자' : 'Task Manager';
  String get projectTaskManagerDesc =>
      locale.languageCode == 'ko'
          ? '직관적인 상호작용을 가진 아름다운 작업 관리 UI입니다.'
          : 'A beautiful task management UI with intuitive interactions.';

  String get projectAPIServiceTitle =>
      locale.languageCode == 'ko' ? 'API 서비스' : 'API Service';
  String get projectAPIServiceDesc =>
      locale.languageCode == 'ko'
          ? '보안 인증을 갖춘 클라이언트 프로젝트용 RESTful API입니다.'
          : 'RESTful API developed for a client project with secure auth.';

  String get projectTravelAppTitle =>
      locale.languageCode == 'ko' ? '여행 앱' : 'Travel App';
  String get projectTravelAppDesc =>
      locale.languageCode == 'ko'
          ? '개인화된 추천 기능을 갖춘 사용자 친화적인 여행 예약 앱입니다.'
          : 'User-friendly travel booking app with personalized recommendations.';

  String get projectBankingTitle =>
      locale.languageCode == 'ko' ? '뱅킹 대시보드' : 'Banking Dashboard';
  String get projectBankingDesc =>
      locale.languageCode == 'ko'
          ? '실시간 거래 모니터링을 갖춘 보안 뱅킹 대시보드입니다.'
          : 'Secure banking dashboard with real-time transaction monitoring.';

  // Contact Section
  String get getInTouch =>
      locale.languageCode == 'ko' ? '연락하기' : 'GET IN TOUCH';
  String get contactTitle => locale.languageCode == 'ko' ? '연락처' : 'Contact Me';
  String get contactDescription =>
      locale.languageCode == 'ko'
          ? '개발자를 찾고 계시거나, 질문이 있으시거나, 단순히 연결하고 싶으시다면 언제든지 연락해 주세요.'
          : "Feel free to reach out if you're looking for a developer, have a question, or just want to connect.";

  String get sendMessage =>
      locale.languageCode == 'ko' ? '메시지 보내기' : 'Send a Message';
  String get sendMessageButton =>
      locale.languageCode == 'ko' ? '메시지 전송' : 'Send Message';
  String get messageSentSuccess =>
      locale.languageCode == 'ko'
          ? '메시지가 성공적으로 전송되었습니다!'
          : 'Message sent successfully!';

  // Form Fields
  String get nameLabel => locale.languageCode == 'ko' ? '이름' : 'Name';
  String get nameHint => locale.languageCode == 'ko' ? '당신의 이름' : 'Your name';
  String get emailLabel => locale.languageCode == 'ko' ? '이메일' : 'Email';
  String get emailHint =>
      locale.languageCode == 'ko' ? '당신의 이메일 주소' : 'Your email address';
  String get messageLabel => locale.languageCode == 'ko' ? '메시지' : 'Message';
  String get messageHint =>
      locale.languageCode == 'ko' ? '당신의 메시지' : 'Your message';

  // Form Validation
  String get pleaseEnterName =>
      locale.languageCode == 'ko' ? '이름을 입력해 주세요' : 'Please enter your name';
  String get pleaseEnterEmail =>
      locale.languageCode == 'ko' ? '이메일을 입력해 주세요' : 'Please enter your email';
  String get pleaseEnterValidEmail =>
      locale.languageCode == 'ko'
          ? '유효한 이메일을 입력해 주세요'
          : 'Please enter a valid email';
  String get pleaseEnterMessage =>
      locale.languageCode == 'ko'
          ? '메시지를 입력해 주세요'
          : 'Please enter your message';

  // Contact Information
  String get contactInformation =>
      locale.languageCode == 'ko' ? '연락처 정보' : 'Contact Information';
  String get email => locale.languageCode == 'ko' ? '이메일' : 'Email';
  String get phone => locale.languageCode == 'ko' ? '전화' : 'Phone';
  String get location => locale.languageCode == 'ko' ? '위치' : 'Location';
  String get socialProfiles =>
      locale.languageCode == 'ko' ? '소셜 프로필' : 'Social Profiles';

  // Social Media
  String get facebook => locale.languageCode == 'ko' ? '페이스북' : 'Facebook';
  String get twitter => locale.languageCode == 'ko' ? '트위터' : 'Twitter';
  String get linkedin => locale.languageCode == 'ko' ? '링크드인' : 'LinkedIn';
  String get github => locale.languageCode == 'ko' ? '깃허브' : 'GitHub';

  // Footer
  String get allRightsReserved =>
      locale.languageCode == 'ko' ? '모든 권리 보유.' : 'All rights reserved.';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
