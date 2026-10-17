use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::Russian::PipelineCommand;
use DSL::Shared::Actions::Russian::Standard::PipelineCommand;

class DSL::English::IntegrationWorkflows::Actions::Russian::Standard
        does DSL::Shared::Actions::Russian::Standard::PipelineCommand
        is DSL::Shared::Actions::Russian::PipelineCommand {

    # Top-level grammar structure
    method TOP($/) { make $<workflow-command>.made; }
    method workflow-commands-list($/) { make $<workflow-command>>>.made.join("\n"); }
    method workflow-command($/) { make $/.values[0].made; }
    method integration-command($/) { make $/.values[0].made; }

    # Integration requests
    method command-integrate-and-plot($/) {
        my $kind = self.integration-kind($/);
        my $statement = 'вычислить' ~ $kind ~ ' интеграл функции '
            ~ $<function-spec>.made;

        if $<variable-range-spec> {
            $statement ~= ' на интервале ' ~ $<variable-range-spec><range>.made;
        } elsif $<range> {
            $statement ~= ' на интервале ' ~ $<range>.made;
        }

        $statement ~= ' и построить график' if $<plot-phrase>;
        make $statement;
    }

    method command-integrate-short($/) {
        make 'вычислить' ~ self.integration-kind($/) ~ ' интеграл функции '
            ~ $<function-spec>.made;
    }

    method integration-kind($/ --> Str:D) {
        my $request = $<integral-request> // $<integrate-directive>;
        my $text = $request.Str.lc;
        return ' символический' if $text.contains('symbolic');
        return ' численный' if $text.contains('numerical');
        ''
    }

    # Mathematical expression and range rendering
    method function-spec($/) { make $/.Str.trim; }
    method variable-range-spec($/) { make $<range>.made; }
    method range($/) { make $/.values[0].made; }
    method range-interval($/) { make '[' ~ $<range-boundary>>>.made.join(', ') ~ ']'; }
    method range-bracket-interval($/) { make '[' ~ $<range-boundary>>>.made.join(', ') ~ ']'; }
    method range-named($/) {
        my $range = do given $/.Str {
            when 'R+' { '[0, ∞)' }
            when 'R-' { '(-∞, 0]' }
            default   { '(-∞, ∞)' }
        };
        make $range;
    }
    method range-boundary($/) { make $/.Str; }

}
