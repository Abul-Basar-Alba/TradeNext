import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main/main_navigation_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/products/products_list_screen.dart';
import '../screens/products/product_details_screen.dart';
import '../screens/products/create_product_screen.dart';
import '../screens/products/edit_product_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/my_ads_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/profile/favorites_screen.dart';
import '../providers/auth_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: '/', // Home screen first (Bikroy style)
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      // Protected routes - শুধু এগুলোতে login লাগবে
      final protectedRoutes = [
        '/create-product',
        '/products/edit',
        '/profile',
        '/profile/my-ads',
        '/profile/edit',
        '/profile/favorites',
        '/profile/settings',
      ];
      
      final isProtectedRoute = protectedRoutes.any(
        (route) => state.matchedLocation.startsWith(route),
      );
      
      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && isProtectedRoute) {
        return '/auth/login';
      }
      
      // If authenticated and trying to access auth routes
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }
      
      return null; // Guest mode allowed for other routes
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main Navigation with Bottom Bar
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      
      // Create Product
      GoRoute(
        path: '/create-product',
        name: 'create-product',
        builder: (context, state) => const CreateProductScreen(),
      ),
      
      // Product Routes
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'];
          final category = state.uri.queryParameters['category'];
          return ProductsListScreen(
            type: type,
            category: category,
          );
        },
      ),
      GoRoute(
        path: '/products/:id',
        name: 'product-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailsScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/products/:id/edit',
        name: 'edit-product',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditProductScreen(productId: id);
        },
      ),
      
      // Profile Routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/my-ads',
        name: 'my-ads',
        builder: (context, state) => const MyAdsScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
});
