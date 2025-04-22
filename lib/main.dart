import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Category {
  final String name;
  final IconData icon;
  final List<Product> products;

  Category({required this.name, required this.icon, required this.products});
}

class Product {
  final String name;
  final double price;
  final String description;
  final String category;

  Product({
    required this.name, 
    required this.price, 
    this.description = '', 
    required this.category
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String searchQuery = '';
  String selectedCategory = 'All';

  // Sample category data
  static final List<Category> categories = [
    Category(
      name: 'Computers',
      icon: Icons.computer,
      products: [
        Product(name: 'Gaming Laptop', price: 1299.99, category: 'Computers', description: 'High-performance gaming laptop with RGB keyboard'),
        Product(name: 'Business Laptop', price: 999.99, category: 'Computers', description: 'Lightweight business laptop with long battery life'),
        Product(name: 'Desktop PC', price: 899.99, category: 'Computers', description: 'Powerful desktop computer for office work'),
        Product(name: 'Chromebook', price: 349.99, category: 'Computers', description: 'Affordable laptop for web browsing and basic tasks'),
        Product(name: 'Workstation', price: 1899.99, category: 'Computers', description: 'Professional workstation for content creation'),
      ],
    ),
    Category(
      name: 'Phones',
      icon: Icons.smartphone,
      products: [
        Product(name: 'iPhone 15', price: 999.99, category: 'Phones', description: 'Latest Apple smartphone with advanced camera'),
        Product(name: 'Samsung Galaxy', price: 899.99, category: 'Phones', description: 'Premium Android smartphone with large display'),
        Product(name: 'Google Pixel', price: 799.99, category: 'Phones', description: 'Android smartphone with exceptional camera quality'),
        Product(name: 'Budget Phone', price: 299.99, category: 'Phones', description: 'Affordable smartphone with good performance'),
        Product(name: 'Foldable Phone', price: 1499.99, category: 'Phones', description: 'Innovative foldable smartphone with dual screens'),
      ],
    ),
    Category(
      name: 'Audio',
      icon: Icons.headphones,
      products: [
        Product(name: 'Wireless Headphones', price: 249.99, category: 'Audio', description: 'Premium noise-canceling wireless headphones'),
        Product(name: 'Earbuds', price: 149.99, category: 'Audio', description: 'Compact wireless earbuds with charging case'),
        Product(name: 'Bluetooth Speaker', price: 129.99, category: 'Audio', description: 'Portable Bluetooth speaker with deep bass'),
        Product(name: 'Home Theater', price: 499.99, category: 'Audio', description: 'Complete home theater sound system'),
        Product(name: 'Soundbar', price: 199.99, category: 'Audio', description: 'Slim soundbar for enhanced TV audio'),
      ],
    ),
    Category(
      name: 'Accessories',
      icon: Icons.devices_other,
      products: [
        Product(name: 'Wireless Mouse', price: 39.99, category: 'Accessories', description: 'Ergonomic wireless mouse with long battery life'),
        Product(name: 'Mechanical Keyboard', price: 89.99, category: 'Accessories', description: 'Mechanical gaming keyboard with RGB lighting'),
        Product(name: 'Monitor', price: 299.99, category: 'Accessories', description: '27-inch 4K monitor with HDR support'),
        Product(name: 'USB Hub', price: 29.99, category: 'Accessories', description: 'Multi-port USB hub with fast charging'),
        Product(name: 'External SSD', price: 119.99, category: 'Accessories', description: 'Fast external SSD for data storage'),
      ],
    ),
    Category(
      name: 'Wearables',
      icon: Icons.watch,
      products: [
        Product(name: 'Smartwatch', price: 249.99, category: 'Wearables', description: 'Advanced smartwatch with health tracking features'),
        Product(name: 'Fitness Tracker', price: 99.99, category: 'Wearables', description: 'Waterproof fitness tracker with heart rate monitor'),
        Product(name: 'Smart Ring', price: 299.99, category: 'Wearables', description: 'Smart ring with health monitoring capabilities'),
        Product(name: 'Smart Glasses', price: 399.99, category: 'Wearables', description: 'AR-enabled smart glasses with voice control'),
        Product(name: 'VR Headset', price: 349.99, category: 'Wearables', description: 'Immersive virtual reality headset'),
      ],
    ),
  ];
  
  // Get all products from all categories
  List<Product> get allProducts {
    List<Product> products = [];
    for (var category in categories) {
      products.addAll(category.products);
    }
    return products;
  }
  
  // Filter products based on search query and selected category
  List<Product> get filteredProducts {
    List<Product> result = [];
    
    if (selectedCategory == 'All') {
      result = allProducts;
    } else {
      for (var category in categories) {
        if (category.name == selectedCategory) {
          result = category.products;
          break;
        }
      }
    }
    
    if (searchQuery.isNotEmpty) {
      result = result.where((product) => 
        product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        product.description.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          
          // Category filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: [
                // All categories option
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: selectedCategory == 'All',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = 'All';
                        });
                      }
                    },
                  ),
                ),
                // Individual category options
                ...categories.map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    avatar: Icon(category.icon, size: 18),
                    label: Text(category.name),
                    selected: selectedCategory == category.name,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category.name;
                        });
                      }
                    },
                  ),
                )).toList(),
              ],
            ),
          ),
          
          // Product grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3/2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Chip(
                      label: Text(product.category),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (product.description.isNotEmpty) ...[  
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
