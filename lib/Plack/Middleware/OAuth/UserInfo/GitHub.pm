package Plack::Middleware::OAuth::UserInfo::GitHub;
use warnings;
use strict;
use parent qw(Plack::Middleware::OAuth::UserInfo);
use LWP::UserAgent;
use JSON;
use Encode;
# use Net::GitHub;

sub create_handle {
    my $self = shift;
    # return Net::GitHub->new( access_token => $self->token->access_token );
}

sub query {
    my $self = shift;
    # my $gh = $self->create_handle;

    my $ua = LWP::UserAgent->new;
    my $uri = URI->new( 'https://api.github.com/user' );
    $uri->query_form( access_token => $self->token->access_token );
    my $response = $ua->get( $uri );
    my $body = $response->decoded_content;
    return unless $body;

    my $obj = eval {decode_json( Encode::encode('UTF-8', $body) )} || { };
    return $obj;
}

1;
