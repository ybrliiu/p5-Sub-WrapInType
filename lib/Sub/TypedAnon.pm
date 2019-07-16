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
      my @args = grep { defined } map { $args{$_} } qw( params isa code );
      @args == 3 ? @args : Carp::croak 'Wrong arguments.';
    }
    else {
      Carp::croak 'Wrong arguments.';
    }
  };

  for my $type (@$params_types, $return_type) {
    Carp::croak 'Wrong arguments.'
      unless Scalar::Util::blessed($type) && $type->can('check') && $type->can('get_message');
  }

  _store_info($params_types, $return_type, $code);

  sub {
    state $check = Type::Params::compile(@$params_types);
    my $return_value = $code->( $check->(@_) );
    die $return_type->get_message($return_value) unless $return_type->check($return_value);
    $return_value;
  };
}

{
  my %Info;

  sub _store_info {
    my ($params_types, $return_type, $code) = @_;
    $Info{ $code . '' } = Hash::Util::lock_hashref({
      isa    => $return_type,
      params => $params_types,
      code   => $code,
    });
  }

  sub get_info {
    my $code = shift;
    Carp::croak 'Wrong arguments.' unless defined $code && ref $code eq 'CODE';
    $Info{ $code . '' };
  }
}

1;
__END__

=encoding utf-8

=head1 NAME

Sub::TypedAnon - It's new $module

=head1 SYNOPSIS

    use Sub::TypedAnon;

=head1 DESCRIPTION

Sub::TypedAnon is ...

=head1 LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mp0liiu E<lt>raian@reeshome.orgE<gt>

=cut

