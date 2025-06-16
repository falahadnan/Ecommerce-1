import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'components/wallet_balance_card.dart';

class EmptyWalletScreen extends StatelessWidget {
  const EmptyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔷 كارت الرصيد
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: WalletBalanceCard(
                balance: 0.00,
                onTabChargeBalance: () {
                  print("شحن الرصيد");
                },
              ),
            ),

            const Spacer(flex: 2),

            // 🔷 صورة فارغة
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/Illustration/EmptyState_lightTheme.png"
                  : "assets/Illustration/EmptyState_darkTheme.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),

            const Spacer(),

            // 🔷 عنوان
            Text(
              "ما عندكش عمليات فالمحفظة",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            // 🔷 وصف
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical: defaultPadding,
              ),
              child: Text(
                "بدا بشراء المنتجات باش تشوف العمليات هنا. المحفظة غادي تعاونك تراقب المصاريف ديالك بكل سهولة.",
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
