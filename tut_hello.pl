#!/usr/bin/env perl
use Mojolicious::Lite;
# strict, warnings, utf8 and Perl 5.10 features are automatically enabled 
# and a few functions imported when you use Mojolicious::Lite, 
# turning your script into a full featured web application.
get '/' => sub {
	my $self = shift;
	$self->render(text => 'Hello World!');
};

app->start;