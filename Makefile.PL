use inc::Module::Install;

name          ( 'PPI-Tester'                );
abstract      ( 'A wxPerl-based interactive PPI debugger/tester' );
author        ( 'Adam Kennedy<cpan@ali.as>' );
version_from  ( 'lib/PPI/Tester.pm'         );
license       ( 'perl'                      );

requires      ( 'perl'           => '5.005' );
requires      ( 'PPI'            => '0.840' );
requires      ( 'Wx'             => '0.19'  );

build_requires( 'File::Spec'     => '0.82'  );
build_requires( 'Test::More'     => '0.47'  );

# The point of this entire exercise
install_script( 'bin/ppitester' );

auto_install();

&WriteAll;
