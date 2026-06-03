import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/watch_model.dart';
import '../providers/wishlist_provider.dart';
import 'package:intl/intl.dart';

class WatchCard extends StatelessWidget {
  final WatchModel watch;
  final bool isCompact;

  const WatchCard({
    super.key,
    required this.watch,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetails,
          arguments: watch,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: isCompact ? 3 : 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: watch.images.first,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.cardColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.cardColor,
                        child: const Icon(
                          Icons.watch,
                          size: 40,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  if (!isCompact)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Consumer<WishlistProvider>(
                        builder: (context, wishlist, _) {
                          final isInWishlist = wishlist.isInWishlist(watch.id);
                          return GestureDetector(
                            onTap: () => wishlist.toggleWishlist(watch),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundColor.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isInWishlist ? Icons.favorite : Icons.favorite_border,
                                color: isInWishlist ? Colors.red : AppTheme.textPrimary,
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (!watch.inStock)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Sold Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: isCompact ? 2 : 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          watch.brand,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: isCompact ? 10 : 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          watch.name,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: isCompact ? 12 : 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: isCompact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currencyFormat.format(watch.price),
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: isCompact ? 12 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isCompact)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                watch.rating.toString(),
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}