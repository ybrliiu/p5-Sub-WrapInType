[![Build Status](https://circleci.com/gh/ybrliiu/p5-Sub-Anon-Typed.svg)](https://circleci.com/gh/ybrliiu/p5-Sub-Anon-Typed) [![Coverage Status](http://codecov.io/github/ybrliiu/p5-Sub-Anon-Typed/coverage.svg?branch=master)](https://codecov.io/github/ybrliiu/p5-Sub-Anon-Typed?branch=master)
# NAME

AnonSub::Typed - Create simple typed anonymous subroutine easily.

# SYNOPSIS

    use Test2::V0;
    use AnonSub::Typed;

    my $sum = anon [ Int, Int ], Int, sub {
      my ($x, $y) = @_;
      $x + $y;
    };
    is $sum->(2, 5), 7;
    done_testing;

# DESCRIPTION

AnonSub::Typed is create simple typed anonymous subroutine easily.

# LICENSE

Copyright (C) ybrliiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ybrliiu <raian@reeshome.org>
