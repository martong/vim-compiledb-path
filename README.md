#CompileDbPath

You can use this plugin to add C++ include directories to your path. The include
directories are collected from the given [compilation
database](http://clang.llvm.org/docs/JSONCompilationDatabase.html) file.

To add the include directories to your path, just call :CompileDbPath with the
path to your compile_commands.json file as an argument. You can reset to the
default path with :set path& .

