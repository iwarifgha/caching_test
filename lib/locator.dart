import 'package:get_it/get_it.dart';
import 'package:supabase_test/service.dart';

GetIt locator = GetIt.instance;
initLocator(){
  locator.registerSingleton(DataService());
}
