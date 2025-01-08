import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configs/routes/routes_name.dart';
import '../view_model/splash_view_model.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel()..loadData(),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isLoading && viewModel.token != "" && viewModel.isProfileDone) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(context, RoutesName.bottomNav, (Route<dynamic> route) => false);
            });
          }
          else if (!viewModel.isLoading && viewModel.token != "" && !viewModel.isProfileDone) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, RoutesName.login);
              //Navigator.pushNamed(context, RoutesName.createProfile, arguments: {'isEdit': false});
            });
          }
          else if (!viewModel.isLoading && viewModel.token == "" && !viewModel.isProfileDone){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, RoutesName.onboard);
            });
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

