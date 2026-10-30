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
