import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/subscription_model.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _useIdr = true;

  static const String saweriaUrl = 'https://saweria.co/oziel12345';

  String _formatPrice(SubscriptionTier tier) {
    if (_useIdr) {
      final price = PricingConfig.indonesiaIdr[tier] ?? 0;
      if (price == 0) return 'Gratis';
      return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
    } else {
      final price = PricingConfig.globalUsd[tier] ?? 0;
      if (price == 0) return 'Free';
      return '\$${price.toStringAsFixed(0)}';
    }
  }

  String _formatOriginalPremiumPrice() {
    if (_useIdr) {
      return 'Rp ${PricingConfig.premiumOriginalIdr.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
    }
    return '\$${PricingConfig.premiumOriginalUsd.toStringAsFixed(0)}';
  }

  Future<void> _openSaweria() async {
    final uri = Uri.parse(saweriaUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Saweria link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Text('USD', style: TextStyle(fontSize: 12)),
                Switch(
                  value: _useIdr,
                  activeColor: const Color(0xFFff5722),
                  onChanged: (val) => setState(() => _useIdr = val),
                ),
                const Text('IDR', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Beta notice
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFff5722), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.rocket_launch, color: Color(0xFFff5722)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TopList is in Beta',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'All features are free during beta. PRO & PREMIUM subscriptions are coming soon.',
                          style: TextStyle(color: Color(0xFFb0b0b0), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _TierCard(
              title: 'Free',
              price: _formatPrice(SubscriptionTier.free),
              features: const [
                'Share unlimited music',
                'Rate & comment',
                'Follow creators',
                'Basic profile',
              ],
              enabled: true,
            ),
            const SizedBox(height: 16),

            _TierCard(
              title: 'Pro',
              price: _formatPrice(SubscriptionTier.pro),
              badge: 'PRO',
              features: const [
                'Everything in Free',
                'PRO badge on profile & comments',
                '2 custom chat bubble colors',
                '+2% feed visibility boost',
              ],
              enabled: false,
            ),
            const SizedBox(height: 16),

            _TierCard(
              title: 'Premium',
              price: _formatPrice(SubscriptionTier.premium),
              originalPrice: _formatOriginalPremiumPrice(),
              badge: 'PREM',
              featured: true,
              features: const [
                'Everything in Pro',
                'PREM badge on profile & comments',
                '3 custom chat bubble colors',
                '+5% feed visibility boost',
                'Create music albums',
              ],
              enabled: false,
            ),

            const SizedBox(height: 28),

            // Support / donation section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2a1a15), Color(0xFF1E1E1E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2a2a2a)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('☕', style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 12),
                  Text(
                    'Enjoying TopList?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Subscriptions aren\'t open yet, but you can support development directly. Every bit helps keep TopList running.',
                    style: TextStyle(color: Color(0xFFb0b0b0), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openSaweria,
                      icon: const Text('☕', style: TextStyle(fontSize: 16)),
                      label: const Text('Support on Saweria'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff5722),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Subscription status is verified by our servers. Badges cannot be unlocked by typing them in your name or comments.',
                style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final String title;
  final String price;
  final String? originalPrice;
  final String? badge;
  final bool featured;
  final bool enabled;
  final List<String> features;

  const _TierCard({
    required this.title,
    required this.price,
    this.originalPrice,
    this.badge,
    this.featured = false,
    this.enabled = true,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: featured ? const Color(0xFFff5722) : const Color(0xFF2a2a2a),
            width: featured ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featured)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFff5722),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'SPECIAL OFFER',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badge == 'PREM' ? const Color(0xFFFFC107) : const Color(0xFFC0C0C0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2a2a2a)),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (originalPrice != null) ...[
                  Text(
                    originalPrice!,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  price,
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                if (price != 'Free' && price != 'Gratis')
                  const Text('/month', style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 16, color: enabled ? const Color(0xFFff5722) : const Color(0xFF555555)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f, style: const TextStyle(color: Color(0xFFcccccc), fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: enabled && price != 'Free' && price != 'Gratis'
                    ? () {
                        // TODO: connect to platform billing when subscriptions launch
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: !enabled
                      ? const Color(0xFF666666)
                      : (featured ? Colors.white : const Color(0xFFff5722)),
                  backgroundColor: !enabled
                      ? Colors.transparent
                      : (featured ? const Color(0xFFff5722) : Colors.transparent),
                  disabledForegroundColor: const Color(0xFF666666),
                  side: BorderSide(
                    color: !enabled ? const Color(0xFF333333) : const Color(0xFF444444),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  !enabled
                      ? 'Coming Soon'
                      : (price == 'Free' || price == 'Gratis' ? 'Current Plan' : 'Choose $title'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
