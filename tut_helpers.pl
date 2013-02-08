use Mojolicious::Lite;

# "whois" helper
helper whois => sub {
  my $self  = shift;
  my $agent = $self->req->headers->user_agent || 'Anonymous';
  my $ip    = $self->tx->remote_address;
  return "$agent ($ip)";
};

# /secret
get '/secret' => sub {
  my $self = shift;
  my $user = $self->whois;
  $self->app->log->debug("Request from $user.");
};

app->start;
__DATA__

@@ secret.html.ep
We know who you are: <b><%= whois %></b>.