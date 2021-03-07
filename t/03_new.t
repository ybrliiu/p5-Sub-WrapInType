use Test2::V0;
use Types::Standard qw( Int );
use Sub::WrapInType ();

sub twice { $_[0] * 2 }

subtest 'named / without opts' => sub {
    my $typed_code = Sub::WrapInType->new(
        params => [Int],
        isa    => Int,
        code   => \&twice,
    );

    isa_ok $typed_code, 'Sub::WrapInType';
    is $typed_code->code, \&twice;
    ok !$typed_code->is_method;
};

subtest 'named / with opts' => sub {
    my $typed_code = Sub::WrapInType->new(
        params  => [Int],
        isa     => Int,
        code    => \&twice,
        options => { skip_invocant => 1 },
    );

    isa_ok $typed_code, 'Sub::WrapInType';
    is $typed_code->code, \&twice;
    ok $typed_code->is_method;
};

subtest 'sequenced / without opts' => sub {
    my $typed_code = Sub::WrapInType->new(
        [Int],
        Int,
        \&twice,
    );

    isa_ok $typed_code, 'Sub::WrapInType';
    is $typed_code->code, \&twice;
    ok !$typed_code->is_method;
};

subtest 'sequenced / with opts' => sub {
    my $typed_code = Sub::WrapInType->new(
        [Int],
        Int,
        \&twice,
        { skip_invocant => 1 },
    );

    isa_ok $typed_code, 'Sub::WrapInType';
    is $typed_code->code, \&twice;
    ok $typed_code->is_method;
};


subtest 'named ref / without opts' => sub {
    my $typed_code = Sub::WrapInType->new({
        params => [Int],
        isa    => Int,
        code   => \&twice,
    });

    isa_ok $typed_code, 'Sub::WrapInType';
    is $typed_code->code, \&twice;
    ok !$typed_code->is_method;
};

subtest 'named ref / with opts' => sub {
    my $typed_code = Sub::WrapInType->new({
        params  => [Int],
        isa     => Int,
        code    => \&twice,
        options => { skip_invocant => 1 },
    });

    isa_ok $typed_code, 'Sub::WrapInType';
    is $typed_code->code, \&twice;
    ok $typed_code->is_method;
};

done_testing;
