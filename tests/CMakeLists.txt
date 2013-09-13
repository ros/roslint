# Only processed if CATKIN_ENABLE_TESTING is true.

# Set up CMake environment to run tests:
include(${PROJECT_SOURCE_DIR}/cmake/roslint-extras.cmake)

# Some simple Python unit tests, which must return zero status or make
# run_tests appears to fail.
roslint_python(${CMAKE_CURRENT_SOURCE_DIR}/clean1.py)

# This should generate a CMake warning.  How to check it?
message("The following roslint test should generate a warning message:")
roslint_custom("no_such_linter")

# Run pylint with expected return status:
set(PYLINT_0 "${CMAKE_CURRENT_SOURCE_DIR}/runlint.py 0 pylint")
roslint_custom(${PYLINT_0}
               ${CMAKE_CURRENT_SOURCE_DIR}/clean1.py)
set(PYLINT_16 "${CMAKE_CURRENT_SOURCE_DIR}/runlint.py 16 pylint")
roslint_custom(${PYLINT_0}
               ${CMAKE_CURRENT_SOURCE_DIR}/dirty1.py)

# no C++ tests yet

# Make run_tests depend on the roslint targets created above.
add_custom_target(run_tests_${PROJECT_NAME})
add_dependencies(run_tests_${PROJECT_NAME} roslint_${PROJECT_NAME})
add_dependencies(run_tests run_tests_${PROJECT_NAME})
