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
  String get appTitle => locale.languageCode == 'ko' ? '김종민의 포트폴리오' : 'KJM\'s Portfolio';

  // Navigation
  String get navHome => locale.languageCode == 'ko' ? '홈' : 'Home';
  String get navProjects => locale.languageCode == 'ko' ? '프로젝트' : 'Projects';
  String get navContact => locale.languageCode == 'ko' ? '연락처' : 'Contact';
  String get navAbout => locale.languageCode == 'ko' ? '소개' : 'About';

  // Developer Info
  String get developerName =>
      locale.languageCode == 'ko' ? '김종민' : 'Kim Jong Min';
  String get developerNameSuffix => locale.languageCode == 'ko' ? '입니다.' : '';

  // Intro Section
  String get introGreeting =>
      locale.languageCode == 'ko' ? '안녕하세요, 저는' : "Hello, I'm";
  String get jobTitle =>
      locale.languageCode == 'ko'
          ? 'Flutter 개발자'
          : 'Flutter Developer';
  String get introDescription =>
      locale.languageCode == 'ko'
          ? '\'사용자가 계속 쓰고 싶은\' 애플리케이션 제작을 목표로 합니다.\n깔끔한 코드와 직관적인 디자인을 통해 뛰어난 사용자 경험을 제공하는 것에 중점을 둡니다.'
          : 'I\'ve aimed to create the app that \'users want to use continuously\'.\nMy focus is on delivering exceptional user experiences through clean code and intuitive design.';
  String get downloadCV =>
      locale.languageCode == 'ko' ? '이력서 다운로드' : 'Download CV';
  String get contactMe => locale.languageCode == 'ko' ? '연락하기' : 'Contact Me';
  String get yearsExperience =>
      locale.languageCode == 'ko' ? '1년+ 경력' : '1+ Years Experience';

  // Projects Section
  String get portfolioLabel =>
      locale.languageCode == 'ko' ? '포트폴리오' : 'PORTFOLIO';
  String get featuredProjects =>
      locale.languageCode == 'ko' ? '주요 프로젝트' : 'Featured Projects';
  String get projectsDescription =>
      locale.languageCode == 'ko'
          ? '최근 프로젝트들입니다. 각각은 세심한 주의와 사용자 경험을 고려하여 신중하게 제작되었습니다.'
          : 'Here are some of my recent projects.\nEach one was carefully crafted with attention to detail and user experience.';
  String get viewProject =>
      locale.languageCode == 'ko' ? '프로젝트 보기' : 'View Project';
  String get noProjectsFound =>
      locale.languageCode == 'ko'
          ? '이 카테고리에서 프로젝트를 찾을 수 없습니다.'
          : 'No projects found in this category.';

  // Project Categories - 자동화된 매핑
  static const Map<String, Map<String, String>> _categoryLabels = {
    'all': {'en': 'All', 'ko': '전체'},
    'web': {'en': 'Web', 'ko': '웹'},
    'mobile': {'en': 'Mobile', 'ko': '모바일'},
    'uiux': {'en': 'UI/UX', 'ko': 'UI/UX'},
    'backend': {'en': 'Backend', 'ko': '백엔드'},
  };

  String getCategoryLabel(String categoryKey) {
    return _categoryLabels[categoryKey]?[locale.languageCode] ?? 
           _categoryLabels[categoryKey]?['en'] ?? 
           categoryKey;
  }

  // Project Titles and Descriptions - 자동화된 매핑
  static const Map<String, Map<String, String>> _projectTitles = {
    'dreamhue': {
      'en': 'DreamHue',
      'ko': 'DreamHue',
    },
    'portfolio': {
      'en': 'Portfolio Website',
      'ko': '포트폴리오 웹사이트',
    },
    'connectedFarm': {
      'en': 'CONNECTED FARM',
      'ko': '커넥티드 팜',
    },
    'connect': {
      'en': 'CONNECT',
      'ko': '커넥트',
    },
    'sims': {
      'en': 'SIMS (Smart Inventory Management System)',
      'ko': 'SIMS (스마트 재고 관리 시스템)',
    },
    'gachonNoti': {
      'en': 'Gachon Noti',
      'ko': '가천 알림이',
    },
  };

  static const Map<String, Map<String, String>> _projectDescriptions = {
    'dreamhue': {
      'en': 'An app that provides sounds for people who have trouble sleeping.',
      'ko': '수면에 불편을 겪는 사람들을 위한 사운드를 제공하는 앱입니다.',
    },
    'portfolio': {
      'en': 'Responsive portfolio website built with Flutter web.',
      'ko': 'Flutter Web으로 구축된 반응형 포트폴리오 웹사이트입니다.',
    },
    'connectedFarm': {
      'en': 'IoT-based farm management system for smart agriculture.',
      'ko': '스마트 농업을 위한 IoT 기반 농장 관리 시스템입니다.',
    },
    'connect': {
      'en': 'Social networking platform for connecting users.',
      'ko': '사용자 간 연결을 위한 소셜 네트워킹 플랫폼입니다.',
    },
    'sims': {
      'en': 'Smart system for efficient inventory management.',
      'ko': '효율적인 재고 관리를 위한 스마트 시스템입니다.',
    },
    'gachonNoti': {
      'en': 'Notification service for Gachon University students.',
      'ko': '가천대학교 학생들을 위한 알림 서비스입니다.',
    },
  };

  String getProjectTitle(String projectKey) {
    return _projectTitles[projectKey]?[locale.languageCode] ?? 
           _projectTitles[projectKey]?['en'] ?? 
           projectKey;
  }

  String getProjectDescription(String projectKey) {
    return _projectDescriptions[projectKey]?[locale.languageCode] ?? 
           _projectDescriptions[projectKey]?['en'] ?? 
           projectKey;
  }

  // Contact Section
  String get getInTouch =>
      locale.languageCode == 'ko' ? '연락하기' : 'GET IN TOUCH';
  String get contactTitle => locale.languageCode == 'ko' ? '연락처' : 'Contact Me';
  String get contactDescription =>
      locale.languageCode == 'ko'
          ? '개발자를 찾고 계시거나, 질문이 있으시다면 언제든지 연락해 주세요.'
          : "Feel free to reach out if you're looking for a developer, or have a question.";

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
