package PPI::Tester;

# The PPI Tester application

use strict;

# The very first version
use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.02';
}

# Load in the PPI classes
use PPI::Lexer       ();
use PPI::Lexer::Dump ();

# Load in the wxWindows library
use Wx;
sub new { PPI::Tester::App->new };





#####################################################################
package PPI::Tester::App;

# The main application class

use base 'Wx::App';

use constant APPLICATION_NAME => 'PPI Tester';

sub OnInit {
	my $self = shift;
	$self->SetAppName(APPLICATION_NAME);

	# Create the one and only frame
	my $Frame = PPI::Tester::Window->new(
		undef,               # Parent Window
		-1,                  # Id
		APPLICATION_NAME,    # Title
		[-1,-1],             # Default size
		[-1,-1],             # Default position
		);

	# Set it as the top window and show it
	$self->SetTopWindow($Frame);
	$Frame->Show(1);

	# So an initial parse
	$Frame->debug;

	1;
}





#####################################################################
package PPI::Tester::Window;

# The main window for the application

use base 'Wx::Frame';
use Wx        qw{:everything};
use Wx::Event 'EVT_TOOL',
              'EVT_TEXT';

use constant CMD_CLEAR => 1;
use constant CMD_LOAD  => 2;
use constant CMD_DEBUG => 3;
use constant CODE_BOX  => 4;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);

	# Create and populate the toolbar
	$self->CreateToolBar( wxNO_BORDER | wxTB_HORIZONTAL );
	$self->GetToolBar->AddTool( CMD_CLEAR, 'Clear', wxNullBitmap );
	$self->GetToolBar->AddTool( CMD_LOAD,  'Load',  wxNullBitmap );
	# $self->GetToolBar->AddSeparator;
	# $self->GetToolBar->AddTool( CMD_DEBUG, 'Debug', wxNullBitmap );
	$self->GetToolBar->Realize;

	# Bind the events for the toolbar
	EVT_TOOL( $self, CMD_CLEAR, \&clear );
	EVT_TOOL( $self, CMD_LOAD,  \&load  );
	# EVT_TOOL( $self, CMD_DEBUG, \&debug );

	# Create the split window with the two panels in it
	my $Splitter = Wx::SplitterWindow->new( $self, -1 );
	my $Left     = Wx::Panel->new( $Splitter, -1 );
	my $Right    = Wx::Panel->new( $Splitter, -1 );
	$Splitter->SplitVertically( $Left, $Right, 0 );

	# Create the resizing code textbox for the left side
	$Left->SetSizer( Wx::BoxSizer->new(wxHORIZONTAL) );
	$Left->GetSizer->Add(
		$self->{Code} = Wx::TextCtrl->new(
			$Left,                 # Parent panel,
			CODE_BOX,
			'my $code = "here";',  # Help new users get a clue
			wxDefaultPosition,     # Normal position
			wxDefaultSize,         # Default size
			wxTE_PROCESS_TAB | wxTE_MULTILINE,
			),
		1,
		wxEXPAND,
		);
	$Left->SetAutoLayout(1);

	# Update the output on every code box change
	EVT_TEXT( $self, CODE_BOX, \&debug );

	# Create the resizing output textbox for the right side
	$Right->SetSizer( Wx::BoxSizer->new(wxHORIZONTAL) );
	$Right->GetSizer->Add(
		$self->{Output} = Wx::TextCtrl->new(
			$Right,                         # Parent panel,
			-1,
			'',                             # Help new users get a clue
			wxDefaultPosition,              # Normal position
			wxDefaultSize,                  # Minimum size
			wxTE_READONLY | wxTE_MULTILINE, # You can't change this stuff
			),
		1,
		wxEXPAND,
		);
	$Right->SetAutoLayout(1);

	# Create the lexing and debugging objects
	$self->{Lexer} = PPI::Lexer->new;

	$self;
}

# Clear the two test areas
sub clear {
	my $self = shift;
	$self->{Code}->Clear;
	$self->{Output}->Clear;
	1;
}

# Load a file
sub load {
	my $self = shift;
	$self->_error("Incomplete. Later, this will load a file");
}

# Do a processing run
sub debug {
	my $self = shift;
	my $source = $self->{Code}->GetValue
		or return $self->_error("Nothing to parse");

	# Parse and dump the content
	my $Document = $self->{Lexer}->lex_source( $source )
		or return $self->_error("Error during lex");
	my $Dumper = PPI::Lexer::Dump->new( $Document, indent => 4 )
		or return $self->_error("Failed to created PPI::Document dumper");
	my $output = $Dumper->dump_string
		or return $self->_error("Dumper failed to generate output");
	$self->{Output}->SetValue( $output );

	1;
}

sub _error {
	my $self = shift;
	my $message = join "\n", @_;
	$self->{Output}->SetValue( $message );

	1;
}

1;

=pod

=head1 NAME

PPI::Tester - A wxPerl-based interactive PPI debugger/tester

=head1 DESCRIPTION

This package implements a wxWindows desktop application which provides the
ability to interactively test the PPI perl parser.

The C<PPI::Tester> module implements the application, but is itself of no
use to the user. The launcher for the application 'ppitester' is installed
with this module, and can be launched by simply typing the following from
the command line.

  ppitester

When launched, the application consists of two vertical panels. The left
panel is where you should type in your code sample. As the left hand panel
is changed, a PPI::Lexer::Dump output is continuously updated in the right
hand panel.

There is a toolbar at the top of the application with two icon buttons,
currently without icons. The first toolbar button clears the panels, the
second is a placeholder for loading in code from a file, and is not yet
implemented. ( It's early days yet for this application ).

=head1 TO DO

- The "Load file" toolbar button does not work yet

- There are no icons on the toolbar buttons

- An option is needed to save both the left and right panels into
  a matching pair of files, compatible with the lexer testing script.

=head1 SUPPORT

To file a bug against this module, in a way you can keep track of, see the CPAN
bug tracking system.

  http://rt.cpan.org/NoAuth/ReportBug.html?Queue=PPI%3A%3ATester

For general comments, contact the author.

=head1 AUTHOR

        Adam Kennedy ( maintainer )
        cpan@ali.as
        http://ali.as/

=head1 SEE ALSO

L<PPI::Manual>, http://ali.as/CPAN/PPI

=head1 COPYRIGHT

Copyright (c) 2004 Adam Kennedy. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
