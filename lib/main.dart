import 'package:flutter/material.dart';
import 'package:supabase_test/contacts_page.dart';
import 'package:supabase_test/local.dart';
import 'package:supabase_test/locator.dart';
import 'package:supabase_test/service.dart';
import 'package:supabase_test/supabase.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MySupabase.initializeDatabase();
  MyLocalStorage.initDatabase();
  initLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:   MyHomePage(),
    );
  }
}

 class MyHomePage extends StatefulWidget {
    MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final provider = locator<DataService>();


    

   navigateToListPage(){
     Navigator.push(context, MaterialPageRoute(builder: (context)  {
       return const AllContactsPage();
     }));
   }

   @override
  void initState() {
     //provider.saveIfNotSaved();
     read();
    super.initState();
  }

    read() async {
      //final read = await provider.getAContactWithLocalId(5);
     // print([read.phone, read.name]);
      //final read = await provider.getContactWithString('40ed64eb-1ca9-480a-8593-e93e322ab084');
    }

    @override
  void dispose() {
     super.dispose();
   }

   TextEditingController textController = TextEditingController();

    @override
   Widget build(BuildContext context) {
     return  Scaffold(
       body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           TextButton(
               onPressed: ( ) async {
                  navigateToListPage();
               },
               child: const Text('show contacts')),
         ],),
     );
   }
}
