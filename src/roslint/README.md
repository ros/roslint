Acquiring these scripts:

    wget http://google-styleguide.googlecode.com/svn/trunk/cpplint/cpplint.py -O cpplint.py
    wget https://raw.github.com/jcrocholl/pep8/master/pep8.py -O pep8.py
    wget https://github.com/jorisroovers/pymarkdownlint/raw/master/pymarkdownlint/lint.py -O pymarkdownlint_lint.py
    wget https://github.com/jorisroovers/pymarkdownlint/raw/master/pymarkdownlint/rules.py -O pymarkdownlint_rules.py
    wget https://github.com/jorisroovers/pymarkdownlint/raw/master/pymarkdownlint/options.py -O pymarkdownlint_options.py
    sed -i 's/from pymarkdownlint import rules/import pymarkdownlint_rules as rules/' pymarkdownlint_lint.py
    sed -i 's/from pymarkdownlint.options import IntOption/from pymarkdownlint_options import IntOption/' pymarkdownlint_rules.py

TODO: Have CMake download them at package build time?
