import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/auth_response_model.dart';
import 'package:flutter_posresto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_posresto_app/presentation/auth/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? user;

  @override
  void initState() {
    AuthLocalDataSource().getAuthData().then((value) {
      setState(() {
        user = value.user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Welcome to Dashboard'),
              Text('Name: ${user?.name ?? ''}'),
              const SizedBox(height: 100),
              BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  state.maybeWhen(
                      orElse: () {},
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          backgroundColor: AppColors.red,
                        ));
                      },
                      success: () {
                        AuthLocalDataSource().removeAuthData();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Logout Success'),
                          backgroundColor: AppColors.primary,
                        ));
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }));
                      });
                },
                child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<LogoutBloc>()
                          .add(const LogoutEvent.logout());
                    },
                    child: const Text('Logout')),
              )
            ],
          ),
        ));
  }
}
