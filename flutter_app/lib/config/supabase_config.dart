import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    
    // Use Service Role Key to bypass RLS for product creation
    // WARNING: Service role key has full database access
    final serviceKey = dotenv.env['SUPABASE_SERVICE_KEY'] ?? dotenv.env['SUPABASE_ANON_KEY']!;
    
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: serviceKey,
      debug: true,
    );
  }

  // Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
  
  // Storage reference
  static SupabaseStorageClient get storage => client.storage;
}
