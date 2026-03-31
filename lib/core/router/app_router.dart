import 'package:go_router/go_router.dart';
import '../../features/user_directory/domain/entities/user.dart';
import '../../features/user_directory/presentation/pages/user_list_page.dart';
import '../../features/user_directory/presentation/pages/user_detail_page.dart';

class AppRouter {
  static const String root = '/';
  static const String userDetail = '/user-detail';

  static final GoRouter router = GoRouter(
    initialLocation: root,
    routes: [
      GoRoute(
        path: root,
        builder: (context, state) => const UserListPage(),
      ),
      GoRoute(
        path: userDetail,
        builder: (context, state) {
          final user = state.extra as User;
          return UserDetailPage(user: user);
        },
      ),
    ],
  );
}
