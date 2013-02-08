use Mojolicious::Lite;

# /foo
get '/foo' => sub {
	my $self = shift;
	$self->render(text => 'Hello World!');
};

app->start;