use Test::Most;
use Test::Web ":all";

### host_ok( "purasi-bo.me" );
### host_is( "purasi-bo.me", "182.163.86.132" );

$Test::Web::VERBOSE = 1;

head_ok( "http://purasi-bo.me/" );
get_ok( "http://purasi-bo.me/" );

done_testing;

