function! AddIncludePathsOfCompileDbToVimPath(compileCommandsPath, failIfNotFound)
python << endscript
import vim
import os
import json
import sys
import itertools
import re

def pairwise(iterable):
  "s -> (s0,s1), (s1,s2), (s2, s3), ..."
  a, b = itertools.tee(iterable)
  next(b, None)
  return itertools.izip(a, b)

def removeClosingSlash(path):
  if path.endswith('/'):
    path = path[:-1]
  return path

def debugLog(msg):
  print msg
  sys.stdout.flush()

def searchForIncludePaths(compileCommandsPath, failIfNotFound):
  result = []
  try:
    jsonData = open(compileCommandsPath)
    data = json.load(jsonData)
    for translationUnit in data:
      buildDir = translationUnit["directory"]
      switches = translationUnit["command"].split()
      for currentSwitch, nextSwitch in pairwise(switches):
        matchObj = re.match( r'(-I|-isystem)(.*)', currentSwitch)
        includeDir = ""
        if currentSwitch == "-I" or currentSwitch == "-isystem":
          includeDir = nextSwitch
        elif matchObj:
          includeDir = matchObj.group(2)
        includeDir = os.path.join(buildDir, includeDir)
        includeDir = os.path.abspath(includeDir)
        includeDir = removeClosingSlash(includeDir)
        result.append(includeDir)
        #debugLog (includeDir)
    jsonData.close()
    result = set(result)
  except IOError:
    if failIfNotFound:
      raise
  debugLog(result)
  return result

compileCommandsPath = vim.eval("a:compileCommandsPath")
failIfNotFound = vim.eval("a:failIfNotFound") == 'true';
includePaths = searchForIncludePaths(compileCommandsPath, failIfNotFound)
for p in includePaths:
	vim.command("set path+=%s" % p)

endscript
endfunction

command! -nargs=1 -complete=file CompileDbPath call AddIncludePathsOfCompileDbToVimPath(<q-args>, 'true')
command! -nargs=1 -complete=file CompileDbPathIfExists call AddIncludePathsOfCompileDbToVimPath(<q-args>, 'false')

