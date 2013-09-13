# Only processed if CATKIN_ENABLE_TESTING is true.

# Set up CMake environment to run tests:
include(${PROJECT_SOURCE_DIR}/cmake/roslint-extras.cmake)

# Python unit tests
roslint_python(${CMAKE_CURRENT_SOURCE_DIR}/clean1.py)

## Comment out for now.  Pylint returns non-zero status, as it should,
## but that looks like failure for unit test.  Proposed solution:
## users to override the actual command with a CMake variable or
## option.
##
#roslint_python(${CMAKE_CURRENT_SOURCE_DIR}/clean1.py
#               ${CMAKE_CURRENT_SOURCE_DIR}/dirty1.py)

# no C++ tests yet

# Make run_tests depend on the roslint targets created above.
add_custom_target(run_tests_${PROJECT_NAME})
add_dependencies(run_tests_${PROJECT_NAME} roslint_${PROJECT_NAME})
add_dependencies(run_tests run_tests_${PROJECT_NAME})
