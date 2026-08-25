enum SubscriptionTier { free, pro, premium }
enum SubscriptionStatus { active, expired, cancelled }

class SubscriptionModel {
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final DateTime? startedAt;
  final DateTime? expiresAt;

  SubscriptionModel({
    this.tier = SubscriptionTier.free,
    this.status = SubscriptionStatus.active,
    this.startedAt,
    this.expiresAt,
  });

  // Badge label shown next to username. Free users get no badge.
  // This is the ONLY place badge text is derived — never trust client-typed text.
  String? get badgeLabel {
    if (status != SubscriptionStatus.active) return null;
    switch (tier) {
      case SubscriptionTier.pro:
        return 'PRO';
      case SubscriptionTier.premium:
        return 'PREM';
      case SubscriptionTier.free:
        return null;
    }
  }

  bool get isPro => tier == SubscriptionTier.pro && status == SubscriptionStatus.active;
  bool get isPremium => tier == SubscriptionTier.premium && status == SubscriptionStatus.active;
  bool get isActive => status == SubscriptionStatus.active;

  // Number of custom chat bubble colors allowed per tier
  int get chatBubbleColorCount {
    switch (tier) {
      case SubscriptionTier.free:
        return 1;
      case SubscriptionTier.pro:
        return 2;
      case SubscriptionTier.premium:
        return 3;
    }
  }

  // FYP visibility boost percentage
  double get fypBoostPercent {
    switch (tier) {
      case SubscriptionTier.free:
        return 0.0;
      case SubscriptionTier.pro:
        return 2.0;
      case SubscriptionTier.premium:
        return 5.0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'status': status.name,
      'startedAt': startedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubscriptionModel();

    // Migration safety: old data may have "vip" stored as tier name
    String tierRaw = (json['tier'] ?? 'free').toString().toLowerCase();
    if (tierRaw == 'vip') tierRaw = 'premium';

    var tier = SubscriptionTier.values.firstWhere(
      (e) => e.name == tierRaw,
      orElse: () => SubscriptionTier.free,
    );

    var status = SubscriptionStatus.values.firstWhere(
      (e) => e.name == (json['status'] ?? 'active'),
      orElse: () => SubscriptionStatus.active,
    );

    final expiresAt = json['expiresAt'] != null
        ? DateTime.tryParse(json['expiresAt'])
        : null;

    // Auto-downgrade expired subscriptions to free on read
    if (expiresAt != null && expiresAt.isBefore(DateTime.now())) {
      status = SubscriptionStatus.expired;
      tier = SubscriptionTier.free;
    }

    return SubscriptionModel(
      tier: tier,
      status: status,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'])
          : null,
      expiresAt: expiresAt,
    );
  }
}

// Pricing configuration — single source of truth, not hardcoded per screen.
class PricingConfig {
  static const Map<SubscriptionTier, double> globalUsd = {
    SubscriptionTier.free: 0,
    SubscriptionTier.pro: 5,
    SubscriptionTier.premium: 10,
  };

  static const double premiumOriginalUsd = 15;

  // Indonesia special pricing (configured, not a blind $ -> Rp swap)
  static const Map<SubscriptionTier, int> indonesiaIdr = {
    SubscriptionTier.free: 0,
    SubscriptionTier.pro: 45000,
    SubscriptionTier.premium: 79000,
  };

  static const int premiumOriginalIdr = 119000;
}
