class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const bookings = '/bookings';
  static const library = '/library';
  static const profile = '/profile';
  static const billboardDetail = '/dashboard/billboard/:id';
  static const selectSchedule = '/dashboard/billboard/:id/book';

  static String billboardDetailPath(String id) => '/dashboard/billboard/$id';
  static String selectSchedulePath(String id) => '/dashboard/billboard/$id/book';
}
