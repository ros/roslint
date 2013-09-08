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

macro(roslint_cpp)
  _roslint_create_targets()
  FILE(GLOB_RECURSE CPP_SRCS *.cpp *.cc *.h)
  add_custom_command(TARGET roslint_${PROJECT_NAME} POST_BUILD
    COMMAND cpplint --filter=-whitespace/line_length ${CPP_SRCS})
endmacro()

macro(roslint_python)
  _roslint_create_targets()
  FILE(GLOB_RECURSE PYTHON_SRCS *.py)
  add_custom_command(TARGET roslint_${PROJECT_NAME} POST_BUILD
    COMMAND pylint ${PYTHON_SRCS} --reports=n)
endmacro()
