import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('bn'),
  ];

  /// Social feed: yourFeed
  ///
  /// In en, this message translates to:
  /// **'Your feed'**
  String get yourFeed;

  /// Social feed: feedIntro
  ///
  /// In en, this message translates to:
  /// **'Discover stories, ideas, and conversations.'**
  String get feedIntro;

  /// Social feed: feedAuthor
  ///
  /// In en, this message translates to:
  /// **'User {id}'**
  String feedAuthor(int id);

  /// Social feed: publicPost
  ///
  /// In en, this message translates to:
  /// **'Public post'**
  String get publicPost;

  /// Social feed: feedLikes
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String feedLikes(String count);

  /// Social feed: feedDislikes
  ///
  /// In en, this message translates to:
  /// **'{count} dislikes'**
  String feedDislikes(String count);

  /// Social feed: feedViews
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String feedViews(String count);

  /// Social feed: readPost
  ///
  /// In en, this message translates to:
  /// **'Read post'**
  String get readPost;

  /// Social feed: comments
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// Social feed: copyPostLink
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyPostLink;

  /// Social feed: postLinkCopied
  ///
  /// In en, this message translates to:
  /// **'Post link copied'**
  String get postLinkCopied;

  /// Social feed: refreshFeed
  ///
  /// In en, this message translates to:
  /// **'Refresh feed'**
  String get refreshFeed;

  /// Social feed: clearFilter
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get clearFilter;

  /// Social feed: loadingPosts
  ///
  /// In en, this message translates to:
  /// **'Loading posts'**
  String get loadingPosts;

  /// Social feed: retry
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// Social feed: noPosts
  ///
  /// In en, this message translates to:
  /// **'No posts found. Try another search.'**
  String get noPosts;

  /// Social feed: noComments
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get noComments;

  /// Social feed: feedEnd
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get feedEnd;

  /// UI message: pageNotFound
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// UI message: loading
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// UI message: operation
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get operation;

  /// Failure feedback with a localized operation label
  ///
  /// In en, this message translates to:
  /// **'{operation} failed. Please try again.'**
  String operationFailed(String operation);

  /// Feedback when a network request exceeds its time limit.
  ///
  /// In en, this message translates to:
  /// **'The request timed out.'**
  String get networkTimeout;

  /// Feedback when the server cannot be reached.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server.'**
  String get networkConnection;

  /// Neutral feedback for a cancelled request; does not imply rollback.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get networkCancelled;

  /// Feedback when the server certificate cannot be verified.
  ///
  /// In en, this message translates to:
  /// **'The server\'s identity could not be verified.'**
  String get networkCertificate;

  /// Feedback when a request requires authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication is required.'**
  String get networkUnauthorized;

  /// Feedback when access to an operation is forbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission for this request.'**
  String get networkForbidden;

  /// Feedback when a requested resource does not exist.
  ///
  /// In en, this message translates to:
  /// **'The requested information was not found.'**
  String get networkNotFound;

  /// Feedback when the server rate limits requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get networkRateLimited;

  /// Feedback for a server failure.
  ///
  /// In en, this message translates to:
  /// **'The server could not complete the request.'**
  String get networkServer;

  /// Fallback for other rejected HTTP responses.
  ///
  /// In en, this message translates to:
  /// **'The request was rejected.'**
  String get networkResponse;

  /// Feedback for a malformed server response.
  ///
  /// In en, this message translates to:
  /// **'The server returned invalid data.'**
  String get networkInvalidData;

  /// Posts explorer: appTitle
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get appTitle;

  /// Posts explorer: goToPosts
  ///
  /// In en, this message translates to:
  /// **'Go to posts'**
  String get goToPosts;

  /// Posts explorer: explorerIntro
  ///
  /// In en, this message translates to:
  /// **'Choose an operation, enter its inputs, then send a real HTTP request. Inspect the request and JSON response below.'**
  String get explorerIntro;

  /// Posts explorer: simulatedWrites
  ///
  /// In en, this message translates to:
  /// **'DummyJSON simulates writes. Add, update, and delete return a response but do not change server data. Read again to see the original data.'**
  String get simulatedWrites;

  /// Posts explorer: listPosts
  ///
  /// In en, this message translates to:
  /// **'List posts'**
  String get listPosts;

  /// Posts explorer: singlePost
  ///
  /// In en, this message translates to:
  /// **'Get one post'**
  String get singlePost;

  /// Posts explorer: searchPosts
  ///
  /// In en, this message translates to:
  /// **'Search posts'**
  String get searchPosts;

  /// Posts explorer: postTags
  ///
  /// In en, this message translates to:
  /// **'Get tags'**
  String get postTags;

  /// Posts explorer: tagList
  ///
  /// In en, this message translates to:
  /// **'Get tag names'**
  String get tagList;

  /// Posts explorer: postsByTag
  ///
  /// In en, this message translates to:
  /// **'Posts by tag'**
  String get postsByTag;

  /// Posts explorer: postsByUser
  ///
  /// In en, this message translates to:
  /// **'Posts by user'**
  String get postsByUser;

  /// Posts explorer: postComments
  ///
  /// In en, this message translates to:
  /// **'Post comments'**
  String get postComments;

  /// Posts explorer: addPost
  ///
  /// In en, this message translates to:
  /// **'Add post'**
  String get addPost;

  /// Posts explorer: updatePost
  ///
  /// In en, this message translates to:
  /// **'Update post'**
  String get updatePost;

  /// Posts explorer: deletePost
  ///
  /// In en, this message translates to:
  /// **'Delete post'**
  String get deletePost;

  /// Posts explorer: postId
  ///
  /// In en, this message translates to:
  /// **'Post ID'**
  String get postId;

  /// Posts explorer: userId
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// Posts explorer: searchQuery
  ///
  /// In en, this message translates to:
  /// **'Search words'**
  String get searchQuery;

  /// Posts explorer: tag
  ///
  /// In en, this message translates to:
  /// **'Tag slug (for example, life)'**
  String get tag;

  /// Posts explorer: pageLimit
  ///
  /// In en, this message translates to:
  /// **'Limit (0 = all results)'**
  String get pageLimit;

  /// Posts explorer: pageSkip
  ///
  /// In en, this message translates to:
  /// **'Skip (pagination offset)'**
  String get pageSkip;

  /// Posts explorer: selectFields
  ///
  /// In en, this message translates to:
  /// **'Fields (comma-separated; blank = all)'**
  String get selectFields;

  /// Posts explorer: sortBy
  ///
  /// In en, this message translates to:
  /// **'Sort by field'**
  String get sortBy;

  /// Posts explorer: sortOrder
  ///
  /// In en, this message translates to:
  /// **'Sort order'**
  String get sortOrder;

  /// Posts explorer: ascending
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// Posts explorer: descending
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// Posts explorer: postTitle
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get postTitle;

  /// Posts explorer: postBody
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get postBody;

  /// Posts explorer: sendRequest
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendRequest;

  /// Posts explorer: sendWrite
  ///
  /// In en, this message translates to:
  /// **'Send simulated write'**
  String get sendWrite;

  /// Posts explorer: lastRequest
  ///
  /// In en, this message translates to:
  /// **'Last request'**
  String get lastRequest;

  /// Posts explorer: responseJson
  ///
  /// In en, this message translates to:
  /// **'Inspect response JSON'**
  String get responseJson;

  /// Posts explorer: noResults
  ///
  /// In en, this message translates to:
  /// **'No results. Try different inputs.'**
  String get noResults;

  /// Posts explorer: previousResponse
  ///
  /// In en, this message translates to:
  /// **'The request failed. The previous successful response is shown below.'**
  String get previousResponse;

  /// Posts explorer: requiredField
  ///
  /// In en, this message translates to:
  /// **'Enter a value.'**
  String get requiredField;

  /// Posts explorer: invalidNumber
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of at least {minimum}.'**
  String invalidNumber(int minimum);

  /// Posts explorer: responseStatus
  ///
  /// In en, this message translates to:
  /// **'Response · HTTP {status}'**
  String responseStatus(int status);

  /// Expense tracker: expenseAddTask
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get expenseAddTask;

  /// Expense tracker: expenseCancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get expenseCancel;

  /// Expense tracker: expenseDelete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get expenseDelete;

  /// Expense tracker: expenseDeletePrompt
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get expenseDeletePrompt;

  /// Expense tracker: expenseDeleteTitle
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get expenseDeleteTitle;

  /// Expense tracker: expenseExpenses
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenseExpenses;

  /// Expense tracker: expenseIncome
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get expenseIncome;

  /// Expense tracker: expenseNoTransactions
  ///
  /// In en, this message translates to:
  /// **'No transactions yet!'**
  String get expenseNoTransactions;

  /// Expense tracker: expenseRecentTransactions
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get expenseRecentTransactions;

  /// Expense tracker: expenseSeeAll
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get expenseSeeAll;

  /// Expense tracker: expenseSpendingAnalysis
  ///
  /// In en, this message translates to:
  /// **'Spending Analysis'**
  String get expenseSpendingAnalysis;

  /// Expense tracker: expenseSpent
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get expenseSpent;

  /// Expense tracker: expenseTotalBalance
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get expenseTotalBalance;

  /// Expense tracker: expenseTrackerTitle
  ///
  /// In en, this message translates to:
  /// **'Expense Tracker'**
  String get expenseTrackerTitle;

  /// Expense tracker: expenseAddTransaction
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get expenseAddTransaction;

  /// Expense tracker: expenseAmount
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// Expense tracker: expenseAmountInvalid
  ///
  /// In en, this message translates to:
  /// **'Enter a positive amount with up to 2 decimal places.'**
  String get expenseAmountInvalid;

  /// Expense tracker: expenseCategory
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategory;

  /// Expense tracker: expenseDate
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDate;

  /// Expense tracker: expenseGoHome
  ///
  /// In en, this message translates to:
  /// **'Go to expense tracker'**
  String get expenseGoHome;

  /// Expense tracker: expenseSaveTransaction
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get expenseSaveTransaction;

  /// Expense tracker: expenseTitle
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get expenseTitle;

  /// Expense tracker: expenseTitleRequired
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get expenseTitleRequired;

  /// Expense tracker: expenseTransactionType
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get expenseTransactionType;

  /// Expense tracker: expenseTypeExpense
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseTypeExpense;

  /// User preferences: preferencesCountry
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get preferencesCountry;

  /// User preferences: preferencesCountryBD
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get preferencesCountryBD;

  /// User preferences: preferencesCountryHint
  ///
  /// In en, this message translates to:
  /// **'Choosing a country suggests a currency and language. You can change either below.'**
  String get preferencesCountryHint;

  /// User preferences: preferencesCountryIN
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get preferencesCountryIN;

  /// User preferences: preferencesCountryUS
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get preferencesCountryUS;

  /// User preferences: preferencesCurrency
  ///
  /// In en, this message translates to:
  /// **'Preferred currency'**
  String get preferencesCurrency;

  /// User preferences: preferencesCurrencyBDT
  ///
  /// In en, this message translates to:
  /// **'Bangladeshi taka (BDT)'**
  String get preferencesCurrencyBDT;

  /// User preferences: preferencesCurrencyHint
  ///
  /// In en, this message translates to:
  /// **'This preference never converts existing transaction amounts.'**
  String get preferencesCurrencyHint;

  /// User preferences: preferencesCurrencyINR
  ///
  /// In en, this message translates to:
  /// **'Indian rupee (INR)'**
  String get preferencesCurrencyINR;

  /// User preferences: preferencesCurrencyUSD
  ///
  /// In en, this message translates to:
  /// **'US dollar (USD)'**
  String get preferencesCurrencyUSD;

  /// User preferences: preferencesIntro
  ///
  /// In en, this message translates to:
  /// **'Choose your region, then adjust currency and language to suit you.'**
  String get preferencesIntro;

  /// User preferences: preferencesLanguage
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get preferencesLanguage;

  /// User preferences: preferencesLanguageBN
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get preferencesLanguageBN;

  /// User preferences: preferencesLanguageEN
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get preferencesLanguageEN;

  /// User preferences: preferencesSave
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get preferencesSave;

  /// User preferences: preferencesStorageError
  ///
  /// In en, this message translates to:
  /// **'Could not load or save preferences. Please try again.'**
  String get preferencesStorageError;

  /// User preferences: preferencesSupportHint
  ///
  /// In en, this message translates to:
  /// **'Currently supports Bangladesh, India and the United States, with Bengali and English.'**
  String get preferencesSupportHint;

  /// User preferences: preferencesTitle
  ///
  /// In en, this message translates to:
  /// **'Your preferences'**
  String get preferencesTitle;

  /// User preferences screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get preferencesAppBar;

  /// Expense currency/language integration: expenseAllCurrencies
  ///
  /// In en, this message translates to:
  /// **'Recent transactions keep their original currencies.'**
  String get expenseAllCurrencies;

  /// Expense currency/language integration: expenseAmountCurrency
  ///
  /// In en, this message translates to:
  /// **'Amount ({currency})'**
  String expenseAmountCurrency(String currency);

  /// Expense currency/language integration: expenseCategoryEntertainment
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get expenseCategoryEntertainment;

  /// Expense currency/language integration: expenseCategoryFood
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get expenseCategoryFood;

  /// Expense currency/language integration: expenseCategoryHealth
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get expenseCategoryHealth;

  /// Expense currency/language integration: expenseCategoryIncome
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get expenseCategoryIncome;

  /// Expense currency/language integration: expenseCategoryOthers
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get expenseCategoryOthers;

  /// Expense currency/language integration: expenseCategoryPercent
  ///
  /// In en, this message translates to:
  /// **'{category}: {percent}%'**
  String expenseCategoryPercent(String category, String percent);

  /// Expense currency/language integration: expenseCategoryShopping
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get expenseCategoryShopping;

  /// Expense currency/language integration: expenseCategoryTransport
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get expenseCategoryTransport;

  /// Expense currency/language integration: expenseTotalsCurrency
  ///
  /// In en, this message translates to:
  /// **'Totals in {currency}'**
  String expenseTotalsCurrency(String currency);

  /// Example of an accepted transaction amount
  ///
  /// In en, this message translates to:
  /// **'Example: 1250.50 (no commas)'**
  String get expenseAmountHint;

  /// Transaction amount exceeds the supported input limit
  ///
  /// In en, this message translates to:
  /// **'Amount must not exceed {maximum}.'**
  String expenseAmountTooLarge(String maximum);

  /// Category management: Manage categories
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get categoriesTitle;

  /// Category management: Choose names, icons and colors that make sense to you.
  ///
  /// In en, this message translates to:
  /// **'Choose names, icons and colors that make sense to you.'**
  String get categoriesDescription;

  /// Category management: Add category
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get categoriesAdd;

  /// Category management: Edit category
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get categoriesEdit;

  /// Category management: Save category
  ///
  /// In en, this message translates to:
  /// **'Save category'**
  String get categoriesSave;

  /// Category management: Category name
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoriesName;

  /// Category management: Enter a name with 1–60 characters.
  ///
  /// In en, this message translates to:
  /// **'Enter a name with 1–60 characters.'**
  String get categoriesNameInvalid;

  /// Category management: Transaction type
  ///
  /// In en, this message translates to:
  /// **'Transaction type'**
  String get categoriesType;

  /// Category management: The transaction type cannot be changed after creation.
  ///
  /// In en, this message translates to:
  /// **'The transaction type cannot be changed after creation.'**
  String get categoriesTypeFixed;

  /// Category management: Icon
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get categoriesIcon;

  /// Category management: Color
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get categoriesColor;

  /// Category management: Active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get categoriesActive;

  /// Category management: Archived
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get categoriesArchived;

  /// Category management: Archive
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get categoriesArchive;

  /// Category management: Restore
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get categoriesRestore;

  /// Category management: Archive “{name}”? It will remain saved and can be restored later.
  ///
  /// In en, this message translates to:
  /// **'Archive “{name}”? It will remain saved and can be restored later.'**
  String categoriesArchivePrompt(String name);

  /// Category management: No categories in this group.
  ///
  /// In en, this message translates to:
  /// **'No categories in this group.'**
  String get categoriesEmpty;

  /// Category management: An active category with this name already exists for this transaction type.
  ///
  /// In en, this message translates to:
  /// **'An active category with this name already exists for this transaction type.'**
  String get categoriesDuplicate;

  /// Category management: This category could not be found. Refresh the list and try again.
  ///
  /// In en, this message translates to:
  /// **'This category could not be found. Refresh the list and try again.'**
  String get categoriesMissing;

  /// Category management: Restore this archived category before editing it.
  ///
  /// In en, this message translates to:
  /// **'Restore this archived category before editing it.'**
  String get categoriesAlreadyArchived;

  /// Category management: Could not refresh categories. Try again.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh categories. Try again.'**
  String get categoriesLoadError;

  /// Category management: Could not save the change. Your existing categories are safe. Try again.
  ///
  /// In en, this message translates to:
  /// **'Could not save the change. Your existing categories are safe. Try again.'**
  String get categoriesWriteError;

  /// Category management: Refresh categories
  ///
  /// In en, this message translates to:
  /// **'Refresh categories'**
  String get categoriesRefresh;

  /// Accessible localized label for category icon
  ///
  /// In en, this message translates to:
  /// **'{icon, select, food{Food} transport{Transport} entertainment{Entertainment} shopping{Shopping} health{Health} others{Other} income{Money} home{Home} education{Education} bills{Bills} gift{Gift} work{Work} other{Other}}'**
  String categoriesIconName(String icon);

  /// Accessible localized label for category color
  ///
  /// In en, this message translates to:
  /// **'{color, select, orange{Orange} blue{Blue} purple{Purple} pink{Pink} red{Red} grey{Grey} green{Green} teal{Teal} indigo{Indigo} brown{Brown} other{Other}}'**
  String categoriesColorName(String color);

  /// Transaction category integration: No active categories for this transaction type. Add or restore a category to continue.
  ///
  /// In en, this message translates to:
  /// **'No active categories for this transaction type. Add or restore a category to continue.'**
  String get expenseNoCategories;

  /// Transaction category integration: This category is no longer available. Refresh the categories and choose again.
  ///
  /// In en, this message translates to:
  /// **'This category is no longer available. Refresh the categories and choose again.'**
  String get expenseCategoryUnavailable;

  /// Transaction category integration: Could not save the transaction. Your entries are kept here; try again.
  ///
  /// In en, this message translates to:
  /// **'Could not save the transaction. Your entries are kept here; try again.'**
  String get expenseSaveError;

  /// Transaction category integration: {name} (archived)
  ///
  /// In en, this message translates to:
  /// **'{name} (archived)'**
  String expenseArchivedCategory(String name);

  /// Initial transaction or linked-category loading failed; no empty balance should be shown
  ///
  /// In en, this message translates to:
  /// **'Could not load transactions. Try again.'**
  String get expenseLoadError;

  /// The selected category was archived or removed while the transaction draft remained open
  ///
  /// In en, this message translates to:
  /// **'Choose an active category to continue.'**
  String get expenseChooseCategory;

  /// Disambiguates categories with identical visible names and different stable IDs
  ///
  /// In en, this message translates to:
  /// **'{name} (default)'**
  String expenseDefaultCategory(String name);

  /// Disambiguates categories with identical visible names and different stable IDs
  ///
  /// In en, this message translates to:
  /// **'{name} (custom)'**
  String expenseCustomCategory(String name);

  /// Transaction editing: Edit transaction
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get expenseEditTransaction;

  /// Transaction editing: Save changes
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get expenseUpdateTransaction;

  /// Transaction editing: This transaction no longer exists. Go back to your transactions.
  ///
  /// In en, this message translates to:
  /// **'This transaction no longer exists. Go back to your transactions.'**
  String get expenseNotFound;

  /// Transaction editing: The transaction identity or currency changed. Reopen it before saving.
  ///
  /// In en, this message translates to:
  /// **'The transaction identity or currency changed. Reopen it before saving.'**
  String get expenseEditChanged;

  /// Transaction editing: This transaction stays in {currency}; the amount is not currency-converted.
  ///
  /// In en, this message translates to:
  /// **'This transaction stays in {currency}; the amount is not currency-converted.'**
  String expenseEditCurrency(String currency);

  /// Transaction history: expenseHistory
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get expenseHistory;

  /// Transaction history: expenseHistoryAll
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get expenseHistoryAll;

  /// Transaction history: expenseHistoryDay
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get expenseHistoryDay;

  /// Transaction history: expenseHistoryMonth
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get expenseHistoryMonth;

  /// Transaction history: expenseHistoryYear
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get expenseHistoryYear;

  /// Transaction history: expenseHistoryEmpty
  ///
  /// In en, this message translates to:
  /// **'No transactions in this period.'**
  String get expenseHistoryEmpty;

  /// Transaction history: expenseHistoryCurrencies
  ///
  /// In en, this message translates to:
  /// **'Each transaction is shown in its original currency.'**
  String get expenseHistoryCurrencies;

  /// Transaction history: expenseHistoryCount
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions} =1{1 transaction} other{{count} transactions}}'**
  String expenseHistoryCount(int count);

  /// Transaction history: expenseHistoryChooseDate
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get expenseHistoryChooseDate;

  /// Label for the daily reminder switch
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderTitle;

  /// Shown when Android blocks delivery
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked. Allow them in Android settings to receive reminders.'**
  String get reminderBlocked;

  /// Explains that Android can defer notification delivery
  ///
  /// In en, this message translates to:
  /// **'Android may deliver the reminder after the selected time.'**
  String get reminderTiming;

  /// Shown when reminder settings could not be loaded or saved
  ///
  /// In en, this message translates to:
  /// **'Could not update reminder settings. Please try again.'**
  String get reminderError;

  /// Button to change the reminder time
  ///
  /// In en, this message translates to:
  /// **'Reminder time: {time}'**
  String reminderTime(String time);

  /// Save filtered transaction history as a PDF
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get expenseHistoryExportPdf;

  /// Confirmation after writing the PDF to the selected location
  ///
  /// In en, this message translates to:
  /// **'PDF saved'**
  String get expenseHistoryPdfSaved;

  /// Open the Android share sheet for filtered transaction history
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get expenseHistorySharePdf;

  /// Failure message for transaction history PDF export
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the PDF. Try again.'**
  String get expenseHistoryPdfError;

  /// Button that opens Google advertising privacy choices
  ///
  /// In en, this message translates to:
  /// **'Ad privacy options'**
  String get adsPrivacyOptions;

  /// Shown when the advertising privacy form fails to open
  ///
  /// In en, this message translates to:
  /// **'Could not open ad privacy options. Try again.'**
  String get adsPrivacyError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
