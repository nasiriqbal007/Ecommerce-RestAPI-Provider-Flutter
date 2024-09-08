import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_api/provider/favorite_provider.dart';
import 'package:store_api/provider/product_provider.dart';
import 'package:store_api/utils/dialogbox.dart';
import 'package:store_api/widgets/favorite_list_tile.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            onPressed: () async {
              final favoriteProvider =
                  Provider.of<FavoriteProvider>(context, listen: false);

              if (!favoriteProvider.isLoading) {
                bool? result = await showDialogBox(
                    context,
                    "Remove from Favorites",
                    "Are you sure you want to remove all items from the favorites?");
                if (result == true) {
                  favoriteProvider.removeAllFromFavorite();
                }
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final productProvider = Provider.of<ProductProvider>(context);

          if (favoriteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteProducts = productProvider.products
              .where((product) => favoriteProvider.isFavorite(product.id))
              .toList();

          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.errorMessage != null) {
            return Center(
              child: Text('Error: ${productProvider.errorMessage}'),
            );
          }

          return favoriteProducts.isEmpty
              ? Center(
                  child: Text(
                    'No favorite products',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoriteProducts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: FavoriteCartTile(
                        products: product,
                        favoriteProvider: favoriteProvider,
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
