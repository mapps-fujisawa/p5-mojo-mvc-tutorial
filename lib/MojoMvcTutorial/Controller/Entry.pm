package MojoMvcTutorial::Controller::Entry;

use strict;
use warnings;

use base 'Mojolicious::Controller';

use FormValidator::Lite;

use Mojo::Log;
my $log = Mojo::Log->new();

# This action will render a template
sub list {
    my $c = shift;

    my @entries = $c->app->model->search('entry',{},{});

    # Render template "example/welcome.html.tx" with message
    $c->render(entries => \@entries);
}

sub new_entry {
    my $c = shift;
    $c->render(q => {});
}

sub post {
    my $c = shift;
    $c->redirect_to('/entry/list') unless $c->req->method eq 'POST';

    # validate
    my $validator = FormValidator::Lite->new($c->req);
    my $result = $validator -> check (
        title => [qw/NOT_NULL/],
    );
    if ($validator->has_error) {
        return $c->render(
            template => 'entry/new_entry',
            result   => $result,
            q        => $c->req,
        );
    }

    $c->app->model->create('entry', {
        title => $c->param('title'),
        body  => $c->param('body'),
    });

    $c->redirect_to('/entry/list');
}

1;
