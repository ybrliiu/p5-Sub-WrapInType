use 5.010001;
use strict;
use warnings;
use Test2::V0;
use Types::Standard qw( Int );
use AnonSub::Typed qw( anon get_info );

subtest 'Create typed anonymous subroutine' => sub {
  
  ok lives {
    anon [ Int, Int ], Int, sub {
      my ($x, $y) = @_;
      $x + $y;
    };
  };

  ok lives {
    anon +{ x => Int, y => Int }, Int, sub {
      my ($x, $y) = @{ shift() }{qw( x y )};
      $x + $y;
    };
  };
  
  ok lives {
    anon(
      params => [ Int, Int ],
      isa    => Int,
      code   => sub {
        my ($x, $y) = @_;
        $x + $y;
      },
    );
  };

  ok lives {
    anon(
      params => +{
        x => Int,
        y => Int,
      },
      isa    => Int,
      code   => sub {
        my ($x, $y) = @{ shift() }{qw( x y )};
        $x + $y;
      },
    );
  };

  ok dies { anon }, 'Too few arguments.';

  ok dies { anon \(my $anon), Int, sub {} };

  ok dies { anon [ 'Int', 'Int' ], 'Int', sub {} }, 'Arguments is not typeconstraint object.';
  
  ok dies {
    anon(
      params => [ Int, Int ],
      return => Int,
      code   => sub {
        my ($x, $y) = @_;
        $x + $y;
      },
    );
  }, 'Wrong key.';
  
};

subtest 'Run typed anonymous subroutine' => sub {

  my $sum = anon [ Int, Int ], Int, sub {
    my ($x, $y) = @_;
    $x + $y;
  };
  is $sum->(2, 5), 7;

  my $sub = anon +{ x => Int, y => Int }, Int, sub {
    my ($x, $y) = @{ shift() }{qw( x y )};
    $x - $y;
  };
  is $sub->(x => 10, y => 5), 5;

};

subtest 'Confirm get_info' => sub {
  
  my $orig_info = +{
    params => [ Int, Int ],
    isa    => Int,
    code   => sub {
      my ($x, $y) = @_;
      $x + $y;
    },
  };
  my $typed_code = anon @$orig_info{qw( params isa code )};
  is $typed_code->returns . '', $orig_info->{isa} . '';
  is $typed_code->params . '', $orig_info->{params} . '';
  is $typed_code->code, $orig_info->{code};

};

done_testing;
