package Dist::Zilla::Plugin::PodLinkTests;
# ABSTRACT: Dynamically add release tests for POD links

=head1 SYNOPSIS

	# dist.ini
	[PodLinkTests]
	; test = both   ; options: qw(both none linkcheck no404s)

=cut

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';

my @tests = qw(linkcheck no404s);
{
	use Moose::Util::TypeConstraints 1.01;

	has test => (
		is      => 'ro',
		isa     => enum( [ qw(both none), @tests ]),
		default => 'both',
	);

	no Moose::Util::TypeConstraints;
}

# overwrite this sub imported from Data::Section
# to only return desired sections.
sub merged_section_data {
	my ($self) = @_;

	my $selftest = $self->test;
	return {} if $selftest eq 'none';

	my $data = $self->SUPER::merged_section_data();
	return $data if $selftest eq 'both';

	foreach my $test ( @tests ){
		$selftest eq $test
			or delete $data->{"xt/release/pod-$test.t"};
	}

	return $data;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=for Pod::Coverage merged_section_data

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files:

  xt/release/pod-linkcheck.t - a standard Test::Pod::LinkCheck test
  xt/release/pod-no404s.t    - a standard Test::Pod::No404s test

The tests check for the following C<%ENV> variables:

=for :list
* C<$ENV{SKIP_POD_LINK_TESTS}> - skip both
* C<$ENV{SKIP_POD_LINKCHECK}>  - skip L<Test::Pod::LinkCheck>
* C<$ENV{SKIP_POD_NO404S}>     - skip L<Test::Pod::No404s>

=head1 SEE ALSO

=for :list
* L<Test::Pod::LinkCheck>
* L<Test::Pod::No404s>

=cut

__DATA__
___[ xt/release/pod-linkcheck.t ]___
#!perl
use strict; use warnings;

use Test::More;

foreach my $env_skip ( qw(
	SKIP_POD_LINK_TESTS
	SKIP_POD_LINKCHECK
) ){
	plan skip_all => "\$ENV{$env_skip} is set, skipping"
		if $ENV{$env_skip};
}

eval "use Test::Pod::LinkCheck";
if ( $@ ) {
	plan skip_all => 'Test::Pod::LinkCheck required for testing POD';
} else {
	Test::Pod::LinkCheck->new->all_pod_ok;
}
___[ xt/release/pod-no404s.t ]___
#!/usr/bin/perl
use strict; use warnings;

use Test::More;

foreach my $env_skip ( qw(
	SKIP_POD_LINK_TESTS
	SKIP_POD_NO404S
) ){
	plan skip_all => "\$ENV{$env_skip} is set, skipping"
		if $ENV{$env_skip};
}

eval "use Test::Pod::No404s";
if ( $@ ) {
	plan skip_all => 'Test::Pod::No404s required for testing POD';
} else {
	all_pod_files_ok();
}
