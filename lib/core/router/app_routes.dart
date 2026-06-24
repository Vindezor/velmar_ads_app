class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const bookings = '/bookings';
  static const library = '/library';
  static const profile = '/profile';
  static const billboardDetail = '/dashboard/billboard/:id';

  static String billboardDetailPath(String id) => '/dashboard/billboard/$id';
}
