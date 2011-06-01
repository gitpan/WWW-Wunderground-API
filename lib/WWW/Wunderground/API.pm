package WWW::Wunderground::API;

use 5.006;
use Any::Moose;
use LWP::Simple;
use XML::Simple;
use Hash::AsObject;

=head1 NAME

WWW::Wunderground::API - Use Weather Underground's XML interface

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


has location => (is=>'rw', required=>1, trigger=>\&update);
has xml => (is=>'rw', isa=>'Str');
has data => (is=>'rw',isa=>'Hash::AsObject');



sub update {
  my $self = shift;
  my $xml = get('http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query='.$self->location);
  if ($xml) {
    $self->xml($xml);
    $self->data(Hash::AsObject->new(XMLin($xml)));
  }
}

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  if (@_ == 1 and !ref($_[0])) {
    return $class->$orig( location=>$_[0] );
  } else {
    return $class->$orig(@_);
  }
};

no Any::Moose;


=head1 SYNOPSIS

Connects to the Weather Underground XML weather conditions URL and parses the data
into something usable. The entire response is available in Hash::AsObject form, so
any data that comes from the server is accessible. Print a Data::Dumper of ->data
to see all of the tasty data bits.

    use WWW::Wunderground::API;

    #location
    my $wun = new WWW::Wunderground::API('Fairfax, VA');

    #or zipcode
    my $wun = new WWW::Wunderground::API(22030);

    #or airport identifier
    my $wun = new WWW::Wunderground::API('KIAD');

    print 'The temperature is: '.$wun->data->temp_f;
    print 'XML source:'.$wun->xml;

=head2 update()

Refetch data from the server. This is called automatically every time location is set, but you may want to put it in a timer.

=head2 location()

Change the location. For example:

    my $wun = new WWW::Wunderground::API(22030);
    my $ffx_temp = $wun->data->temp_f;
    $wun->location('KJFK');
    my $ny_temp = $wun->data->temp_f;
    $wun->location('San Diego, CA');
    my $socal_temp = $wun->data->temp_f;

=head2 xml()

Returns raw xml result from wunderground server

=head2 data()

Contains xml result from server parsed into convenient Hash::AsObject form;

=head1 AUTHOR

John Lifsey, C<< <nebulous at crashed.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-wunderground-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Wunderground-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Wunderground::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Wunderground-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Wunderground-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Wunderground-API>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Wunderground-API/>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2011 John Lifsey.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WWW::Wunderground::API
