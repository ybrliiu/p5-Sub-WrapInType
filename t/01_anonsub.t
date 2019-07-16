use 5.010001;
use strict;
use warnings;
use Test2::V0;
use Types::Standard qw( Int );
use Sub::TypedAnon;

subtest 'Create typed anonymous subroutine' => sub {
  
  ok lives {
    anon [ Int, Int ], Int, sub {
      my ($x, $y) = @_;
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

  ok dies { anon }, 'Too few arguments.';

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
  }, 'Wrong key.'
  
};

subtest 'Run typed anonymous subroutine' => sub {

  my $sum = anon [ Int, Int ], Int, sub {
    my ($x, $y) = @_;
    $x + $y;
  };
  is $sum->(2, 5), 7;

};

done_testing;
