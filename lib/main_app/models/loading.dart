import 'package:flutter/material.dart';
import '../main_app_theme.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MainAppTheme.bottomBar),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
