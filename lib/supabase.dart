import 'package:supabase_flutter/supabase_flutter.dart';

class MySupabase{
 static initializeDatabase() async {
   await Supabase.initialize(
       url: 'https://jhhvclfbhvccvxllheqf.supabase.co',
       anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpoaHZjbGZiaHZjY3Z4bGxoZXFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODgwMTg1NzMsImV4cCI6MjAwMzU5NDU3M30.v5OPEJeEdKBKh6el_y4yZ8CEaRjMt5j-IvuWNyweiNM'
       );
}


 static final SupabaseClient supabase = Supabase.instance.client;
}

//https://klbphmfsiwvrrchuevwi.supabase.co
//'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtsYnBobWZzaXd2cnJjaHVldndpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTg4NTEyNDYsImV4cCI6MjAxNDQyNzI0Nn0.iZw6jAWfXytMeWh_DYiJ-dDYUkzCsXpAGKVMo0w8qTk'
