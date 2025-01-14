import 'package:flutter/material.dart';
import 'package:littleflower/layouts/LoginHome.dart';
import 'package:littleflower/layouts/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAzz2lntnIRMRGTxvGqUGjYPVK9Zd0TxH0",
        authDomain: "littleflowerschoolapp.firebaseapp.com",
        projectId: "littleflowerschoolapp",
        storageBucket: "littleflowerschoolapp.firebasestorage.app",
        messagingSenderId: "743465373466",
        appId: "1:743465373466:web:17e645f781946e24cca6a3"),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalData(),
      child: const MainWidget(),
    ),
  );
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.outfitTextTheme(textTheme).copyWith(
            bodyMedium: GoogleFonts.outfit(textStyle: textTheme.bodyMedium),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginHome());
  }
}

class GlobalData extends ChangeNotifier {
  bool _isUserLoggedIn = false;

  bool get isUserLoggedIn => _isUserLoggedIn;

  void setIsUserLoggedIn(bool isUserLoggedIn) {
    _isUserLoggedIn = isUserLoggedIn;
    notifyListeners();
  }
}
