use Test::Most;
use Test::Web ":all";

host_ok( "purasi-bo.me" );
host_is( "purasi-bo.me", "182.163.86.132" );

head_ok( "http://purasi-bo.me/" );
get_ok( "http://purasi-bo.me/" );

head_ok( "http://purasi-bo.me/a" );
get_ok( "http://purasi-bo.me/a" );

done_testing;

