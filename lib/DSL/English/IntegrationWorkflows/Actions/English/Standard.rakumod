use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::English::PipelineCommand;
use DSL::Shared::Actions::English::Standard::PipelineCommand;

class DSL::English::IntegrationWorkflows::Actions::English::Standard
        does DSL::Shared::Actions::English::Standard::PipelineCommand
        is DSL::Shared::Actions::English::PipelineCommand {

    # Top-level grammar structure
    method TOP($/) { make $<workflow-command>.made; }
    method workflow-commands-list($/) { make $<workflow-command>>>.made.join("\n"); }
    method workflow-command($/) { make $/.values[0].made; }
    method integration-command($/) { make $/.values[0].made; }

    # Integration requests
    method command-integrate-and-plot($/) {
        my $statement = 'compute the' ~ self.integration-kind($/)
            ~ ' integral of the function ' ~ $<function-spec>.made;

        if $<variable-range-spec> {
            $statement ~= ' over the interval ' ~ $<variable-range-spec><range>.made;
        } elsif $<range> {
            $statement ~= ' over the interval ' ~ $<range>.made;
        }

        $statement ~= ' and plot it' if $<plot-phrase>;
        make $statement;
    }

    method command-integrate-short($/) {
        make 'compute the' ~ self.integration-kind($/)
            ~ ' integral of the function ' ~ $<function-spec>.made;
    }

    method integration-kind($/ --> Str:D) {
        my $request = $<integral-request> // $<integrate-directive>;
        my $text = $request.Str.lc;
        return ' symbolic' if $text.contains('symbolic');
        return ' numerical' if $text.contains('numerical');
        ''
    }

    # Mathematical expression and range rendering
    method function-spec($/) { make $/.Str.trim; }
    method variable-range-spec($/) { make $<range>.made; }
    method range($/) { make $/.values[0].made; }
    method range-interval($/) { make '[' ~ $<range-boundary>>>.made.join(', ') ~ ']'; }
    method range-named($/) {
        my $range = do given $/.Str {
            when 'R+' { '[0, Infinity)' }
            when 'R-' { '(-Infinity, 0]' }
            default   { '(-Infinity, Infinity)' }
        };
        make $range;
    }
    method range-boundary($/) { make $/.Str; }

}
