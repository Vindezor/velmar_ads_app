import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/secrets/app_secrets.dart';
import 'package:velmar_ads/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:velmar_ads/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:velmar_ads/features/auth/domain/repository/auth_repository.dart';
import 'package:velmar_ads/features/auth/domain/usecases/current_user.dart';
import 'package:velmar_ads/features/auth/domain/usecases/user_login.dart';
import 'package:velmar_ads/features/auth/domain/usecases/user_sign_up.dart';
import 'package:velmar_ads/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:velmar_ads/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:velmar_ads/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:velmar_ads/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:velmar_ads/features/dashboard/domain/usecases/get_dashboard_data.dart';
import 'package:velmar_ads/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:velmar_ads/features/bookings/data/datasources/bookings_remote_data_source.dart';
import 'package:velmar_ads/features/bookings/data/repositories/bookings_repository_impl.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_billboard_bookings.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/calculate_booking_price.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_active_booking_type_id.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_user_credits.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_creative_asset.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_user_bookings.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_booking_detail.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/resubmit_booking.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:velmar_ads/features/library/data/datasources/library_remote_data_source.dart';
import 'package:velmar_ads/features/library/data/repositories/library_repository_impl.dart';
import 'package:velmar_ads/features/library/domain/repository/library_repository.dart';
import 'package:velmar_ads/features/library/domain/usecases/upload_ad_asset.dart';
import 'package:velmar_ads/features/library/domain/usecases/delete_ad_asset.dart';
import 'package:velmar_ads/features/library/domain/usecases/get_user_assets.dart';
import 'package:velmar_ads/features/library/presentation/bloc/library_bloc.dart';
import 'package:velmar_ads/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:velmar_ads/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:velmar_ads/features/profile/domain/repository/profile_repository.dart';
import 'package:velmar_ads/features/profile/domain/usecases/get_profile_details.dart';
import 'package:velmar_ads/features/profile/domain/usecases/submit_credit_request.dart';
import 'package:velmar_ads/features/profile/domain/usecases/get_credit_requests.dart';
import 'package:velmar_ads/features/profile/presentation/bloc/profile_bloc.dart';


final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initDashboard();
  _initBookings();
  _initLibrary();
  _initProfile();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    publishableKey: AppSecrets.supabasePublishableKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    ..registerFactory(() => UserLogin(authRepository: serviceLocator()))
    ..registerFactory(() => CurrentUser(authRepository: serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initDashboard() {
  serviceLocator
    ..registerFactory<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetDashboardData(repository: serviceLocator()))
    ..registerFactory(
      () => DashboardBloc(
        getDashboardData: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBookings() {
  serviceLocator
    ..registerFactory<BookingsRemoteDataSource>(
      () => BookingsRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerLazySingleton<BookingsRepository>(
      () => BookingsRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetBillboardBookings(bookingsRepository: serviceLocator()))
    ..registerFactory(() => GetUserCredits(bookingsRepository: serviceLocator()))
    ..registerFactory(() => GetActiveBookingTypeId(bookingsRepository: serviceLocator()))
    ..registerFactory(() => CalculateBookingPrice(bookingsRepository: serviceLocator()))
    ..registerFactory(() => CreateBookingUseCase(bookingsRepository: serviceLocator()))
    ..registerFactory(() => GetCreativeAsset(bookingsRepository: serviceLocator()))
    ..registerFactory(() => GetUserBookings(bookingsRepository: serviceLocator()))
    ..registerFactory(() => GetBookingDetail(bookingsRepository: serviceLocator()))
    ..registerFactory(() => ResubmitBooking(bookingsRepository: serviceLocator()))
    ..registerFactory(
      () => BookingsBloc(
        getBillboardBookings: serviceLocator(),
        getUserCredits: serviceLocator(),
        getActiveBookingTypeId: serviceLocator(),
        calculateBookingPrice: serviceLocator(),
        createBookingUseCase: serviceLocator(),
        getCreativeAsset: serviceLocator(),
        getUserBookings: serviceLocator(),
        getBookingDetail: serviceLocator(),
        resubmitBooking: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initLibrary() {
  serviceLocator
    ..registerFactory<LibraryRemoteDataSource>(
      () => LibraryRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => UploadAdAsset(repository: serviceLocator()))
    ..registerFactory(() => DeleteAdAsset(repository: serviceLocator()))
    ..registerFactory(() => GetUserAssets(libraryRepository: serviceLocator()))
    ..registerFactory(
      () => LibraryBloc(
        uploadAdAsset: serviceLocator(),
        deleteAdAsset: serviceLocator(),
        getUserAssets: serviceLocator(),
      ),
    );
}

void _initProfile() {
  serviceLocator
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    ..registerFactory(() => GetProfileDetails(profileRepository: serviceLocator()))
    ..registerFactory(() => SubmitCreditRequest(profileRepository: serviceLocator()))
    ..registerFactory(() => GetCreditRequests(profileRepository: serviceLocator()))
    ..registerFactory(
      () => ProfileBloc(
        getProfileDetails: serviceLocator(),
        submitCreditRequest: serviceLocator(),
        getCreditRequests: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}


