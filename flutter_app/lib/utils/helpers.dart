import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Helpers {
  // Format price in Bengali
  static String formatPrice(double price, {bool showSymbol = true}) {
    final symbol = showSymbol ? '৳' : '';
    
    if (price >= 10000000) {
      // Crore
      return '$symbol${(price / 10000000).toStringAsFixed(1)} কোটি';
    } else if (price >= 100000) {
      // Lakh
      return '$symbol${(price / 100000).toStringAsFixed(1)} লক্ষ';
    } else if (price >= 1000) {
      // Thousand (k)
      return '$symbol${(price / 1000).toStringAsFixed(0)}k';
    } else {
      return '$symbol${price.toStringAsFixed(0)}';
    }
  }

  // Format date in Bengali
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'আজ ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'গতকাল ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  // Time ago in Bengali
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'এইমাত্র';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘণ্টা আগে';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} সপ্তাহ আগে';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} মাস আগে';
    } else {
      return '${(difference.inDays / 365).floor()} বছর আগে';
    }
  }

  // Format views count
  static String formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }

  // Convert English digits to Bengali
  static String toBengaliDigits(String text) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    for (int i = 0; i < english.length; i++) {
      text = text.replaceAll(english[i], bengali[i]);
    }

    return text;
  }

  // Show error message
  static String getErrorMessage(dynamic error) {
    if (error.toString().contains('ইন্টারনেট')) {
      return 'ইন্টারনেট সংযোগ নেই। দয়া করে আপনার সংযোগ পরীক্ষা করুন।';
    } else if (error.toString().contains('অনুমতি')) {
      return 'আপনার অনুমতি নেই। আবার লগইন করুন।';
    } else if (error.toString().contains('সময়')) {
      return 'সংযোগের সময় শেষ হয়ে গেছে। আবার চেষ্টা করুন।';
    } else {
      return error.toString();
    }
  }

  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  // Get category icon
  static String getCategoryIcon(String category) {
    switch (category) {
      case 'vehicles':
        return '🚗';
      case 'property':
        return '🏠';
      case 'electronics':
        return '📱';
      case 'fashion':
        return '👕';
      case 'furniture':
        return '🪑';
      case 'event-equipment':
        return '🎪';
      default:
        return '📦';
    }
  }

  // Validate image size
  static bool isImageSizeValid(int sizeInBytes) {
    const maxSizeInBytes = 2 * 1024 * 1024; // 2MB
    return sizeInBytes <= maxSizeInBytes;
  }

  // Format phone number
  static String formatPhoneNumber(String phone) {
    // Remove +88 if present
    phone = phone.replaceAll('+88', '');
    
    // Format as 01XXX-XXXXXX
    if (phone.length == 11) {
      return '${phone.substring(0, 5)}-${phone.substring(5)}';
    }
    
    return phone;
  }

  // Hide phone number partially
  static String hidePhoneNumber(String phone) {
    if (phone.length >= 11) {
      return '${phone.substring(0, 5)}***${phone.substring(phone.length - 2)}';
    }
    return phone;
  }
}
