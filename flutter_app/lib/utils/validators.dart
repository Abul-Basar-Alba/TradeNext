class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ইমেইল প্রয়োজন';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'সঠিক ইমেইল লিখুন';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'পাসওয়ার্ড প্রয়োজন';
    }
    
    if (value.length < 8) {
      return 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'পাসওয়ার্ড নিশ্চিত করুন';
    }
    
    if (value != password) {
      return 'পাসওয়ার্ড মিলছে না';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'নাম প্রয়োজন';
    }
    
    if (value.length < 2) {
      return 'নাম কমপক্ষে ২ অক্ষরের হতে হবে';
    }
    
    return null;
  }

  // Phone validation (Bangladesh)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    final phoneRegex = RegExp(r'^(?:\+88)?01[3-9]\d{8}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'সঠিক ফোন নম্বর লিখুন (01XXXXXXXXX)';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName প্রয়োজন';
    }
    return null;
  }

  // Number validation
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName প্রয়োজন';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'সঠিক সংখ্যা লিখুন';
    }
    
    if (number <= 0) {
      return '$fieldName শূন্যের চেয়ে বড় হতে হবে';
    }
    
    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    return validateNumber(value, 'মূল্য');
  }

  // Title validation
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'শিরোনাম প্রয়োজন';
    }
    
    if (value.length < 5) {
      return 'শিরোনাম কমপক্ষে ৫ অক্ষরের হতে হবে';
    }
    
    if (value.length > 100) {
      return 'শিরোনাম সর্বোচ্চ ১০০ অক্ষরের হতে পারে';
    }
    
    return null;
  }

  // Description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'বিবরণ প্রয়োজন';
    }
    
    if (value.length < 20) {
      return 'বিবরণ কমপক্ষে ২০ অক্ষরের হতে হবে';
    }
    
    if (value.length > 1000) {
      return 'বিবরণ সর্বোচ্চ ১০০০ অক্ষরের হতে পারে';
    }
    
    return null;
  }
}
