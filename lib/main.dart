import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_router.dart';
import 'core/constants.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/city_service.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'services/ticket_service.dart';
import 'services/user_service.dart';
import 'view_model/cubit/app_cubit.dart';
import 'view_model/cubit/auth_cubit.dart';
import 'view_model/cubit/notification_cubit.dart';
import 'view_model/cubit/ticket_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await StorageService.create();
  final api = ApiService(baseUrl: AppConstants.baseUrl);

  runApp(MyApp(api: api, storage: storage));
}

class MyApp extends StatelessWidget {
  final ApiService api;
  final StorageService storage;

  const MyApp({super.key, required this.api, required this.storage});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService(api: api, storage: storage);
    final userService = UserService(api: api);
    final ticketService = TicketService(api: api);
    final notificationService = NotificationService(api: api);
    final cityService = CityService(api: api);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(
            authService: authService,
            userService: userService,
          ),
        ),
        BlocProvider(
          create: (ctx) => AppCubit(ctx.read<AuthCubit>()),
        ),
        BlocProvider(create: (_) => TicketCubit(ticketService)),
        BlocProvider(create: (_) => NotificationCubit(notificationService)),
      ],
      child: MaterialApp(
        title: 'Hakathon Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
          useMaterial3: true,
        ),
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
