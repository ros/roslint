
from cpplint import cpplint

# Override line length as per the ROS C++ Style Guide
cpplint._line_length = 120


def makeErrorFn(original_fn, suppress_categories):
    def newError(filename, linenum, category, confidence, message):
        if category in suppress_categories:
            return
        original_fn(filename, linenum, category, confidence, message)
    return newError


def newCheckBraces(filename, clean_lines, linenum, error):
    pass    
cpplint.CheckBraces = newCheckBraces


oldCheckSpacing = cpplint.CheckSpacing
def newCheckSpacing(filename, clean_lines, linenum, nesting_state, error):
    categories = [ 'readability/braces']
    oldCheckSpacing(filename, clean_lines, linenum,
                    nesting_state, makeErrorFn(error, categories))
cpplint.CheckSpacing = newCheckSpacing
