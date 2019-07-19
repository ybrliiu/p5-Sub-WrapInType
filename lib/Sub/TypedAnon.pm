package Sub::TypedAnon;
use 5.010001;
use strict;
use warnings;
use Carp ();
use Hash::Util ();
use Scalar::Util ();
use Type::Params ();
use Exporter qw( import );

our $VERSION   = '0.01';
our @EXPORT    = qw( anon );
our @EXPORT_OK = qw( get_info );

sub anon {
  my ($params_types, $return_type, $code) = do {
    if (@_ == 3) {
      @_;
    }
    elsif (@_ == 6) {
      my %args = @_;
      my @valid_args = grep { defined } map { $args{$_} } qw( params isa code );
      @valid_args == 3 ? @valid_args : Carp::croak 'Wrong arguments.';
    }
    else {
      Carp::croak 'Wrong arguments.';
    }
  };

  for my $type (@$params_types, $return_type) {
    Carp::croak 'Wrong arguments.'
      unless Scalar::Util::blessed($type) && $type->can('check') && $type->can('get_message');
  }

  my $typed_code = sub {
    state $check = Type::Params::compile(@$params_types);
    my $return_value = $code->( $check->(@_) );
    die $return_type->get_message($return_value) unless $return_type->check($return_value);
    $return_value;
  };

  _store_info($typed_code, $params_types, $return_type, $code);

  $typed_code;
}

{
  my %Info;

  sub _store_info {
    my ($typed_code, $params_types, $return_type, $code) = @_;
    $Info{ $typed_code . '' } = Hash::Util::lock_hashref({
      isa    => $return_type,
      params => $params_types,
      code   => $code,
    });
  }

  sub get_info {
    my $typed_code = shift;
    Carp::croak 'Wrong arguments.' unless defined $typed_code && ref $typed_code eq 'CODE';
    $Info{ $typed_code . '' };
  }
}

1;

__END__

=encoding utf-8

=head1 NAME

Sub::TypedAnon - Create simple typed anonymous subroutine easily.

=head1 SYNOPSIS

    use Test2::V0;
    use Sub::TypedAnon;

    my $sum = anon [ Int, Int ], Int, sub {
      my ($x, $y) = @_;
      $x + $y;
    };
    is $sum->(2, 5), 7;
    done_testing;

=head1 DESCRIPTION

Sub::TypedAnon is create simple typed anonymous subroutine easily.

=head1 LICENSE

Copyright (C) ybrliiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ybrliiu E<lt>raian@reeshome.orgE<gt>

=cut

