use inc::Module::Install;
name 'Test-Web';
all_from 'lib/Test/Web.pm';
readme_from "lib/Test/Web.pm";

requires 'Test::Most';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
