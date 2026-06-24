import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/features/dashboard/data/models/billboard_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<List<BillboardModel>> getBillboards();
  Future<double> getUserBalance(String userId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient supabaseClient;

  const DashboardRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<BillboardModel>> getBillboards() async {
    try {
      final response = await supabaseClient
          .from('billboards')
          .select('*, zones(base_price_per_hour), size_categories(price_multiplier), screen_classes(label)');

      final list = response as List<dynamic>;
      return list.map((json) => BillboardModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<double> getUserBalance(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('credits')
          .eq('id', userId)
          .single();

      return (response['credits'] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
