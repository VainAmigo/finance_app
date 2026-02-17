import 'package:finance_app/data/data.dart';
import 'package:finance_app/firebase_options.dart';
import 'package:finance_app/l10n/l10.dart';
import 'package:finance_app/presentation/presentaion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppView());
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(userRepository: UserRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit(
            categoryRepository: CategoryRepositoryImpl(),
            subCategoryRepository: SubCategoryRepositoryImpl(),
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ],
        child: const FinanceApp(),
      ),
    );
  }
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      title: 'Finance Tracker',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeProvider.locale,
      theme: AppThemes.themeFor(themeProvider.state.palette, Brightness.light),
      darkTheme: AppThemes.themeFor(
        themeProvider.state.palette,
        Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: AppRouter.auth,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
