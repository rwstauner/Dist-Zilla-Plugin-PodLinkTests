# vim: set ts=2 sts=2 sw=2 expandtab smarttab:
use strict;
use warnings;
package Dist::Zilla::Plugin::PodLinkTests;
# ABSTRACT: Deprecated

=head1 SYNOPSIS

This module is B<deprecated> in favor of the simpler/saner
L<Dist::Zilla::Plugin::Test::Pod::LinkCheck>
and
L<Dist::Zilla::Plugin::Test::Pod::No404s>.

Please use those.

  # dist.ini
  [Test::Pod::LinkCheck]
  [Test::Pod::No404s]

This module will be removed in the near future.

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

  my $pre = 'Dist::Zilla::Plugin::Test::Pod::';
  $self->log($_) for (
    '!',
    __PACKAGE__ . " is deprecated.",
    "Use ${pre}LinkCheck and ${pre}No404s instead.",
    '!',
  );

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

See L</SYNOPSIS>.

=head1 SEE ALSO

=for :list
* L<Dist::Zilla::Plugin::Test::Pod::LinkCheck>
* L<Dist::Zilla::Plugin::Test::Pod::No404s>

=cut

__DATA__
___[ xt/release/pod-linkcheck.t ]___
#!perl

use strict;
use warnings;
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
}
else {
  Test::Pod::LinkCheck->new->all_pod_ok;
}
___[ xt/release/pod-no404s.t ]___
#!perl

use strict;
use warnings;
use Test::More;

foreach my $env_skip ( qw(
  SKIP_POD_LINK_TESTS
  SKIP_POD_NO404S
  AUTOMATED_TESTING
) ){
  plan skip_all => "\$ENV{$env_skip} is set, skipping"
    if $ENV{$env_skip};
}

eval "use Test::Pod::No404s";
if ( $@ ) {
  plan skip_all => 'Test::Pod::No404s required for testing POD';
}
else {
  all_pod_files_ok();
}
