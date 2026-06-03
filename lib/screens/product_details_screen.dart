import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../config/theme.dart';
import '../models/watch_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../data/static_data.dart';
import '../widgets/custom_button.dart';
import 'package:intl/intl.dart';

class ProductDetailsScreen extends StatefulWidget {
  final WatchModel watch;

  const ProductDetailsScreen({super.key, required this.watch});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _pageController = PageController();
  bool _showAllSpecs = false;
  bool _showAllReviews = false;

  final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductInfo(),
                _buildSpecifications(),
                _buildSellerInfo(),
                _buildReviews(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppTheme.backgroundColor,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Consumer<WishlistProvider>(
          builder: (context, wishlist, _) {
            final isInWishlist = wishlist.isInWishlist(widget.watch.id);
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : AppTheme.textPrimary,
                ),
                onPressed: () => wishlist.toggleWishlist(widget.watch),
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.watch.images.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 3.0,
                  child: CachedNetworkImage(
                    imageUrl: widget.watch.images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.surfaceColor,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.surfaceColor,
                      child: const Icon(
                        Icons.watch,
                        size: 80,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.watch.images.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                    dotColor: AppTheme.cardColor,
                    activeDotColor: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor),
                ),
                child: Text(
                  widget.watch.brand,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.watch.rating.toString(),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' (${widget.watch.reviewCount})',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.watch.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                currencyFormat.format(widget.watch.price),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.watch.inStock
                      ? AppTheme.successColor.withOpacity(0.1)
                      : AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.watch.inStock ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    color: widget.watch.inStock
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.watch.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    final specs = widget.watch.specifications.entries.toList();
    final displaySpecs = _showAllSpecs ? specs : specs.take(4).toList();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Specifications',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Icon(
                Icons.info_outline,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...displaySpecs.map((spec) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  spec.key,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                Text(
                  spec.value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
          if (specs.length > 4)
            TextButton(
              onPressed: () {
                setState(() {
                  _showAllSpecs = !_showAllSpecs;
                });
              },
              child: Text(
                _showAllSpecs ? 'Show Less' : 'Show More',
                style: const TextStyle(color: AppTheme.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.store,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.watch.sellerName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.watch.sellerInfo,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.verified,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    final reviews = StaticData.sampleReviews;
    final displayReviews = _showAllReviews ? reviews : reviews.take(2).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '${widget.watch.reviewCount} reviews',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...displayReviews.map((review) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['userName'] as String,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < (review['rating'] as int)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review['comment'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  review['date'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )),
          if (reviews.length > 2)
            TextButton(
              onPressed: () {
                setState(() {
                  _showAllReviews = !_showAllReviews;
                });
              },
              child: Text(
                _showAllReviews ? 'Show Less' : 'View All Reviews',
                style: const TextStyle(color: AppTheme.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Consumer<WishlistProvider>(
              builder: (context, wishlist, _) {
                final isInWishlist = wishlist.isInWishlist(widget.watch.id);
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.cardColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isInWishlist ? Colors.red : AppTheme.textSecondary,
                    ),
                    onPressed: () => wishlist.toggleWishlist(widget.watch),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cart, _) {
                  final isInCart = cart.isInCart(widget.watch.id);
                  return CustomButton(
                    text: isInCart ? 'In Cart' : 'Add to Cart',
                    onPressed: widget.watch.inStock
                        ? () {
                            if (!isInCart) {
                              cart.addToCart(widget.watch);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to cart'),
                                  backgroundColor: AppTheme.primaryColor,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          }
                        : null,
                    icon: isInCart ? Icons.check : Icons.shopping_bag_outlined,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}