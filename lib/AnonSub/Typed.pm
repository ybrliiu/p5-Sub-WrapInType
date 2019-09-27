package AnonSub::Typed;
use 5.010001;
use strict;
use warnings;
use Carp ();
use Hash::Util ();
use Scalar::Util ();
use Type::Params ();
use Exporter qw( import );
use Class::InsideOut qw( register readonly id );

our $VERSION   = '0.01';
our @EXPORT    = qw( anon );
our @EXPORT_OK = qw( get_info );

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
    $params{$addr} = $params_types;
    $returns{$addr}    = $return_type;
    $code{$addr}   = $code;
  }

  $self;
}

sub anon {
  __PACKAGE__->new(@_);
}

1;

__END__

=encoding utf-8

=head1 NAME

AnonSub::Typed - Create simple typed anonymous subroutine easily.

=head1 SYNOPSIS

    use Test2::V0;
    use AnonSub::Typed;

    my $sum = anon [ Int, Int ], Int, sub {
      my ($x, $y) = @_;
      $x + $y;
    };
    is $sum->(2, 5), 7;
    done_testing;

=head1 DESCRIPTION

AnonSub::Typed is create simple typed anonymous subroutine easily.

=head1 LICENSE

Copyright (C) ybrliiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ybrliiu E<lt>raian@reeshome.orgE<gt>

=cut

