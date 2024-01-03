import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/config.dart';



class MySupabase{
 static initializeDatabase() async {
   await Supabase.initialize(
       url: Config.url,
       anonKey: Config.anonKey
       );
}


 static final SupabaseClient supabase = Supabase.instance.client;
}

