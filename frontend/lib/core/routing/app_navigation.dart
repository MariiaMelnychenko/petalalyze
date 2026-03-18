import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart' as di;
import '../../features/detections/presentation/cubit/detection_details_cubit.dart';
import '../../features/detections/presentation/cubit/detection_history_cubit.dart';
import '../../features/detections/presentation/pages/detection_details_page.dart';
import '../../features/detections/presentation/pages/detection_history_page.dart';
import '../../features/flower/presentation/cubit/flower_details_cubit.dart';
import '../../features/flower/presentation/cubit/flowers_catalog_cubit.dart';
import '../../features/flower/presentation/pages/flower_details_page.dart';
import '../../features/flower/presentation/pages/flowers_catalog_page.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/detection_result_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/root/presentation/pages/root_page.dart';

part 'app_navigation.g.dart';

part '../../features/root/routes/root_shell_route.dart';
part '../../features/home/routes/home_route.dart';
part '../../features/flower/routes/catalog_route.dart';
part '../../features/detections/routes/history_route.dart';
