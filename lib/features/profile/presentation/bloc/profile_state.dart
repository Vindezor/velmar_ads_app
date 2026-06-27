part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileDetails profileDetails;
  ProfileLoaded({required this.profileDetails});
}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

// Credit Request submission states
final class ProfileRequestSubmitting extends ProfileState {}

final class ProfileRequestSuccess extends ProfileState {}

final class ProfileRequestError extends ProfileState {
  final String message;
  ProfileRequestError({required this.message});
}

// Credit Request fetching states
final class ProfileCreditRequestsLoading extends ProfileState {}

final class ProfileCreditRequestsLoaded extends ProfileState {
  final List<CreditRequest> creditRequests;
  ProfileCreditRequestsLoaded({required this.creditRequests});
}

final class ProfileCreditRequestsError extends ProfileState {
  final String message;
  ProfileCreditRequestsError({required this.message});
}
