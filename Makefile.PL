use inc::Module::Install;
name 'Array-Diff';
all_from 'lib/Array/Diff.pm';

test_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
