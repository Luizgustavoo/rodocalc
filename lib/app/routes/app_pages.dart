import 'package:get/get.dart';
import 'package:rodocalc/app/data/bindings/classified_binding.dart';
import 'package:rodocalc/app/data/bindings/course_binding.dart';
import 'package:rodocalc/app/data/bindings/document_binding.dart';
import 'package:rodocalc/app/data/bindings/financial_binding.dart';
import 'package:rodocalc/app/data/bindings/freight_binding.dart';
import 'package:rodocalc/app/data/bindings/home_binding.dart';
import 'package:rodocalc/app/data/bindings/indicator_binding.dart';
import 'package:rodocalc/app/data/bindings/initial_binding.dart';
import 'package:rodocalc/app/data/bindings/login_binding.dart';
import 'package:rodocalc/app/data/bindings/perfil_binding.dart';
import 'package:rodocalc/app/data/bindings/plan_binding.dart';
import 'package:rodocalc/app/data/bindings/signup_binding.dart';
import 'package:rodocalc/app/data/bindings/trip_binding.dart';
import 'package:rodocalc/app/data/bindings/user_binding.dart';
import 'package:rodocalc/app/data/bindings/vehicle_binding.dart';
import 'package:rodocalc/app/modules/classified/classified_view.dart';
import 'package:rodocalc/app/modules/course/course_view.dart';
import 'package:rodocalc/app/modules/document/document_view.dart';
import 'package:rodocalc/app/modules/financial/financial_view.dart';
import 'package:rodocalc/app/modules/freight/freight_view.dart';
import 'package:rodocalc/app/modules/home/home_view.dart';
import 'package:rodocalc/app/modules/indicator/indicator_view.dart';
import 'package:rodocalc/app/modules/initial/initial_view.dart';
import 'package:rodocalc/app/modules/login/login_view.dart';
import 'package:rodocalc/app/modules/perfil/perfil_view.dart';
import 'package:rodocalc/app/modules/plan/manage_plan_view.dart';
import 'package:rodocalc/app/modules/plan/new_plan_view.dart';
import 'package:rodocalc/app/modules/plan/plan_view.dart';
import 'package:rodocalc/app/modules/signup/signup_view.dart';
import 'package:rodocalc/app/modules/trip/trip_view.dart';
import 'package:rodocalc/app/modules/user/user_view.dart';
import 'package:rodocalc/app/modules/vehicle/vehicle_view.dart';
import 'package:rodocalc/app/routes/app_routes.dart';

import '../modules/indicator/my_indications_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.initial,
      page: () => const InitialView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.vehicle,
      page: () => const VehiclesView(),
      binding: VehiclesBinding(),
    ),
    GetPage(
      name: Routes.financial,
      page: () => const FinancialView(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: Routes.freight,
      page: () => const FreightView(),
      binding: FreightBinding(),
    ),
    GetPage(
      name: Routes.document,
      page: () => const DocumentView(),
      binding: DocumentBinding(),
    ),
    GetPage(
      name: Routes.indicator,
      page: () => IndicatorView(),
      binding: IndicatorBinding(),
    ),
    GetPage(
      name: Routes.plan,
      page: () => const PlanView(),
      binding: PlanBinding(),
    ),
    GetPage(
      name: Routes.perfil,
      page: () => const PerfilView(),
      binding: PerfilBinding(),
    ),
    GetPage(
      name: Routes.classified,
      page: () => const ClassifiedView(),
      binding: ClassifiedBinding(),
    ),
    GetPage(
      name: Routes.course,
      page: () => const CourseView(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: Routes.manageplan,
      page: () => const ManagePlanView(),
      binding: PlanBinding(),
    ),
    GetPage(
      name: Routes.user,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.trip,
      page: () => const TripView(),
      binding: TripBinding(),
    ),
    GetPage(
      name: Routes.newplanview,
      page: () => const NewPlanView(),
      binding: PlanBinding(),
    ),
    GetPage(
      name: Routes.myIndications,
      page: () => MyIndicationsView(),
      binding: IndicatorBinding(),
    ),
  ];
}
