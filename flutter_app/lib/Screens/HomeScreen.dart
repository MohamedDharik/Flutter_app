import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/product_provider.dart';
import '../widgets/productItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  int _currentBanner = 0;
  final PageController _bannerController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch products after the first frame is drawn
      print('Fetching products...');
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts()
          .then((_) {
            print('Products fetched!');
            setState(() => _isLoading = false);
          })
          .catchError((e) {
            print('Error fetching products: $e');
            setState(() => _isLoading = false);
          });
    });

    // Auto-scroll banner
    _startBannerTimer();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_bannerController.hasClients) {
        if (_currentBanner < 2) {
          _currentBanner++;
        } else {
          _currentBanner = 0;
        }
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        _startBannerTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;
        final theme = Theme.of(context);
        final size = MediaQuery.of(context).size;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'MyKart',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/add'),
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: const Icon(Icons.shopping_cart),
              ),
            ],
            elevation: 0,
          ),
          body:
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : products.isEmpty
                  ? _buildEmptyState()
                  : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Promo Banner Slider
                      SliverToBoxAdapter(
                        child: Container(
                          height: size.height * 0.2,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PageView(
                            controller: _bannerController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentBanner = index;
                              });
                            },
                            children: [
                              _buildPromoBanner(
                                theme,
                                'Summer Sale',
                                'Up to 50% OFF',
                                Colors.orange,
                              ),
                              _buildPromoBanner(
                                theme,
                                'New Arrivals',
                                'Shop the latest trends',
                                Colors.blue,
                              ),
                              _buildPromoBanner(
                                theme,
                                'Free Shipping',
                                'On orders over \$50',
                                Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Banner indicator
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _currentBanner == index
                                        ? theme.primaryColor
                                        : Colors.grey[300],
                              ),
                            );
                          }),
                        ),
                      ),
                      // Categories
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildCategoryChip('All', true),
                                _buildCategoryChip('Electronics', false),
                                _buildCategoryChip('Fashion', false),
                                _buildCategoryChip('Home', false),
                                _buildCategoryChip('Beauty', false),
                                _buildCategoryChip('Sports', false),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Section Header
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Popular Products',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('See All'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Products Grid
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return ProductItem(product: products[index]);
                          }, childCount: products.length),
                        ),
                      ),
                    ],
                  ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
            backgroundColor: theme.primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No products available.',
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }

  Widget _buildPromoBanner(
    ThemeData theme,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.black87),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Shop Now',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Chip(
        label: Text(label),
        backgroundColor:
            isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side:
              isSelected
                  ? BorderSide(color: Theme.of(context).primaryColor)
                  : BorderSide.none,
        ),
      ),
    );
  }
}
