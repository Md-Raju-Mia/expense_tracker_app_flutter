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

  @override
  String get categoriesTitle => 'বিভাগ পরিচালনা';

  @override
  String get categoriesDescription =>
      'নিজের সুবিধামতো বিভাগের নাম, আইকন ও রং বেছে নিন।';

  @override
  String get categoriesAdd => 'বিভাগ যোগ করুন';

  @override
  String get categoriesEdit => 'বিভাগ সম্পাদনা';

  @override
  String get categoriesSave => 'বিভাগ সংরক্ষণ করুন';

  @override
  String get categoriesName => 'বিভাগের নাম';

  @override
  String get categoriesNameInvalid => '১–৬০ অক্ষরের একটি নাম লিখুন।';

  @override
  String get categoriesType => 'লেনদেনের ধরন';

  @override
  String get categoriesTypeFixed =>
      'তৈরি করার পরে লেনদেনের ধরন বদলানো যাবে না।';

  @override
  String get categoriesIcon => 'আইকন';

  @override
  String get categoriesColor => 'রং';

  @override
  String get categoriesActive => 'সক্রিয়';

  @override
  String get categoriesArchived => 'আর্কাইভ করা';

  @override
  String get categoriesArchive => 'আর্কাইভ করুন';

  @override
  String get categoriesRestore => 'ফিরিয়ে আনুন';

  @override
  String categoriesArchivePrompt(String name) {
    return '“$name” আর্কাইভ করবেন? এটি সংরক্ষিত থাকবে এবং পরে ফিরিয়ে আনা যাবে।';
  }

  @override
  String get categoriesEmpty => 'এই তালিকায় কোনো বিভাগ নেই।';

  @override
  String get categoriesDuplicate =>
      'এই ধরনের লেনদেনের জন্য একই নামের একটি সক্রিয় বিভাগ রয়েছে।';

  @override
  String get categoriesMissing =>
      'বিভাগটি খুঁজে পাওয়া যায়নি। তালিকা রিফ্রেশ করে আবার চেষ্টা করুন।';

  @override
  String get categoriesAlreadyArchived =>
      'সম্পাদনার আগে আর্কাইভ করা বিভাগটি ফিরিয়ে আনুন।';

  @override
  String get categoriesLoadError =>
      'বিভাগের তালিকা আনা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get categoriesWriteError =>
      'পরিবর্তন সংরক্ষণ করা যায়নি। আগের বিভাগগুলো অক্ষত আছে। আবার চেষ্টা করুন।';

  @override
  String get categoriesRefresh => 'বিভাগের তালিকা রিফ্রেশ করুন';

  @override
  String categoriesIconName(String icon) {
    String _temp0 = intl.Intl.selectLogic(icon, {
      'food': 'খাবার',
      'transport': 'যাতায়াত',
      'entertainment': 'বিনোদন',
      'shopping': 'কেনাকাটা',
      'health': 'স্বাস্থ্য',
      'others': 'অন্যান্য',
      'income': 'টাকা',
      'home': 'বাসা',
      'education': 'শিক্ষা',
      'bills': 'বিল',
      'gift': 'উপহার',
      'work': 'কাজ',
      'other': 'অন্যান্য',
    });
    return '$_temp0';
  }

  @override
  String categoriesColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'orange': 'কমলা',
      'blue': 'নীল',
      'purple': 'বেগুনি',
      'pink': 'গোলাপি',
      'red': 'লাল',
      'grey': 'ধূসর',
      'green': 'সবুজ',
      'teal': 'নীলচে সবুজ',
      'indigo': 'গাঢ় নীল',
      'brown': 'বাদামি',
      'other': 'অন্যান্য',
    });
    return '$_temp0';
  }

  @override
  String get expenseNoCategories =>
      'এই ধরনের লেনদেনের জন্য সক্রিয় বিভাগ নেই। চালিয়ে যেতে বিভাগ যোগ করুন বা ফিরিয়ে আনুন।';

  @override
  String get expenseCategoryUnavailable =>
      'এই বিভাগটি এখন ব্যবহার করা যাচ্ছে না। তালিকা রিফ্রেশ করে আবার বেছে নিন।';

  @override
  String get expenseSaveError =>
      'লেনদেন সংরক্ষণ করা যায়নি। আপনার লেখা তথ্য এখানেই আছে; আবার চেষ্টা করুন।';

  @override
  String expenseArchivedCategory(String name) {
    return '$name (আর্কাইভ করা)';
  }

  @override
  String get expenseLoadError =>
      'লেনদেনের তালিকা আনা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get expenseChooseCategory =>
      'চালিয়ে যেতে একটি সক্রিয় বিভাগ বেছে নিন।';

  @override
  String expenseDefaultCategory(String name) {
    return '$name (পূর্বনির্ধারিত)';
  }

  @override
  String expenseCustomCategory(String name) {
    return '$name (নিজস্ব)';
  }

  @override
  String get expenseEditTransaction => 'লেনদেন সম্পাদনা';

  @override
  String get expenseUpdateTransaction => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get expenseNotFound =>
      'এই লেনদেনটি আর নেই। লেনদেনের তালিকায় ফিরে যান।';

  @override
  String get expenseEditChanged =>
      'লেনদেনের পরিচয় বা মুদ্রা বদলে গেছে। সংরক্ষণের আগে আবার খুলুন।';

  @override
  String expenseEditCurrency(String currency) {
    return 'এই লেনদেনের মুদ্রা $currency-ই থাকবে; অঙ্কটি অন্য মুদ্রায় রূপান্তর করা হবে না।';
  }

  @override
  String get expenseHistory => 'লেনদেনের ইতিহাস';

  @override
  String get expenseHistoryAll => 'সব সময়';

  @override
  String get expenseHistoryDay => 'দিন';

  @override
  String get expenseHistoryMonth => 'মাস';

  @override
  String get expenseHistoryYear => 'বছর';

  @override
  String get expenseHistoryEmpty => 'এই সময়ে কোনো লেনদেন নেই।';

  @override
  String get expenseHistoryCurrencies =>
      'প্রতিটি লেনদেন তার নিজস্ব মুদ্রায় দেখানো হয়েছে।';

  @override
  String expenseHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন',
      one: '১টি লেনদেন',
      zero: 'কোনো লেনদেন নেই',
    );
    return '$_temp0';
  }

  @override
  String get expenseHistoryChooseDate => 'তারিখ বেছে নিন';

  @override
  String get reminderTitle => 'দৈনিক রিমাইন্ডার';

  @override
  String get reminderBlocked =>
      'নোটিফিকেশন বন্ধ আছে। রিমাইন্ডার পেতে Android সেটিংসে নোটিফিকেশনের অনুমতি দিন।';

  @override
  String get reminderTiming =>
      'Android নির্বাচিত সময়ের কিছু পরে রিমাইন্ডার পাঠাতে পারে।';

  @override
  String get reminderError =>
      'রিমাইন্ডার সেটিংস আপডেট করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String reminderTime(String time) {
    return 'রিমাইন্ডারের সময়: $time';
  }

  @override
  String get expenseHistoryExportPdf => 'PDF এক্সপোর্ট করুন';

  @override
  String get expenseHistoryPdfSaved => 'PDF সংরক্ষিত হয়েছে';

  @override
  String get expenseHistorySharePdf => 'PDF শেয়ার করুন';

  @override
  String get expenseHistoryPdfError =>
      'PDF প্রস্তুত করা যায়নি। আবার চেষ্টা করুন।';
}
