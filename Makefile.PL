require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'PPI::Tester',
	'VERSION_FROM' => 'lib/PPI/Tester.pm',
	'PREREQ_PM'    => {
		# Application dependencies
		PPI        => 0.814,
		Wx         => 0.19,

		# Test dependencies
		Test::More => 0,
	},
	'EXE_FILES' => [
		# The point of this entire exercise
		'bin/ppitester',
	],
	($] >= 5.005) ? (
		'AUTHOR'   => 'Adam Kennedy (cpan@ali.as)',
		'ABSTRACT' => 'A wxPerl-based interactive PPI debugger/tester',
	) : (),
);
