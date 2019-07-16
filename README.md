# NAME

Sub::TypedAnon - Create simple typed anonymous subroutine.

# SYNOPSIS

    use Sub::TypedAnon;

    my $sum = anon [ Int, Int ], Int, sub {
      my ($x, $y) = @_;
      $x + $y;
    };
    is $sum->(2, 5), 7;

# DESCRIPTION

Sub::TypedAnon create simple typed anonymous subroutine.

# LICENSE

Copyright (C) ybrliiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ybrliiu <raian@reeshome.org>
