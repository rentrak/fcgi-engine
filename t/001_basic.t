#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Moose;

BEGIN {
    use_ok('FCGI::Engine');
}

{
    package Foo;
    sub handler { ::pass("... handler was called") }
}

@ARGV = ();

my $e = FCGI::Engine->new_with_options(handler_class => 'Foo');
isa_ok($e, 'FCGI::Engine');
does_ok($e, 'MooseX::Getopt');

ok(!$e->is_listening, '... we are not listening');
is($e->nproc, 1, '... we have the default 1 proc');
ok(!$e->has_pidfile, '... we have no pidfile');
ok(!$e->should_detach, '... we shouldnt daemonize');
is($e->manager, 'FCGI::Engine::ProcManager', '... we have the default manager (FCGI::ProcManager)');

ok(!$e->has_pre_fork_init, '... we dont have any pre-fork-init');

eval { $e->run }; 
ok(!$@, '... we ran the handler okay');

