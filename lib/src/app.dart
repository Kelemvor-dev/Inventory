import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory/src/models/repository/products.dart';
import 'package:provider/provider.dart';

import '../api/notification_api.dart';
import '../constants.dart';
import 'models/entity/inventoryProducts.dart';
import 'models/entity/products.dart';
import 'models/providers/profile.dart';
import 'models/repository/firebaseAuthMethods.dart';
import 'views/screens/home.dart';
import 'views/screens/login.dart';
import 'views/screens/product/createProduct.dart';
import 'views/screens/product/editProduct.dart';
import 'views/screens/product/labelProductScreen.dart';
import 'views/screens/users/editProfile.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        Provider<Products>(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileData(),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        StreamProvider<List<ProductsModel>>(
          create: (_) => Products().getProductsByUserID(),
          initialData: const [],
        ),
        ChangeNotifierProvider(create: (_) => NotificationApi())
      ],
      child: MaterialApp(
        title: 'Inventory',
        theme: ThemeData(
          primarySwatch: UiColors.kToWhite,
        ),
        initialRoute: 'home',
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (context) => const AuthWrapper(),
          'editProfile': (context) => const EditProfileScreen(),
          'createProduct': (context) => const CreateProductScreen(),
          'editProduct': (context) => const EditProductScreen(),
          'labelProduct': (context) => const LabelProductScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const Home();
    }
    return const Login();
  }
}
