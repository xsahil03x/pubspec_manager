part of 'internal_parts.dart';

/// Used to hold a list of [Executable]s from
/// To add additinal executables use:
///
/// ```dart
/// final pubspec = PubSpecl.load();
/// pubspec.executables.append(ExecutableBuilder(name: 'test'));
/// pubspec.save();
/// ```
class Executables with IterableMixin<Executable> {
  Executables._missing(this._pubspec)
      : _section = SectionImpl.missing(_pubspec.document, key);

  Executables._fromLine(this._pubspec, LineImpl line)
      : _section = SectionImpl.fromLine(line) {
    name = line.key;
  }

  static const String key = 'executables';

  Section _section;

  /// The name of the dependency section such as
  /// dev_dpendencies
  late final String name;

  /// reference to the pubspec that has these dependencies.
  final PubSpec _pubspec;

  final List<Executable> _executables = <Executable>[];

  /// List of the dependencies
  List<Executable> get list => List.unmodifiable(_executables);

  /// the number of dependencies in this section
  @override
  int get length => _executables.length;

  // @override
  // List<Line> get lines {
  //   final lines = <Line>[];
  //   if (missing) {
  //     return lines;
  //   }
  //   for (final executable in _executables) {
  //     lines.addAll(executable.lines);
  //   }
  //   return lines;
  // }

  /// returns the [ExecutableBuilder] with the given [name]
  /// if it exists in this section.
  /// Returns null if it doesn't exist.
  Executable? operator [](String name) {
    for (final executable in _executables) {
      if (executable.name == name) {
        return executable;
      }
    }
    return null;
  }

  /// Add [executable] to the PubSpec
  /// after the last dependency.
  Executables append(ExecutableBuilder executable) {
    var line = _section.sectionHeading;

    if (_section.missing) {
      // create the section.
      line = _section.document.append(LineDetached('$key:'));
      _section = SectionImpl.fromLine(line as LineImpl);
    } else {
      if (_executables.isNotEmpty) {
        line = _executables.last.sectionHeading;
      }
    }
    final attached = executable._attach(_pubspec, line);

    _executables.add(attached);

    // ignore: avoid_returning_this
    return this;
  }

  void _appendAttached(Executable attached) {
    _executables.add(attached);
  }

  /// Remove an executable from the list of executables
  /// Throws a [ExecutableNotFound] exception if the
  /// executable doesn't exist.
  void remove(String name) {
    final executable = this[name];

    if (executable == null) {
      throw ExecutableNotFound(
          _pubspec.document, '$name not found in the ${this.name} section');
    }

    _executables.remove(executable);
    final lines = executable.lines;
    _pubspec.document.removeAll(lines);
  }

  /// returns true if the list of dependencies contains a dependency
  /// with the given name.
  bool exists(String name) => this[name] != null;

  @override
  Iterator<Executable> get iterator => IteratorImpl(_executables);
}
