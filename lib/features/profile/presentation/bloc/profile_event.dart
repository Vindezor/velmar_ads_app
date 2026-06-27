part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileLoadDetails extends ProfileEvent {}

final class ProfileResetState extends ProfileEvent {}
