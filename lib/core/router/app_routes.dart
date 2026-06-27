class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const bookings = '/bookings';
  static const library = '/library';
  static const profile = '/profile';
  static const billboardDetail = '/dashboard/billboard/:id';
  static const selectSchedule = '/dashboard/billboard/:id/book';
  static const uploadAsset = '/dashboard/billboard/:id/book/upload-asset';
  static const bookingConfirmation = '/booking-confirmation/:id';

  static String billboardDetailPath(String id) => '/dashboard/billboard/$id';
  static String selectSchedulePath(String id) => '/dashboard/billboard/$id/book';
  static String uploadAssetPath(String id) => '/dashboard/billboard/$id/book/upload-asset';
  static String bookingConfirmationPath(String id) => '/booking-confirmation/$id';
}
