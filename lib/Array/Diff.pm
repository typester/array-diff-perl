package Array::Diff;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;

use Algorithm::Diff;
eval q{ use Algorithm::Diff::XS; };

our $VERSION = '0.04';

__PACKAGE__->mk_accessors(qw/added deleted count diff_class/);

=head1 NAME

Array::Diff - Diff two arrays

=head1 SYNOPSIS

    my @old = ( 'a', 'b', 'c' );
    my @new = ( 'b', 'c', 'd' );
    
    my $diff = Array::Diff->diff( \@old, \@new );
    
    $diff->count   # 2
    $diff->added   # [ 'd' ];
    $diff->deleted # [ 'a' ];

=head1 DESCRIPTION

This module do diff two arrays, and return added and deleted arrays.
It's simple usage of Algorithm::Diff.

And if you need more complex array tools, check L<Array::Compare>.

=head1 SEE ALSO

L<Algorithm::Diff>

=head1 METHODS

=head2 new

=cut

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{diff_class} ||= $INC{'Algorithm/Diff/XS.pm'} ? 'Algorithm::Diff::XS' : 'Algorithm::Diff';

    $self;
}

=head2 diff

=cut

sub diff {
    my ( $self, $old, $new ) = @_;
    $self = $self->new unless ref $self;

    $self->added(   [] );
    $self->deleted( [] );
    $self->count( 0 );

    my $diff = $self->diff_class->new( $old, $new );
    while ( $diff->Next ) {
        next if $diff->Same;

        $self->{count}++;

        push @{ $self->{deleted} }, $diff->Items(1)
            if $diff->Items(1);

        push @{ $self->{added} }, $diff->Items(2)
            if $diff->Items(2);
    }

    $self;
}

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
