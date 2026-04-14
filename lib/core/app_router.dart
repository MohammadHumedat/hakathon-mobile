import 'package:flutter/material.dart';

import '../views/auth/splash_screen.dart';
import '../views/home/home_screen.dart';
import '../views/ticket/create_ticket_screen.dart';
import '../views/ticket/ticket_detail_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String ticketDetail = '/ticket/detail';
  static const String createTicket = '/ticket/create';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case ticketDetail:
        final ticketId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TicketDetailScreen(ticketId: ticketId),
        );
      case createTicket:
        return MaterialPageRoute(builder: (_) => const CreateTicketScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
