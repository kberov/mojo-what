use Mojolicious::Lite;

# /foo?user=sri
get '/foo' => sub {
  my $self = shift;
  my $user = $self->param('user');
  $self->render(text => "Hello $user.");
};

app->start;