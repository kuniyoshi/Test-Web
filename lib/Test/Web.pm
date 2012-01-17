package Test::Web;
use strict;
use warnings;
use Exporter "import";
use LWP::UserAgent;
use Time::HiRes qw( tv_interval gettimeofday );
use Test::Builder;

our $VERSION = '0.01';
our %EXPORT_TAGS = (
    dns => [ qw(
        host_ok  host_is
    ) ],
    http => [ qw(
        head_ok  get_ok
    ) ],
);
$EXPORT_TAGS{all} = [ map { @{ $_ } } values %EXPORT_TAGS ];
our @EXPORT_OK    = @{ $EXPORT_TAGS{all} };
our @EXPORT       = @{ $EXPORT_TAGS{http} };
our $VERBOSE;
our $ACCURACY = 2;
#our %COMMAND      = (
#    host => "host",
#);
our %RES;

my $ua = LWP::UserAgent->new(
    agent => join q{/}, join( q{}, map { ucfirst } split m{::}, __PACKAGE__ ), $VERSION,
);

my $t = Test::Builder->new;

sub host_ok {
    my( $host, $name ) = @_;
    $name ||= "is [$host] in DNS.";

# Humm, system command outputs result of host command somehow.

$host = $host; # how dirty.
    `host $host`;

    return $t->ok( $? == 0, $name );
}

sub host_is {
    my( $host, $address, $name ) = @_;
    $name ||= "is [$host]'s address [$address]";

# expect only one address, don't mind host can have some addresses yet.

$host = $host; # dirty too.
    chomp( my @lines = `host $host` );

    my(undef, $got) = split m{ has address }, shift @lines;

    return $t->is_eq( $got, $address, $name );
}

sub head_ok {
    my( $url, $name ) = @_;
    $name ||= "HEAD($url)";

    my $start = [ gettimeofday ];

    $RES{ $$ } = $ua->head( $url );

    if ( $VERBOSE ) {
        $name = join q{; }, $name, sprintf "took: %.2f[s]", tv_interval( $start, [ gettimeofday ] );
    }

    return $t->ok( $RES{ $$ }->is_success, $name ) || $t->diag( "Could not HEAD($url): ", $RES{ $$ }->as_string );
#    return $t->ok( $RES{ $$ }->is_success, $name ) || $t->diag( "Could not HEAD($url): ", $RES{ $$ }->status_line );
}

sub get_ok {
    my( $url, $name ) = @_;
    $name ||= "GET($url)";

    $RES{ $$ } = $ua->get( $url );

    return $t->ok( $RES{ $$ }->is_success, $name ) || $t->diag( "Could not GET($url): ", $RES{ $$ }->status_line );
}

1;
__END__

=head1 NAME

Test::Web - Tests is your website working

=head1 SYNOPSIS

  use Test::Most tests => 4;
  use Test::Web ":all";

  host_ok( "purasi-bo.me" );
  host_is( "purasi-bo.me", "182.163.86.132" );
  head_ok( "http://purasi-bo.me/" );
  get_ok( "http://purasi-bo.me/" );

=head1 DESCRIPTION

Test::Web tests allows you to test your website.

* Start small, this has too few methods to test my website,
  but will improve.

=head1 METHODS

=over

=item host_ok( "purasi-bo.me", "Check DNS record" )

* dig can be use.

=item host_is( "purasi-bo.me", "182.163.86.132" )

=item head_ok( "http://purasi-bo.me/", "Send HEAD request" )

=item get_ok( "http://purasi-bo.me/", "Send GET request" )

=back

=head1 AUTHOR

kuniyoshi E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

May many modules are exist, you can find more better modules.
i am just want to write.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

