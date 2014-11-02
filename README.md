#CompileDbPath

You can use this plugin to add C++ include directories to your path. The include
directories are collected from the given [compilation
database](http://clang.llvm.org/docs/JSONCompilationDatabase.html) file.

To add the include directories to your path, just call :CompileDbPath with the
path to your compile_commands.json file as an argument. E.g.:
```
:CompileDbPath build/compile_commands.json
```
You can reset to the default path with `:set path&` .

##Installation
Use [vundle](https://github.com/gmarik/Vundle.vim) or any other vim plugin solutions.

