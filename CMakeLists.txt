cmake_minimum_required(VERSION 2.8.3)
project(roslint)

find_package(catkin REQUIRED)

catkin_package(CFG_EXTRAS roslint-extras.cmake)
catkin_python_setup()

if (CATKIN_ENABLE_TESTING)
  #  add_subdirectory(tests)
endif ()

install(PROGRAMS scripts/cpplint scripts/pep8
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY cmake
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
