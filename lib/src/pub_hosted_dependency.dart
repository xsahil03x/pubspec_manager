part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
///
@immutable
class PubHostedDependency implements Dependency {
  /// If you don't pass in a [version] then the version will
  /// be left empty when you save
  PubHostedDependency({
    required this.name,
    String? version,
    List<String>? comments,
  }) : _comments = comments ?? <String>[] {}

  late final List<String> _comments;

  late final String name;
  late final Version version;

  @override
  DependencyAttached _attach(
      Dependencies dependencies, Pubspec pubspec, int lineNo) {
    final attached = PubHostedDependencyAttached._attach(
        dependencies, pubspec, lineNo, this);
    // ignore: prefer_foreach
    for (final comment in _comments) {
      attached.comments.append(comment);
    }
    return attached;
  }
}
