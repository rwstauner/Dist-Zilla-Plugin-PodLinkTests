package Dist::Zilla::Plugin::PodLinkTests;
# ABSTRACT: Dynamically add release tests for POD links

=head1 SYNOPSIS

	# dist.ini
	[PodLinkTests]

=cut

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';


__PACKAGE__->meta->make_immutable;
no Moose;

1;

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files:

  xt/release/pod-linkcheck.t - a standard Test::Pod::LinkCheck test

=head1 SEE ALSO

=for :list
* L<Test::Pod::LinkCheck>

=cut

__DATA__
___[ xt/release/pod-linkcheck.t ]___
#!perl
use strict; use warnings;

use Test::More;

eval "use Test::Pod::LinkCheck";
if ( $@ ) {
	plan skip_all => 'Test::Pod::LinkCheck required for testing POD';
} else {
	Test::Pod::LinkCheck->new->all_pod_ok;
}
