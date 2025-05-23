import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src/theme/themes_app.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ctrlTheme = Provider.of<ThemeApp>(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            ctrlTheme.primaryColor,
            ctrlTheme.secondaryColor,
          ],
        ),
      ),
    );
  }
}
