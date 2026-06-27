part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileLoadDetails extends ProfileEvent {}

final class ProfileResetState extends ProfileEvent {}

final class ProfileSubmitRequest extends ProfileEvent {
  final double amount;
  final String filePath;
  final String fileName;
  final String? paymentNotes;

  ProfileSubmitRequest({
    required this.amount,
    required this.filePath,
    required this.fileName,
    this.paymentNotes,
  });
}
