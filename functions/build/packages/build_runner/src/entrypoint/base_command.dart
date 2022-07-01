// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:logging/logging.dart';

import 'options.dart';
import 'runner.dart';

final lineLength = stdout.hasTerminal ? stdout.terminalColumns : 80;

abstract class BuildRunnerCommand extends Command<int> {
  Logger get logger => Logger(name);

  List<BuilderApplication> get builderApplications =>
      (runner as BuildCommandRunner).builderApplications;

  PackageGraph get packageGraph => (runner as BuildCommandRunner).packageGraph;

  BuildRunnerCommand({bool symlinksDefault}) {
    _addBaseFlags(symlinksDefault ?? false);
  }

  @override
  final argParser = ArgParser(usageLineLength: lineLength);

  void _addBaseFlags(bool symlinksDefault) {
    argParser
      ..addFlag(deleteFilesByDefaultOption,
          help:
              'By default, the user will be prompted to delete any files which '
              'already exist but were not known to be generated by this '
              'specific build script.\n\n'
              'Enabling this option skips the prompt and deletes the files. '
              'This should typically be used in continues integration servers '
              'and tests, but not otherwise.',
          negatable: false,
          defaultsTo: false)
      ..addFlag(lowResourcesModeOption,
          help: 'Reduce the amount of memory consumed by the build process. '
              'This will slow down builds but allow them to progress in '
              'resource constrained environments.',
          negatable: false,
          defaultsTo: false)
      ..addOption(configOption,
          help: 'Read `build.<name>.yaml` instead of the default `build.yaml`',
          abbr: 'c')
      ..addFlag('fail-on-severe',
          help: 'Deprecated argument - always enabled',
          negatable: true,
          defaultsTo: true,
          hide: true)
      ..addFlag(trackPerformanceOption,
          help: r'Enables performance tracking and the /$perf page.',
          negatable: true,
          defaultsTo: false)
      ..addOption(logPerformanceOption,
          help: 'A directory to write performance logs to, must be in the '
              'current package. Implies `--track-performance`.')
      ..addFlag(skipBuildScriptCheckOption,
          help: r'Skip validation for the digests of files imported by the '
              'build script.',
          hide: true,
          defaultsTo: false)
      ..addMultiOption(outputOption,
          help: 'A directory to copy the fully built package to. Or a mapping '
              'from a top-level directory in the package to the directory to '
              'write a filtered build output to. For example "web:deploy".',
          abbr: 'o')
      ..addFlag(verboseOption,
          abbr: 'v',
          defaultsTo: false,
          negatable: false,
          help: 'Enables verbose logging.')
      ..addFlag(releaseOption,
          abbr: 'r',
          defaultsTo: false,
          negatable: true,
          help: 'Build with release mode defaults for builders.')
      ..addMultiOption(defineOption,
          splitCommas: false,
          help: 'Sets the global `options` config for a builder by key.')
      ..addFlag(symlinkOption,
          defaultsTo: symlinksDefault,
          negatable: true,
          help: 'Symlink files in the output directories, instead of copying.')
      ..addMultiOption(buildFilterOption,
          help: 'An explicit filter of files to build. Relative paths and '
              '`package:` uris are supported, including glob syntax for paths '
              'portions (but not package names).\n\n'
              'If multiple filters are applied then outputs matching any filter '
              'will be built (they do not need to match all filters).');
  }

  /// Must be called inside [run] so that [argResults] is non-null.
  ///
  /// You may override this to return more specific options if desired, but they
  /// must extend [SharedOptions].
  SharedOptions readOptions() {
    return SharedOptions.fromParsedArgs(
        argResults, argResults.rest, packageGraph.root.name, this);
  }
}
