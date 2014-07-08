
# from cpplint import cpplint
# from cpplint.cpplint import Match, IsBlankLine
from roslint import cpplint
from roslint.cpplint import Match, IsBlankLine, main
from functools import partial

import os.path
import re

# Line length as per the ROS C++ Style Guide
cpplint._line_length = 120


def patch(original_module):
    """ Decorator to easily allow wrapping/overriding of the Check* functions in cpplint. Should
        decorate a function which matches the signature of the function it replaces expect with
        the addition of a fn parameter, which is a pass-through of the replaced function, in case
        the replacement would like call through to the original functionality. """
    def wrap(override_fn):
        original_fn = getattr(original_module, override_fn.__name__)
        setattr(original_module, override_fn.__name__, partial(override_fn, original_fn))

        # Don't actually modify the function being decorated.
        return override_fn
    return wrap


def makeErrorFn(original_fn, suppress_categories, suppress_message_matches):
    """ Create a return a wrapped version of the error-report function which suppresses specific
        error categories. """
    def newError(filename, linenum, category, confidence, message):
        if category in suppress_categories:
            return
        #if "should be" in message:
        #    print suppress_message_matches, message, [Match(r, message) for r in suppress_message_matches]
        if True in [bool(Match(r, message)) for r in suppress_message_matches]:
            return
        original_fn(filename, linenum, category, confidence, message)
    return newError


@patch(cpplint)
def GetHeaderGuardCPPVariable(fn, filename):
    """ Replacement for the function which determines the header guard variable, to pick one which
        matches ROS C++ Style. """
    var_parts = list()
    head = filename
    while head:
        head, tail = os.path.split(head)
        var_parts.insert(0, tail)
        if head.endswith('include') or tail == "":
            break
    return re.sub(r'[-./\s]', '_', "_".join(var_parts)).upper()


@patch(cpplint)
def CheckBraces(fn, filename, clean_lines, linenum, error):
    """ Complete replacement for cpplint.CheckBraces, since the brace rules for ROS C++ Style
        are completely different from the Google style guide ones. """
    line = clean_lines.elided[linenum]
    if Match(r'^(.*){(.*)}.?$', line):
        # Special case when both braces are on the same line together, as is the
        # case for one-line getters and setters, for example, or rows of a multi-
        # dimenstional array initializer.
        pass
    else:
        # Line does not contain both an opening and closing brace.
        m = Match(r'^(.*){(.*)$', line)
        if m and not (IsBlankLine(m.group(1))):
            # Line contains a starting brace and is not empty, uh oh.
            if "=" in line:
                # Opening brace is permissable in case of an initializer.
                pass
            else:
                error(filename, linenum, 'whitespace/braces', 4,
                      'when starting a new scope, { should be on a line by itself')
        m = Match(r'^(.*)}(.*)$', line)
        if m and (not IsBlankLine(m.group(1)) or not IsBlankLine(m.group(2))):
            if m.group(2) != ";":
                error(filename, linenum, 'whitespace/braces', 4,
                      '} should be on a line by itself')
    pass


@patch(cpplint)
def CheckIncludeLine(fn, filename, clean_lines, linenum, include_state, error):
    """ Run the function to get include state, but suppress all the errors, since
        ROS C++ Style is silent on include order, and contains no prohibition on use of streams. """
    fn(filename, clean_lines, linenum, include_state,
       makeErrorFn(error, ['build/include_order', 'build/include_alpha', 'readability/streams'], []))


@patch(cpplint)
def CheckSpacing(fn, filename, clean_lines, linenum, nesting_state, error):
    """ Do most of the original Spacing checks, but suppress the ones related to braces, since
        the ROS C++ Style rules are different. """
    fn(filename, clean_lines, linenum, nesting_state,
       makeErrorFn(error, ['readability/braces', 'whitespace/braces'], []))


@patch(cpplint)
def ProcessLine(fn, filename, file_extension, clean_lines, line,
                include_state, function_state, nesting_state, error,
                extra_check_functions=[]):
    """ Squelch the error about access control indents. """
    fn(filename, file_extension, clean_lines, line,
       include_state, function_state, nesting_state,
       makeErrorFn(error, [], [r'(.*)should be indented \+1 space inside class(.*)']),
       extra_check_functions=[])
