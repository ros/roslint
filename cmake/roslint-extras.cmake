if(_ROSLINT_EXTRAS_INCLUDED_)
  return()
endif()
set(_ROSLINT_EXTRAS_INCLUDED_ TRUE)

macro(_roslint_create_targets)
  # Create the master "roslint" target if it doesn't exist yet.
  if(TARGET roslint)
  else()
    add_custom_target(roslint)
  endif()

  # Create the "roslint_pkgname" target if it doesn't exist yet. Doing this
  # with a check means that multiple linters can share the same target.
  if(TARGET roslint_${PROJECT_NAME})
  else()
    add_custom_target(roslint_${PROJECT_NAME})
    add_dependencies(roslint roslint_${PROJECT_NAME})
  endif()
endmacro()

# Run a custom lint command on a list of file names.
# 
# :param linter: linter command, perhaps with options, followed by a
#                non-empty list of files to process.
# :type string
#
macro(roslint_custom linter)
  if(ARGN)
    _roslint_create_targets()
    add_custom_command(TARGET roslint_${PROJECT_NAME} POST_BUILD
                       COMMAND linter ${ARGN})
  else ()
    message(WARNING "roslint: no files provided for command")
  endif()
endmacro()

# Run cpplint on a list of file names.
#
macro(roslint_cpp)
  _roslint_create_targets()
  add_custom_command(TARGET roslint_${PROJECT_NAME} POST_BUILD
                     COMMAND cpplint --filter=-whitespace/line_length ${ARGN})
endmacro()

# Run pylint on a list of file names.
#
macro(roslint_python)
  _roslint_create_targets()
  add_custom_command(TARGET roslint_${PROJECT_NAME} POST_BUILD
                     COMMAND pylint ${ARGN} --reports=n)
endmacro()
