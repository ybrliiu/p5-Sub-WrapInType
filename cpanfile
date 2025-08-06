requires 'perl', '5.010001';
requires 'Exporter';
requires 'Type::Tiny', '2.004000';
requires 'Class::InsideOut';
requires 'namespace::autoclean';
requires 'Sub::Util', '1.40';

on 'configure' => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on 'test' => sub {
  requires 'Test2::Suite', '0.000071';
};

