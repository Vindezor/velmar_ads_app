part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileLoadDetails extends ProfileEvent {
  final bool forceRefresh;
  ProfileLoadDetails({this.forceRefresh = false});
}

final class ProfileLoadCreditRequests extends ProfileEvent {
  final bool forceRefresh;
  ProfileLoadCreditRequests({this.forceRefresh = false});
}

final class ProfileResetState extends ProfileEvent {}

final class ProfileSubmitRequest extends ProfileEvent {
  final double amount;
  final Uint8List fileBytes;
  final String fileName;
  final String? paymentNotes;

  ProfileSubmitRequest({
    required this.amount,
    required this.fileBytes,
    required this.fileName,
    this.paymentNotes,
  });
}
