if (_ROSLINT_EXTRAS_INCLUDED_)
  return()
endif()
set(_ROSLINT_EXTRAS_INCLUDED_ TRUE)

macro(_roslint_create_targets)
  # Create the master "roslint" target if it doesn't exist yet.
  if (NOT TARGET roslint)
    add_custom_target(roslint)
  endif()

  # Create the "roslint_pkgname" target if it doesn't exist yet. Doing this
  # with a check means that multiple linters can share the same target.
  if (NOT TARGET roslint_${PROJECT_NAME})
    add_custom_target(roslint_${PROJECT_NAME})
    add_dependencies(roslint roslint_${PROJECT_NAME})
  endif()
endmacro()

# Run a custom lint command on a list of file names.
# 
# :param linter: linter command name.
# :param lintopts: linter options.
# :param argn: a non-empty list of files to process.
# :type string
#
function(roslint_custom linter lintopts)
  message("roslint_custom: " ${linter} " " ${ARGN})
  if ("${ARGN}" STREQUAL "")
    message(WARNING "roslint: no files provided for command")
  else ()
    _roslint_create_targets()
    add_custom_command(TARGET roslint_${PROJECT_NAME} POST_BUILD
                       WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                       COMMAND ${linter} ${lintopts} ${ARGN} VERBATIM)
  endif()
endfunction()

# Run cpplint on a list of file names.
#
function(roslint_cpp)
  if (NOT DEFINED ROSLINT_CPP_CMD)
    set(ROSLINT_CPP_CMD rosrun roslint cpplint)
  endif ()
  if (NOT DEFINED ROSLINT_CPP_OPTS)
    set(ROSLINT_CPP_OPTS "--filter=-whitespace/line_length")
  endif ()
  roslint_custom("${ROSLINT_CPP_CMD}" "${ROSLINT_CPP_OPTS}" ${ARGN})
endfunction()

# Run pep8 on a list of file names.
#
function(roslint_python)
  if (NOT DEFINED ROSLINT_PYTHON_CMD)
    set(ROSLINT_PYTHON_CMD rosrun roslint pep8)
  endif ()
  if (NOT DEFINED ROSLINT_PYTHON_CMD)
    set(ROSLINT_PYTHON_OPTS "")
  endif ()
  roslint_custom("${ROSLINT_PYTHON_CMD}" "${ROSLINT_PYTHON_OPTS}" ${ARGN})
endfunction()
