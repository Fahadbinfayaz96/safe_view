import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:safe_view/blocs/create_parent_profile_cubit%20copy/create_parent_profile_cubit.dart';
import 'package:safe_view/blocs/delete_history_cubit/delete_history_cubit.dart';
import 'package:safe_view/blocs/edit_parent_profile_cubit/edit_parent_profile_cubit.dart';
import 'package:safe_view/blocs/generate_code_cubit/generate_code_cubit.dart';
import 'package:safe_view/blocs/get_content_filters_cubit/get_content_filters_cubit.dart';
import 'package:safe_view/blocs/get_kids_activities_cubit/get_kids_activities_cubit.dart';
import 'package:safe_view/blocs/get_parent_profile_cubit/get_parent_profile_cubit.dart';
import 'package:safe_view/blocs/get_remaining_time_cubit/get_remaining_time_cubit.dart';
import 'package:safe_view/blocs/info_cubit/info_cubit.dart';
import 'package:safe_view/blocs/pairing_status_cubit/pairing_status_cubit.dart';
import 'package:safe_view/blocs/send_kids_activities_cubit/send_kids_activities_cubit.dart';
import 'package:safe_view/blocs/set_pin_cubit/set_pin_cubit.dart';
import 'package:safe_view/blocs/show_videos_cubit/show_videos_cubit.dart';
import 'package:safe_view/blocs/track_time_limit_cubit/track_time_limit_cubit.dart';
import 'package:safe_view/blocs/trail_status_cubit/trail_status_cubit.dart';
import 'package:safe_view/blocs/unlink_device_cubit/unlink_device_cubit.dart';
import 'package:safe_view/blocs/update_content_filter_cubit/update_content_filter_cubit.dart';
import 'package:safe_view/blocs/upgrade_cubit/upgrade_cubit.dart';
import 'package:safe_view/blocs/verify_code_cubit/verify_code_cubit.dart';
import 'package:safe_view/blocs/verify_pin_cubit/verify_pin_cubit.dart';
import 'package:safe_view/services/api_services.dart';
import 'package:safe_view/views/splash_screen.dart';
import 'package:safe_view/widgets/internet_popup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Get.put(InternetController(), permanent: true);
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
          BlocProvider(
            create: (context) => SetPinCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => VerifyPinCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => UnlinkDeviceCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => CreateParentProfileCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => EditParentProfileCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => GetParentProfileCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => UpgradeCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => TrackTimeLimitCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => GetRemainingTimeCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => TrailStatusCubit(ApiService()),
          ),
          BlocProvider(
            create: (context) => DeleteHistoryCubit(ApiService()),
          ),
        ],
        child: GetMaterialApp(
          navigatorKey: navigatorKey,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
