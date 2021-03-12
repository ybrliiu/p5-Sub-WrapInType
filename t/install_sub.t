use 5.010001;
use strict;
use warnings;
use Test2::V0;
use Types::Standard qw( Int Undef );
use Sub::WrapInType qw( install_method );

subtest 'Install typed method' => sub {

  ok !__PACKAGE__->can('add');

  my $orig_info = +{
    params => [ Int, Int ],
    isa    => Int,
    code   => sub {
      my ($class, $x, $y) = @_;
      $x + $y;
    },
  };

  install_method(
    name => 'add',
    %$orig_info,
  );

  ok __PACKAGE__->can('add');

  is add(1, 2), 3;

  ok dies { add('string') };

  ok object {
    prop blessed => 'Sub::WrapInType';
    call params    => $orig_info->{params};
    call returns   => $orig_info->{returns};
    call code      => $orig_info->{code};
    call is_method => F;
  };

  {
    local $ENV{PERL_NDEBUG} = 1;
    install_method wrong => Int ,=> Int, sub { undef };
    ok lives { wrong() };
  }

};

done_testing;