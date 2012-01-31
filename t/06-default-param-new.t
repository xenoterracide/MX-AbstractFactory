use strict;
use warnings;
use Test::More;
use Test::Exception;
use Data::Dumper::Concise;

{
	package My::Factory::Implementation;
	use Moose;

	has connection => (is => 'ro', isa => 'Str');

	sub tweak { 1; };
}

{
	package My::Factory;
	use MooseX::AbstractFactory;

	has connection => (is => 'ro', isa => 'Str');
	__PACKAGE__->meta->make_immutable;
}


my $factory;
lives_ok {
	$factory = My::Factory->new({ connection => 'Type1' })
} "Factory->new() doesn't die";
isa_ok( $factory, 'My::Factory' );
can_ok( $factory, 'connection' );
is( $factory->connection, 'Type1', 'factory connection' );

note Dumper $factory;

my $imp;
lives_ok {
	$imp = My::Factory->create(
    	'Implementation',
	);
} "Factory->create() doesn't die";

isa_ok($imp, "My::Factory::Implementation");

can_ok($imp, qw/tweak/);
is($imp->tweak(),1,"tweak returns 1");
is($imp->connection(), 'Type1', 'connection attr set by constructor');

dies_ok {
	$imp->fudge();
} "fudge dies, not implemented on implementor";

done_testing;
