#!perl

use Test::More tests => 5;

use_ok( 'WWW::Wunderground::API' );

my $wun = new WWW::Wunderground::API('KDCA');
isa_ok($wun,'WWW::Wunderground::API','Got a new Wunderground API object');
ok(length($wun->xml),'Got XML from wunderground');
isa_ok($wun->data,'Hash::AsObject','Parsed xml');
like($wun->data->temp_f, qr/\d+/, 'Read temperature of '.$wun->data->temp_f.'f');
