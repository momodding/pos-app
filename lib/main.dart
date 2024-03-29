import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_posresto_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_posresto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_posresto_app/presentation/auth/login_page.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/local_product/local_product_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/order/order_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_posresto_app/presentation/report/bloc/transaction_report/transaction_report_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/discount/discount_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_product/sync_product_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => SyncProductBloc(ProductRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => LocalProductBloc(ProductLocalDataSource.instance),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => DiscountBloc(DiscountRemoteDataSource()),
        ),
        BlocProvider(
          create: (context) => TransactionReportBloc(ProductLocalDataSource.instance),
        ),
      ],
      child: MaterialApp(
        title: 'POS Farma Apotek',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.primary,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
            future: AuthLocalDataSource().isAuthDataExists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data == true) {
                return const DashboardPage();
              } else if (snapshot.hasData && snapshot.data == false) {
                return const LoginPage();
              }
              return const Scaffold(
                body: Center(
                  child: Text('Error'),
                ),
              );
            }),
      ),
    );
  }
}
