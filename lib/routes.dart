import '../utils/shared_import.dart';

class Routes {
  static Route<dynamic> createRoute(BuildContext context) => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Game(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      // final tween = Tween(begin: begin, end: end);
      const curve = Curves.ease;
      final curveTween = CurveTween(curve: curve);

      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
