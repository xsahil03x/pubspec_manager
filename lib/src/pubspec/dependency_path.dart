part of 'internal_parts.dart';

/// represents a dependency that has a 'path' key
/// A path dependency is located on the local file
/// system. The path is a relative or absolute path
/// to the dependant package.
/// A path dependency takes the form of:
/// dependencies:
///   dcli:
///     path: ../dcli
class DependencyPath extends Dependency {
  static const keyName = 'path';

  @override
  final SectionImpl _section;

  String _name;

  String _path;

  /// The parent dependency key
  final Dependencies _dependencies;

  /// Line that contained the dependency declaration
  final LineImpl _line;

  /// For future use - maybe
  final LineImpl _pathLine;

  /// Creates Path dependency from an existing [Line] in
  /// the document.
  DependencyPath._(this._dependencies, this._line, this._pathLine,
      this._section, this._name, this._path)
      : super._();

  factory DependencyPath._fromLine(Dependencies dependencies, LineImpl line) {
    final pathLine = line.findRequiredKeyChild('path');
    return DependencyPath._(dependencies, line, pathLine,
        SectionImpl.fromLine(line), line.key, pathLine.value);
  }

  /// Creates a  Path Dependency inserting it into the document after
  /// [lineBefore]
  factory DependencyPath._insertAfter(Dependencies dependencies,
      PubSpec pubspec, Line lineBefore, DependencyBuilderPath dependency) {
    final name = dependency.name;
    final path = dependency.path;

    final line = LineImpl.forInsertion(pubspec.document, '  $name:');
    pubspec.document.insertAfter(line, lineBefore);

    final pathLine = LineImpl.forInsertion(
        pubspec.document, '${line.childIndent}path: $path');
    pubspec.document.insertAfter(pathLine, line);

    final section = SectionImpl.fromLine(line);
    return DependencyPath._(dependencies, line, pathLine, section, name, path);
  }

  @override
  String get name => _name;

  set name(String name) {
    _name = name;
    _line.key = name;
  }

  String get path => _path;

  set path(String path) {
    _path = path;
    _pathLine.value = path;
  }

  /// List of comments associated with the
  /// dependency.
  @override
  Comments get comments => _section.comments;

  /// The line number within the pubspec.yaml
  /// where this dependency is located.
  @override
  int get lineNo => _section.headerLine.lineNo;

  /// Allows cascading calls to append
  @override
  Dependency add(DependencyBuilder dependency) {
    _dependencies.add(dependency);
    return this;
  }

  @override
  String toString() => _section.lines.join('\n');
}
