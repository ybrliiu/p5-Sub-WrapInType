requires 'perl', '5.010001';
requires 'Exporter';
requires 'Type::Tiny', '1.012000';
requires 'Class::InsideOut';
requires 'namespace::autoclean';

on 'test' => sub {
  requires 'Test2::Suite', '0.000071';
};

