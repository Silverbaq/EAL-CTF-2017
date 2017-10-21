use strict;
use warnings;
use 5.006; # warnings
package Software::License;
{
  $Software::License::VERSION = '0.103004';
}
# ABSTRACT: packages that provide templated software licenses

use Data::Section -setup => { header_re => qr/\A__([^_]+)__\Z/ };
use Sub::Install ();
use Text::Template ();

my %short_name = (
  'GPL-1'  => 'GPL_1',
  'GPL-1+' => 'GPL_1_plus',
  'GPL-2'  => 'GPL_2',
  'GPL-2+' => 'GPL_2_plus',
  'GPL-3'  => 'GPL_3',
  'GPL-3+' => 'GPL_3_plus',
  'LGPL-2' => 'LGPL_2',
  'LGPL-2+' => 'LGPL_2_plus',
  'LGPL-2.1' => 'LGPL_2_1',
  'LGPL-2.1+' => 'LGPL_2_1_plus',
  'LGPL-3'   => 'LGPL_3_0',
  'LGPL-3.0' => 'LGPL_3_0',
  'LGPL-3+'   => 'LGPL_3_0_plus',
  'LGPL-3.0+' => 'LGPL_3_0_plus',
  'Artistic'   => 'Artistic_1_0',
  'Artistic-1' => 'Artistic_1_0',
  'Artistic-2' => 'Artistic_2_0',
);

# Software::License is a virtual class. On the other hand, it's a
# natural entry point to create "real" license using short names.
# Of the 2 solutions provided below, I don't know which one is the best
# (or the worse).

sub new {
  my ($class, $arg) = @_;

  Carp::croak "no copyright holder specified" unless $arg->{holder};

  # This ugly hack avoids having 2 constructors.
  if ($class eq __PACKAGE__ ) {
    return new_from_short_name(@_) ;
  }
  else {
    bless $arg => $class;
  }
}

# here's a second constructor that will provide a real license
sub new_from_short_name {
  my ($class, $arg) = @_;

  Carp::croak "no license short name specified" unless $arg->{short_name};
  my $short = delete $arg->{short_name} ;
  my $lic = $short_name{$short} ;
  Carp::croak "Unknow license with short name $short" unless $lic;

  my $lic_file = my $lic_class = __PACKAGE__.'::'.$lic ;
  $lic_file =~ s!::!/!g ;
  require "$lic_file.pm";
  return $lic_class->new ($arg) ;
}

sub year   { defined $_[0]->{year} ? $_[0]->{year} : (localtime)[5]+1900 }
sub holder { $_[0]->{holder}     }


sub notice { shift->_fill_in('NOTICE') }

sub summary {
    my ($self,$distro) = @_;
    $distro ||= 'debian' ;
    $self->_fill_in(uc($distro).'-SUMMARY');
}

sub license { shift->_fill_in('LICENSE') }


sub fulltext {
  my ($self) = @_;
  return join "\n", $self->notice, $self->license;
}


sub version  {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;
  $pkg =~ s/.+:://;
  my (undef, @vparts) = split /_/, $pkg;

  return unless @vparts;
  return join '.', @vparts;
}


# sub meta1_name    { return undef; } # sort this out later, should be easy
sub meta_name     { return undef; }
sub meta_yml_name { $_[0]->meta_name }

sub meta2_name {
  my ($self) = @_;
  my $meta1 = $self->meta_name;

  return undef unless defined $meta1;

  return $meta1
    if $meta1 =~ /\A(?:open_source|restricted|unrestricted|unknown)\z/;

  return undef;
}

sub _fill_in {
  my ($self, $which) = @_;

  Carp::confess "couldn't build $which section" unless
    my $template = $self->section_data($which);

  return Text::Template->fill_this_in(
    $$template,
    HASH => { self => \$self },
    DELIMITERS => [ qw({{ }}) ],
  );
}


1;



=pod

=head1 NAME

Software::License - packages that provide templated software licenses

=head1 VERSION

version 0.103004

=head1 SYNOPSIS

  my $license = Software::License::Discordian->new({
    holder => 'Ricardo Signes',
  });

  print $output_fh $license->fulltext;

=head1 METHODS

=head2 new

  my $license = $subclass->new(\%arg);

This method returns a new license object for the given license class.  Valid
arguments are:

  holder - the holder of the copyright; required
  year   - the year of copyright; defaults to current year

=head2 new_from_short_name

 my $license = Software::License -> new_from_short_name(
   { short_name => 'GPL-1', %arg }
 );

This constructor will return the correct subclass depending on
C<short_name> value.

=head2 year

=head2 holder

These methods are attribute readers.

=head2 name

This method returns the name of the license, suitable for shoving in the middle
of a sentence, generally with a leading capitalized "The."

=head2 url

This method returns the URL at which a canonical text of the license can be
found, if one is available.  If possible, this will point at plain text, but it
may point to an HTML resource.

=head2 notice

This method returns a snippet of text, usually a few lines, indicating the
copyright holder and year of copyright, as well as an indication of the license
under which the software is distributed.

=head2 license

This method returns the full text of the license.

=head2 fulltext

This method returns the complete text of the license, preceded by the copyright
notice.

=head2 version

This method returns the version of the license.  If the license is not
versioned, this method will return false.

=head2 meta_name

This method returns the string that should be used for this license in the CPAN
META.yml file, according to the CPAN Meta spec v1, or undef if there is no
known string to use.

This method may also be invoked as C<meta_yml_name> for legacy reasons.

=head2 meta2_name

This method returns the string that should be used for this license in the CPAN
META.json or META.yml file, according to the CPAN Meta spec v2, or undef if
there is no known string to use.  If this method does not exist, and
C<meta_name> returns open_source, restricted, unrestricted, or unknown, that
value will be used.

=head2 summary

This method returns a summary of the license. This summary must contains
refer to a file containing the whole license. On Debian system, the file
containing the whole license will be in C</usr/share/common-licenses/>
directory.

=head1 LOOKING UP LICENSE CLASSES

If you have an entry in a F<META.yml> or F<META.json> file, or similar
metadata, and want to look up the Software::License class to use, there are
useful tools in L<Software::LicenseUtils>.

=head1 TODO

=over 4

=item *

register licenses with aliases to allow $registry->get('gpl', 2);

=back

=head1 SEE ALSO

The specific license:

=over 4

=item *

L<Software::License::AGPL_3>

=item *

L<Software::License::Apache_1_1>

=item *

L<Software::License::Apache_2_0>

=item *

L<Software::License::Artistic_1_0>

=item *

L<Software::License::Artistic_2_0>

=item *

L<Software::License::BSD>

=item *

L<Software::License::CC0>

=item *

L<Software::License::FreeBSD>

=item *

L<Software::License::GFDL_1_2>

=item *

L<Software::License::GPL_1>

=item *

L<Software::License::GPL_2>

=item *

L<Software::License::GPL_3>

=item *

L<Software::License::LGPL_2_1>

=item *

L<Software::License::LGPL_3_0>

=item *

L<Software::License::MIT>

=item *

L<Software::License::Mozilla_1_0>

=item *

L<Software::License::Mozilla_1_1>

=item *

L<Software::License::None>

=item *

L<Software::License::OpenSSL>

=item *

L<Software::License::Perl_5>

=item *

L<Software::License::QPL_1_0>

=item *

L<Software::License::SSLeay>

=item *

L<Software::License::Sun>

=item *

L<Software::License::Zlib>

=back

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__DATA__
__NOTICE__
This software is Copyright (c) {{$self->year}} by {{$self->holder}}.

This is free software, licensed under:

  {{ $self->name }}
