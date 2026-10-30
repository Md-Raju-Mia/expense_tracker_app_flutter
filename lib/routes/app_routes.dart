part of 'app_pages.dart';

// Match the route-constant convention used by the reference template.
// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();

  static const MAIN = _Paths.MAIN;
  static const POSTS = _Paths.POSTS;
  static const POST_DETAIL = '/posts/:postId';
}

abstract class _Paths {
  _Paths._();

  static const MAIN = '/';
  static const POSTS = '/posts';
}
