// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get yourFeed => 'Your feed';

  @override
  String get feedIntro => 'Discover stories, ideas, and conversations.';

  @override
  String feedAuthor(int id) {
    return 'User $id';
  }

  @override
  String get publicPost => 'Public post';

  @override
  String feedLikes(String count) {
    return '$count likes';
  }

  @override
  String feedDislikes(String count) {
    return '$count dislikes';
  }

  @override
  String feedViews(String count) {
    return '$count views';
  }

  @override
  String get readPost => 'Read post';

  @override
  String get comments => 'Comments';

  @override
  String get copyPostLink => 'Copy link';

  @override
  String get postLinkCopied => 'Post link copied';

  @override
  String get refreshFeed => 'Refresh feed';

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get loadingPosts => 'Loading posts';

  @override
  String get retry => 'Try again';

  @override
  String get noPosts => 'No posts found. Try another search.';

  @override
  String get noComments => 'No comments yet.';

  @override
  String get feedEnd => 'You\'re all caught up';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get loading => 'Loading';

  @override
  String get operation => 'Operation';

  @override
  String operationFailed(String operation) {
    return '$operation failed. Please try again.';
  }

  @override
  String get networkTimeout => 'The request timed out.';

  @override
  String get networkConnection => 'Could not connect to the server.';

  @override
  String get networkCancelled => 'The request was cancelled.';

  @override
  String get networkCertificate =>
      'The server\'s identity could not be verified.';

  @override
  String get networkUnauthorized => 'Authentication is required.';

  @override
  String get networkForbidden => 'You do not have permission for this request.';

  @override
  String get networkNotFound => 'The requested information was not found.';

  @override
  String get networkRateLimited => 'Too many requests. Please try again later.';

  @override
  String get networkServer => 'The server could not complete the request.';

  @override
  String get networkResponse => 'The request was rejected.';

  @override
  String get networkInvalidData => 'The server returned invalid data.';

  @override
  String get appTitle => 'Posts';

  @override
  String get goToPosts => 'Go to posts';

  @override
  String get explorerIntro =>
      'Choose an operation, enter its inputs, then send a real HTTP request. Inspect the request and JSON response below.';

  @override
  String get simulatedWrites =>
      'DummyJSON simulates writes. Add, update, and delete return a response but do not change server data. Read again to see the original data.';

  @override
  String get listPosts => 'List posts';

  @override
  String get singlePost => 'Get one post';

  @override
  String get searchPosts => 'Search posts';

  @override
  String get postTags => 'Get tags';

  @override
  String get tagList => 'Get tag names';

  @override
  String get postsByTag => 'Posts by tag';

  @override
  String get postsByUser => 'Posts by user';

  @override
  String get postComments => 'Post comments';

  @override
  String get addPost => 'Add post';

  @override
  String get updatePost => 'Update post';

  @override
  String get deletePost => 'Delete post';

  @override
  String get postId => 'Post ID';

  @override
  String get userId => 'User ID';

  @override
  String get searchQuery => 'Search words';

  @override
  String get tag => 'Tag slug (for example, life)';

  @override
  String get pageLimit => 'Limit (0 = all results)';

  @override
  String get pageSkip => 'Skip (pagination offset)';

  @override
  String get selectFields => 'Fields (comma-separated; blank = all)';

  @override
  String get sortBy => 'Sort by field';

  @override
  String get sortOrder => 'Sort order';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get postTitle => 'Title';

  @override
  String get postBody => 'Body';

  @override
  String get sendRequest => 'Send request';

  @override
  String get sendWrite => 'Send simulated write';

  @override
  String get lastRequest => 'Last request';

  @override
  String get responseJson => 'Inspect response JSON';

  @override
  String get noResults => 'No results. Try different inputs.';

  @override
  String get previousResponse =>
      'The request failed. The previous successful response is shown below.';

  @override
  String get requiredField => 'Enter a value.';

  @override
  String invalidNumber(int minimum) {
    return 'Enter a whole number of at least $minimum.';
  }

  @override
  String responseStatus(int status) {
    return 'Response · HTTP $status';
  }
}
