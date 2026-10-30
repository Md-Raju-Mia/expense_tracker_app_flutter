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
}
