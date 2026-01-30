import 'package:draftea_pokedex/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoInternetConnetion extends StatelessWidget {
  const NoInternetConnetion({
    required this.errorMessage,
    super.key,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/no-internet.png'),
            SizedBox(
              width: size.width * 0.6,
              child: Text(
                context.l10n.errorMessage(errorMessage),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: context.pop,
              child: Text(context.l10n.goBack),
            ),
          ],
        ),
      ),
    );
  }
}
