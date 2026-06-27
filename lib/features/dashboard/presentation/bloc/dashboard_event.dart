part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

final class DashboardFetchData extends DashboardEvent {}

