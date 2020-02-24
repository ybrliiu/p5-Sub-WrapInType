package Sub::WrapInType;
use 5.010001;
use strict;
use warnings;
use Carp ();
use Hash::Util ();
use Scalar::Util ();
use Type::Params ();
use Exporter qw( import );
use Class::InsideOut qw( register readonly id );

our $VERSION = '0.01_02';
our @EXPORT  = qw( wrap_sub );

readonly params  => my %params;
readonly returns => my %returns;
readonly code    => my %code;

sub new {
  my $class = shift;

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

  {
    my @types = do {
      if (ref $params_types eq 'ARRAY') {
        @$params_types;
      }
      elsif (ref $params_types eq 'HASH') {
        values %$params_types;
      }
      else {
        Carp::croak 'Wrong arguments.'
      }
    };
    for my $type (@types, $return_type) {
      Carp::croak 'Wrong arguments.'
        unless Scalar::Util::blessed($type) && $type->can('check') && $type->can('get_message');
    }
  }

  my $checker = ref $params_types eq 'ARRAY'
    ? Type::Params::compile(@$params_types)
    : Type::Params::compile_named(%$params_types);

  my $typed_code = sub {
    my $return_value = $code->( $checker->(@_) );
    die $return_type->get_message($return_value) unless $return_type->check($return_value);
    $return_value;
  };

  my $self = bless $typed_code, $class;
  register($self);

  {
    my $addr = id $self;
    $params{$addr}  = $params_types;
    $returns{$addr} = $return_type;
    $code{$addr}    = $code;
  }

  $self;
}

sub wrap_sub {
  __PACKAGE__->new(@_);
}

1;

__END__

=encoding utf-8

=head1 NAME

Sub::WrapInType - Wrap the subroutine to validate the argument type and return type.

=head1 SYNOPSIS

  use Test2::V0;
  use Types::Standard -types;
  use Sub::WrapInType;

  my $sum = wrap_sub [ Int, Int ], Int, sub {
    my ($x, $y) = @_;
    $x + $y;
  };
  $sum->('foo'); # Error!
  $sum->(2, 5); # 7

  my $subtract = wrap_sub [ Int, Int ], Int, sub {
    my ($x, $y) = @_;
    "$x - $y";
  };
  $subtract->(5, 2); # Returns string '5 - 2', error!

=head1 DESCRIPTION

Sub::WrapInType is wrap the subroutine to validate the argument type and return type.

=head1 FUNCTIONS

=head2 wrap_sub(\@parameter_types, $return_type, $subroutine)

If you pass type constraints of parameters, a return type constraint, and a subroutine to this function,
Returns the subroutine wrapped in the process of checking the arguments given in the parameter's type constraints and checking the return value with the return value's type constraint.

The type constraint expects to be passed an object of Type::Tiny.

This is a wrapper for the constructor.

=head1 METHODS

=head2 new(\@parameter_types, $return_type, $subroutine)

Constract a new Sub::WrapInType object.

  use Types::Standard -types;
  use Sub::WrapInType;
  my $wraped_sub = Sub::WrapInType->new([Int, Int] => Int, sub { $_[0] + $_[1] });

=head1 LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mp0liiu E<lt>mpoliiu@cpan.orgE<gt>

=cut

