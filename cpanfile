requires 'perl', '5.010001';
requires 'Carp';
requires 'Exporter';
requires 'Type::Tiny';
requires 'Hash::Util';
requires 'Scalar::Util';
requires 'Class::InsideOut';

on 'test' => sub {
  requires 'Test2::Suite';
};

