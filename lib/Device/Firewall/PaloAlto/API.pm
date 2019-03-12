package Device::Firewall::PaloAlto::API;

use strict;
use warnings;
use 5.010;

use URI;
use Carp;
use LWP::UserAgent;
use HTTP::Request;
use XML::Twig;
use Class::Error;
use Hook::LexWrap;

# VERSION
# PODNAME
# ABSTRACT: new module

=encoding utf8

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ERRORS 

=head1 METHODS

=head2 new

    my $pa_api = Device::Firewall::PaloAlto::API->new(
        uri => 'https://localhost',
        username => 'admin',
        password => 'admin'
    )

=cut

sub new {
    my $class = shift;
    my %args = @_;

    my %object;
    my @args_keys = qw(uri username password);

    @object{ @args_keys } = @args{ @args_keys };
    $object{username} //= $ENV{PA_FW_USERNAME} // 'admin';
    $object{password} //= $ENV{PA_FW_PASSWORD} // 'admin';


    carp "Not enough keys specified" and return unless keys %object >= 3;

    my $uri = URI->new($object{uri});
    if (!($uri->scheme eq 'http' or $uri->scheme eq 'https')) {
        carp "Incorrect URI scheme: must be either http or https";
        return
    }

    $uri->path('/api/');

    $object{uri} = $uri;
    $object{user_agent} = LWP::UserAgent->new();
    $object{api_key} = '';

    return bless \%object, $class;
}



=head2 auth

=cut

sub auth {
    my $self = shift;

    my $response = $self->_send_request(
        type => 'keygen',
        user => $self->{username},
        password => $self->{password}
    );

    $self->{api_key} = $response->{result}{key} if $response;

    return $self;
}

=head2 debug

    $fw->debug->authenticate

=cut
sub debug {
    my $self = shift;

    return $self if $self->{wrap};

    $self->{wrap} = wrap '_send_raw_request',
        pre => \&_debug_pre_wrap,
        post => \&_debug_post_wrap;

    return $self;
}

=head2 undebug 

=cut

sub undebug {
    my $self = shift;
    $self->{wrap} = undef;

    return $self;
}


# Sends a request to the firewall. The query string parameters come from the key/value 
# parameters passed to the function, ie _send_request(type = 'op', cmd => '<xml>')
#
# The method automatically adds in the autentication key if it exists.
sub _send_request {
    my $self = shift;
    my %query = @_;

    # If we're authenticated, add the API key
    $query{key} = $self->{api_key} if $self->{api_key};

    # Build the URI query section
    my $uri = $self->{uri};
    $uri->query_form( \%query );

    # Create and send the HTTP::Request
    my $http_request = HTTP::Request->new(GET => $uri->as_string);
    my $response = $self->_send_raw_request($http_request);

    # Check and return
    return _parse_and_check_response( $response );
}


sub _send_raw_request {
    my $self = shift;
    return $self->{user_agent}->request($_[0]);
}


sub _parse_and_check_response {
    my ($http_response) = @_;
    return unless $http_response and ref $http_response eq 'HTTP::Response';

    return  _check_api_response( _check_http_response($http_response) );
}
  
# Checks whether the HTTP response is an error. Carps and returns undef if it is.
# Returns the decoded HTTP content on success.
# On failure returns 'false'.
sub _check_http_response {
    my ($http_response) = @_;

    if ($http_response->is_error) {
        carp('HTTP Error: '.$http_response->status_line.' - '.$http_response->code);
        return;
    }

    return $http_response->decoded_content;
}

# Parses the API response and checks if it's an API error.
# Returns a data structure representing the XML content on success.
# On failure returns 'false'.
sub _check_api_response {
    my ($http_content) = @_;
    return unless $http_content;

    my $api_response = XML::Twig->new->safe_parse( $http_content );
    carp 'Invalid XML returned in PA respons' and return unless $api_response;
    
    return $api_response->simplify( forcearray => ['entry'] );
}


use Data::Dumper;

sub _debug_pre_wrap {
    my $self = shift;
    my ($http_request) = @_;
    say "REQUEST:";
    say $http_request->as_string;
}

sub _debug_post_wrap {
    my $self = shift;
    my ($http_response) = @_;
    say "RESPONSE:";
    say $http_response->as_string;
}



1;

