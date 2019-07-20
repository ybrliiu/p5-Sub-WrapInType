[![Build Status](https://circleci.com/gh/ybrliiu/p5-Sub-TypedAnon.svg)](https://circleci.com/gh/ybrliiu/p5-Sub-TypedAnon) [![Coverage Status](http://codecov.io/github/ybrliiu/p5-Sub-TypedAnon/coverage.svg?branch=master)](https://codecov.io/github/ybrliiu/p5-Sub-TypedAnon?branch=master)
# NAME

Sub::TypedAnon - Create simple typed anonymous subroutine easily.

# SYNOPSIS

    use Test2::V0;
    use Sub::TypedAnon;

    my $sum = anon [ Int, Int ], Int, sub {
      my ($x, $y) = @_;
      $x + $y;
    };
    is $sum->(2, 5), 7;
    done_testing;

# DESCRIPTION

Sub::TypedAnon is create simple typed anonymous subroutine easily.

# LICENSE

Copyright (C) ybrliiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ybrliiu <raian@reeshome.org>
