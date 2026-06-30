// ignore_for_file: prefer_initializing_formals

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:velmar_ads/features/profile/data/models/credit_request_model.dart';
import 'package:velmar_ads/features/profile/domain/entities/profile_details.dart';
import 'package:velmar_ads/features/profile/domain/entities/credit_request.dart';
import 'package:velmar_ads/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileDetails? _cachedProfileDetails;
  String? _cachedProfileUserId;
  DateTime? _lastProfileCacheTime;

  List<CreditRequest>? _cachedCreditRequests;
  String? _cachedCreditUserId;
  DateTime? _lastCreditCacheTime;

  static const _ttl = Duration(minutes: 5);

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ProfileDetails>> getProfileDetails(String userId, {bool forceRefresh = false}) async {
    // If user changed, invalidate cache immediately
    if (_cachedProfileUserId != null && _cachedProfileUserId != userId) {
      if (kDebugMode) {
        print('📦 [CACHE] Profile details user cambiado de $_cachedProfileUserId a $userId. Invalidando cache.');
      }
      _cachedProfileDetails = null;
      _cachedProfileUserId = null;
      _lastProfileCacheTime = null;
    }

    if (!forceRefresh &&
        _cachedProfileUserId == userId &&
        _cachedProfileDetails != null &&
        _lastProfileCacheTime != null &&
        DateTime.now().difference(_lastProfileCacheTime!) < _ttl) {
      if (kDebugMode) {
        print('📦 [CACHE HIT] Profile details para $userId');
      }
      return right(_cachedProfileDetails!);
    }

    try {
      if (kDebugMode) {
        print('📦 [CACHE MISS] Profile details consultando Supabase para $userId (forceRefresh: $forceRefresh)');
      }
      final futures = await Future.wait([
        _remoteDataSource.getUserCredits(userId),
        _remoteDataSource.getMovementHistory(userId),
      ]);

      final credits = futures[0] as double;
      final movements = futures[1] as List<dynamic>;

      final details = ProfileDetails(
        credits: credits,
        movements: movements.cast(),
      );

      _cachedProfileDetails = details;
      _cachedProfileUserId = userId;
      _lastProfileCacheTime = DateTime.now();

      if (kDebugMode) {
        print('📦 [CACHE UPDATE] Profile details cache actualizado para $userId');
      }

      return right(details);
    } on ServerException catch (e) {
      if (_cachedProfileUserId == userId && _cachedProfileDetails != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale profile details tras ServerException: ${e.message}');
        }
        return right(_cachedProfileDetails!);
      }
      return left(Failure(e.message));
    } catch (e) {
      if (_cachedProfileUserId == userId && _cachedProfileDetails != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale profile details tras error inesperado: $e');
        }
        return right(_cachedProfileDetails!);
      }
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitCreditRequest({
    required double amount,
    required Uint8List fileBytes,
    required String fileName,
    required String userId,
    String? paymentNotes,
  }) async {
    final extension = fileName.split('.').last;
    final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.$extension';
    bool isUploaded = false;

    try {
      // 1. Upload payment proof
      final proofUrl = await _remoteDataSource.uploadPaymentProof(
        fileBytes: fileBytes,
        path: path,
      );
      isUploaded = true;

      // 2. Generate unique order number (e.g. CR-timestamp)
      final orderNumber = 'CR-${DateTime.now().millisecondsSinceEpoch}';

      // 3. Construct the model
      final request = CreditRequestModel(
        id: '', // database auto-generates uuid
        userId: userId,
        orderNumber: orderNumber,
        creditsRequested: amount,
        usdAmount: amount,
        paymentProofUrl: proofUrl,
        paymentNotes: paymentNotes ?? 'Transferencia bancaria',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 4. Submit to database
      await _remoteDataSource.createCreditRequest(request);

      _cachedCreditRequests = null;
      _cachedCreditUserId = null;
      _lastCreditCacheTime = null;
      _cachedProfileDetails = null;
      _cachedProfileUserId = null;
      _lastProfileCacheTime = null;

      if (kDebugMode) {
        print('📦 [CACHE] Solicitud de crédito enviada con éxito. Invalidando todos los caches de profile para $userId.');
      }

      return right(null);
    } on ServerException catch (e) {
      if (isUploaded) {
        try {
          await _remoteDataSource.deletePaymentProof(path);
        } catch (_) {}
      }
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CreditRequest>>> getCreditRequests(String userId, {bool forceRefresh = false}) async {
    // If user changed, invalidate cache immediately
    if (_cachedCreditUserId != null && _cachedCreditUserId != userId) {
      if (kDebugMode) {
        print('📦 [CACHE] Profile credit requests user cambiado de $_cachedCreditUserId a $userId. Invalidando cache.');
      }
      _cachedCreditRequests = null;
      _cachedCreditUserId = null;
      _lastCreditCacheTime = null;
    }

    if (!forceRefresh &&
        _cachedCreditUserId == userId &&
        _cachedCreditRequests != null &&
        _lastCreditCacheTime != null &&
        DateTime.now().difference(_lastCreditCacheTime!) < _ttl) {
      if (kDebugMode) {
        print('📦 [CACHE HIT] Profile credit requests para $userId');
      }
      return right(_cachedCreditRequests!);
    }

    try {
      if (kDebugMode) {
        print('📦 [CACHE MISS] Profile credit requests consultando Supabase para $userId (forceRefresh: $forceRefresh)');
      }
      final requests = await _remoteDataSource.getCreditRequests(userId);
      _cachedCreditRequests = requests;
      _cachedCreditUserId = userId;
      _lastCreditCacheTime = DateTime.now();

      if (kDebugMode) {
        print('📦 [CACHE UPDATE] Profile credit requests cache actualizado con ${requests.length} items para $userId');
      }

      return right(requests);
    } on ServerException catch (e) {
      if (_cachedCreditUserId == userId && _cachedCreditRequests != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale credit requests tras ServerException: ${e.message}');
        }
        return right(_cachedCreditRequests!);
      }
      return left(Failure(e.message));
    } catch (e) {
      if (_cachedCreditUserId == userId && _cachedCreditRequests != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale credit requests tras error inesperado: $e');
        }
        return right(_cachedCreditRequests!);
      }
      return left(Failure(e.toString()));
    }
  }
}
