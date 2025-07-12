import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_view/blocs/generate_code_cubit/generate_code_cubit.dart';
import 'package:safe_view/blocs/get_content_filters_cubit/get_content_filters_cubit.dart';
import 'package:safe_view/blocs/get_kids_activities_cubit/get_kids_activities_cubit.dart';
import 'package:safe_view/blocs/info_cubit/info_cubit.dart';
import 'package:safe_view/blocs/pairing_status_cubit/pairing_status_cubit.dart';
import 'package:safe_view/blocs/send_kids_activities_cubit/send_kids_activities_cubit.dart';
import 'package:safe_view/blocs/show_videos_cubit/show_videos_cubit.dart';
import 'package:safe_view/blocs/update_content_filter_cubit/update_content_filter_cubit.dart';
import 'package:safe_view/blocs/verify_code_cubit/verify_code_cubit.dart';
import 'package:safe_view/services/api_services.dart';
import 'package:safe_view/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GenerateCodeCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => VerifyCodeCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => PairingStatusCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => InfoCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => UpdateContentFilterCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => GetContentFiltersCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => ShowVideosCubit(ApiService()),
          ),
            BlocProvider(
            create: (context) => SendKidsActivitiesCubit(ApiService()),
          ),
           BlocProvider(
            create: (context) => GetKidsActivitiesCubit(ApiService()),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
