^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package roslint
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

0.9.2 (2014-03-31)
------------------
* Better implementation of roslint_add_test
* Simple implementation of XML results output
* roslint roslints itself
* Contributors: Mike Purvis

0.9.1 (2014-02-18)
------------------
* Add roslint_add_test function
* Run the include-line checks with errors suppressed. This kills spurious build/include_what_you_use errors.
* Contributors: Mike Purvis

0.9.0 (2014-02-17)
------------------
* Allow a trailing semicolon after closing brace.
* Add more tolerance for braces as array initializers, and eliminate the warning about access control labels.
* Rename python library to roslint, to play better.
* Use templated extras file to find roslint scripts without rosrun. 
* Max length override for pep8; remove roslint custom shout.
* Add some overrides in an effort to comply better with ROS C++ Style.
* Contributors: Mike Purvis

0.0.1 (2013-10-17)
------------------
* Basic initial release, with roslint_python, roslint_cpp, and roslint_custom macros included.
* pep8 and cpplint linters packaged-in.
