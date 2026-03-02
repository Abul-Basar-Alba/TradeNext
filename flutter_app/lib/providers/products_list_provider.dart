import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

// Provider for fetching all products
final allProductsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseServiceProvider);
  return await supabase.getAllProducts(limit: 50);
});

// Provider for fetching user's own products
final myProductsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, userId) async {
    final supabase = ref.read(supabaseServiceProvider);
    return await supabase.getUserProductsMaps(userId);
  },
);
