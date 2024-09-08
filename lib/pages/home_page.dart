// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_api/pages/cart_page.dart';
import 'package:store_api/pages/favorite_page.dart';
import 'package:store_api/provider/product_provider.dart';
import 'package:store_api/widgets/my_drawer.dart';
import 'package:store_api/widgets/product_card.dart';
import 'package:store_api/widgets/search_sort.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Home',
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritePage())),
              icon: Icon(
                Icons.favorite,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage())),
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(08.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchAndSort(),
                Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                  return _handleProductFetch(productProvider);
                }),
              ],
            ),
          ),
        ),
        drawer: MyDrawer());
  }

  Widget _handleProductFetch(ProductProvider productProvider) {
    if (productProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (productProvider.errorMessage != null) {
      return Center(child: Text('Error: ${productProvider.errorMessage}'));
    } else if (productProvider.products.isEmpty) {
      return Center(child: Text('No products found'));
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.57,
        ),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: productProvider.products.length,
        itemBuilder: (context, index) {
          final product = productProvider.products[index];
          return ProductCard(product: product);
        },
      );
    }
  }
}
