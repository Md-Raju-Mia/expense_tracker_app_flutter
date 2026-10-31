// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get yourFeed => 'আপনার ফিড';

  @override
  String get feedIntro => 'গল্প, ভাবনা ও আলোচনা আবিষ্কার করুন।';

  @override
  String feedAuthor(int id) {
    return 'ব্যবহারকারী $id';
  }

  @override
  String get publicPost => 'সবার জন্য পোস্ট';

  @override
  String feedLikes(String count) {
    return '$count লাইক';
  }

  @override
  String feedDislikes(String count) {
    return '$count ডিসলাইক';
  }

  @override
  String feedViews(String count) {
    return '$count বার দেখা';
  }

  @override
  String get readPost => 'পোস্ট পড়ুন';

  @override
  String get comments => 'মন্তব্য';

  @override
  String get copyPostLink => 'লিংক কপি';

  @override
  String get postLinkCopied => 'পোস্টের লিংক কপি হয়েছে';

  @override
  String get refreshFeed => 'ফিড রিফ্রেশ';

  @override
  String get clearFilter => 'ফিল্টার মুছুন';

  @override
  String get loadingPosts => 'পোস্ট লোড হচ্ছে';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get noPosts => 'পোস্ট পাওয়া যায়নি। অন্য শব্দ দিয়ে খুঁজুন।';

  @override
  String get noComments => 'এখনো কোনো মন্তব্য নেই।';

  @override
  String get feedEnd => 'সব পোস্ট দেখা হয়েছে';

  @override
  String get pageNotFound => 'পৃষ্ঠাটি পাওয়া যায়নি';

  @override
  String get loading => 'লোড হচ্ছে';

  @override
  String get operation => 'কার্যক্রম';

  @override
  String operationFailed(String operation) {
    return '$operation ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';
  }

  @override
  String get networkTimeout => 'অনুরোধের সময়সীমা শেষ হয়েছে।';

  @override
  String get networkConnection => 'সার্ভারের সঙ্গে সংযোগ করা যায়নি।';

  @override
  String get networkCancelled => 'অনুরোধটি বাতিল করা হয়েছে।';

  @override
  String get networkCertificate => 'সার্ভারের পরিচয় যাচাই করা যায়নি।';

  @override
  String get networkUnauthorized => 'পরিচয় যাচাই প্রয়োজন।';

  @override
  String get networkForbidden => 'এই অনুরোধের জন্য আপনার অনুমতি নেই।';

  @override
  String get networkNotFound => 'অনুরোধ করা তথ্য পাওয়া যায়নি।';

  @override
  String get networkRateLimited =>
      'অনেক বেশি অনুরোধ করা হয়েছে। কিছুক্ষণ পরে আবার চেষ্টা করুন।';

  @override
  String get networkServer => 'সার্ভার অনুরোধটি সম্পন্ন করতে পারেনি।';

  @override
  String get networkResponse => 'অনুরোধটি প্রত্যাখ্যান করা হয়েছে।';

  @override
  String get networkInvalidData => 'সার্ভার থেকে অবৈধ তথ্য পাওয়া গেছে।';

  @override
  String get appTitle => 'পোস্ট';

  @override
  String get goToPosts => 'পোস্টে যান';

  @override
  String get explorerIntro =>
      'একটি অপারেশন বেছে তথ্য দিন, তারপর আসল HTTP অনুরোধ পাঠান। নিচে অনুরোধ ও JSON উত্তর দেখুন।';

  @override
  String get simulatedWrites =>
      'DummyJSON লেখার অনুকরণ করে। যোগ, পরিবর্তন ও মুছে ফেলা উত্তর দেয় কিন্তু সার্ভারের তথ্য বদলায় না। আবার পড়লে মূল তথ্য পাবেন।';

  @override
  String get listPosts => 'পোস্টের তালিকা';

  @override
  String get singlePost => 'একটি পোস্ট';

  @override
  String get searchPosts => 'পোস্ট খুঁজুন';

  @override
  String get postTags => 'ট্যাগ দেখুন';

  @override
  String get tagList => 'ট্যাগের নাম';

  @override
  String get postsByTag => 'ট্যাগ অনুযায়ী পোস্ট';

  @override
  String get postsByUser => 'ব্যবহারকারীর পোস্ট';

  @override
  String get postComments => 'পোস্টের মন্তব্য';

  @override
  String get addPost => 'পোস্ট যোগ';

  @override
  String get updatePost => 'পোস্ট পরিবর্তন';

  @override
  String get deletePost => 'পোস্ট মুছুন';

  @override
  String get postId => 'পোস্ট আইডি';

  @override
  String get userId => 'ব্যবহারকারী আইডি';

  @override
  String get searchQuery => 'খোঁজার শব্দ';

  @override
  String get tag => 'ট্যাগ স্লাগ (যেমন life)';

  @override
  String get pageLimit => 'সীমা (০ = সব ফলাফল)';

  @override
  String get pageSkip => 'এড়িয়ে যাওয়া ফলাফলের সংখ্যা';

  @override
  String get selectFields => 'ফিল্ড (কমা দিয়ে আলাদা; খালি = সব)';

  @override
  String get sortBy => 'সাজানোর ফিল্ড';

  @override
  String get sortOrder => 'সাজানোর ক্রম';

  @override
  String get ascending => 'ঊর্ধ্বক্রম';

  @override
  String get descending => 'অধঃক্রম';

  @override
  String get postTitle => 'শিরোনাম';

  @override
  String get postBody => 'লেখা';

  @override
  String get sendRequest => 'অনুরোধ পাঠান';

  @override
  String get sendWrite => 'অনুকরণমূলক পরিবর্তন পাঠান';

  @override
  String get lastRequest => 'সর্বশেষ অনুরোধ';

  @override
  String get responseJson => 'উত্তরের JSON দেখুন';

  @override
  String get noResults => 'কোনো ফলাফল নেই। অন্য তথ্য দিয়ে চেষ্টা করুন।';

  @override
  String get previousResponse =>
      'অনুরোধ ব্যর্থ। আগের সফল উত্তর নিচে দেখানো হয়েছে।';

  @override
  String get requiredField => 'একটি মান দিন।';

  @override
  String invalidNumber(int minimum) {
    return 'অন্তত $minimum পূর্ণসংখ্যা দিন।';
  }

  @override
  String responseStatus(int status) {
    return 'উত্তর · HTTP $status';
  }

  @override
  String get expenseAddTask => 'যোগ করুন';

  @override
  String get expenseCancel => 'বাতিল';

  @override
  String get expenseDelete => 'মুছুন';

  @override
  String get expenseDeletePrompt => 'আপনি কি এই লেনদেন মুছতে চান?';

  @override
  String get expenseDeleteTitle => 'লেনদেন মুছুন';

  @override
  String get expenseExpenses => 'ব্যয়';

  @override
  String get expenseIncome => 'আয়';

  @override
  String get expenseNoTransactions => 'এখনো কোনো লেনদেন নেই!';

  @override
  String get expenseRecentTransactions => 'সাম্প্রতিক লেনদেন';

  @override
  String get expenseSeeAll => 'সব দেখুন';

  @override
  String get expenseSpendingAnalysis => 'ব্যয়ের বিশ্লেষণ';

  @override
  String get expenseSpent => 'ব্যয় হয়েছে';

  @override
  String get expenseTotalBalance => 'মোট ব্যালেন্স';

  @override
  String get expenseTrackerTitle => 'আয় ব্যয়ের হিসাব';

  @override
  String get expenseAddTransaction => 'লেনদেন যোগ করুন';

  @override
  String get expenseAmount => 'পরিমাণ';

  @override
  String get expenseAmountInvalid =>
      'শূন্যের বেশি অঙ্ক লিখুন (সর্বোচ্চ ২ ঘর দশমিক)।';

  @override
  String get expenseCategory => 'বিভাগ';

  @override
  String get expenseDate => 'তারিখ';

  @override
  String get expenseGoHome => 'হিসাবে ফিরে যান';

  @override
  String get expenseSaveTransaction => 'লেনদেন সংরক্ষণ করুন';

  @override
  String get expenseTitle => 'শিরোনাম';

  @override
  String get expenseTitleRequired => 'একটি শিরোনাম লিখুন';

  @override
  String get expenseTransactionType => 'লেনদেনের ধরন';

  @override
  String get expenseTypeExpense => 'ব্যয়';

  @override
  String get preferencesCountry => 'দেশ';

  @override
  String get preferencesCountryBD => 'বাংলাদেশ';

  @override
  String get preferencesCountryHint =>
      'দেশ বাছলে মুদ্রা ও ভাষা প্রস্তাব করা হবে। নিচে দুটোই আলাদাভাবে বদলাতে পারবেন।';

  @override
  String get preferencesCountryIN => 'ভারত';

  @override
  String get preferencesCountryUS => 'যুক্তরাষ্ট্র';

  @override
  String get preferencesCurrency => 'পছন্দের মুদ্রা';

  @override
  String get preferencesCurrencyBDT => 'বাংলাদেশি টাকা (BDT)';

  @override
  String get preferencesCurrencyHint =>
      'এই পছন্দ বদলালে আগের লেনদেনের টাকার অঙ্ক রূপান্তর হবে না।';

  @override
  String get preferencesCurrencyINR => 'ভারতীয় রুপি (INR)';

  @override
  String get preferencesCurrencyUSD => 'মার্কিন ডলার (USD)';

  @override
  String get preferencesIntro =>
      'দেশ বেছে নিন, তারপর নিজের সুবিধামতো মুদ্রা ও ভাষা ঠিক করুন।';

  @override
  String get preferencesLanguage => 'অ্যাপের ভাষা';

  @override
  String get preferencesLanguageBN => 'বাংলা';

  @override
  String get preferencesLanguageEN => 'English';

  @override
  String get preferencesSave => 'পছন্দ সংরক্ষণ করুন';

  @override
  String get preferencesStorageError =>
      'পছন্দ লোড বা সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get preferencesSupportHint =>
      'এখন বাংলাদেশ, ভারত ও যুক্তরাষ্ট্র এবং বাংলা ও English সমর্থিত।';

  @override
  String get preferencesTitle => 'আপনার পছন্দ';

  @override
  String get preferencesAppBar => 'সেটিংস';

  @override
  String get expenseAllCurrencies =>
      'সাম্প্রতিক লেনদেনে প্রতিটির নিজস্ব মুদ্রা দেখানো হয়েছে।';

  @override
  String expenseAmountCurrency(String currency) {
    return 'পরিমাণ ($currency)';
  }

  @override
  String get expenseCategoryEntertainment => 'বিনোদন';

  @override
  String get expenseCategoryFood => 'খাবার';

  @override
  String get expenseCategoryHealth => 'স্বাস্থ্য';

  @override
  String get expenseCategoryIncome => 'আয়';

  @override
  String get expenseCategoryOthers => 'অন্যান্য';

  @override
  String expenseCategoryPercent(String category, String percent) {
    return '$category: $percent%';
  }

  @override
  String get expenseCategoryShopping => 'কেনাকাটা';

  @override
  String get expenseCategoryTransport => 'যাতায়াত';

  @override
  String expenseTotalsCurrency(String currency) {
    return '$currency-এ মোট হিসাব';
  }

  @override
  String get expenseAmountHint => 'যেমন: ১২৫০.৫০ (কমা ছাড়া)';

  @override
  String expenseAmountTooLarge(String maximum) {
    return '$maximum-এর বেশি অঙ্ক দেওয়া যাবে না।';
  }
}
