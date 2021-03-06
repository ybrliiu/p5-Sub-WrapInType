use Test2::V0;
use Types::Standard qw( Int );
use Sub::WrapInType qw( wrap_method );

sub add {
    my $class = shift;
    my ($a, $b) = @_;
    $a + $b;
};

sub add_multi {
    my $class = shift;
    my ($a, $b) = @_;
    $a + $b, $a * $b
}

subtest 'single return type' => sub {
    my $typed_code = wrap_method [Int, Int] => Int, \&add;
    is $typed_code->(__PACKAGE__, 2, 3), 5;
};

subtest 'multi return types' => sub {
    my $typed_code = wrap_method [Int, Int] => [Int, Int], \&add_multi;
    my @returns = $typed_code->(__PACKAGE__, 2, 3);
    is \@returns, [5, 6];
};

done_testing;
