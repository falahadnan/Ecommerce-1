import 'package:flutter/material.dart';
import '../../../../constants.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.onTabChargeBalance,
  });

  final double balance;
  final VoidCallback onTabChargeBalance;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Column(
        children: [
          // 🔷 الجزء اللي فيه الرصيد
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadious),
                  topRight: Radius.circular(defaultBorderRadious),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "رصيدك الحالي",
                    style: TextStyle(
                      color: whiteColor80,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    "\$${balance.toStringAsFixed(2)}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          ),

          // 🔷 زر الشحن
          ElevatedButton(
            onPressed: onTabChargeBalance,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9581FF),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(defaultBorderRadious),
                  bottomRight: Radius.circular(defaultBorderRadious),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              "+ شحن الرصيد",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
