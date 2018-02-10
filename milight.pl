#!/usr/bin/perl
#
# Send commands to a milight gateway device
#
# Example: milight green flash red flash

use strict;
use warnings;

use Getopt::Long;
use IO::Socket::INET;

my $host = "milight";
my $port = 8899;

my $commands = {
    'flash' => [ '4200', '4100', '4200', '4100', '4200', '4100' ],
    'red'   => [ '420040af' ],
    'green' => [ '42004060' ],
    'blue'  => [ '42004000' ],
    'on'    => [ '4200' ],
    'off'   => [ '4100' ]
};

my $parseOk = GetOptions(
        'host=s' => \$host,
        'port=s' => \$port );

$port = 0 + $port; # make int
if( !$parseOk || !$host || !$port || @ARGV==0 ) {
    die( "Synopsis: $0 [--host <hostname>] [--port <port>] command...")
}

my @pipeline = @ARGV;

my $data;
my $dataLen;

while( @pipeline ) {
    my $cmd = shift @pipeline;

    if( exists( $commands->{$cmd} )) {
        @pipeline = ( @{$commands->{$cmd}}, @pipeline );
    } else {
        ( $data, $dataLen ) = hex2bin( $cmd );

        my $sock = new IO::Socket::INET(
                PeerAddr => $host,
                PeerPort => $port,
                Proto => 'udp',
                Timeout => 1 )
            or die('Error opening socket.');

        for( my $i=0 ; $i<$dataLen ; $i+=2 ) {
            print $sock substr( $data, $i, 2 );
        }
        close( $sock );

        sleep( 1 );
    }
}

sub hex2bin {
    my $arg = shift;

    my $ret    = '';
    my $retlen = 0;
    while( $arg =~ m!([0-9a-f]{2})!g ) {
        $ret .= chr( hex( $1 ));
        ++$retlen;
    }
    return ( $ret, $retlen );
}

1;
