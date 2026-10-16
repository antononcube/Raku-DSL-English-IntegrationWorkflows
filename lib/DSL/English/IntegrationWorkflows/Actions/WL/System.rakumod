use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::English::WL::PipelineCommand;
use DSL::Shared::Actions::WL::PredicateSpecification;

class DSL::English::IntegrationWorkflows::Actions::WL::System
        is DSL::Shared::Actions::English::WL::PipelineCommand
        is DSL::Shared::Actions::WL::PredicateSpecification {

    method wl-function(Str:D $function --> Str:D) { $function.trans('*' => '&') }

    method inferred-variable(Str:D $function --> Str:D) {
        my @variables = $function.comb(/<[a..z]>/);
        @variables ?? @variables[*-1].Str !! 'x'
    }

    method integration-code(Str:D $function, Str:D $variable, Str:D $range, Str:D $options = '' --> Str:D) {
        'NIntegrate[' ~ self.wl-function($function) ~ ', {' ~ $variable ~ ',' ~ $range ~ '}'
            ~ ($options.chars ?? ', ' ~ $options !! '') ~ ']'
    }

    method TOP($/) { make $<workflow-command>.made; }
    method workflow-commands-list($/) { make $<workflow-command>>>.made.join(";\n"); }
    method workflow-command($/) { make $/.values[0].made; }
    method integration-command($/) { make $/.values[0].made; }

    method command-integrate-and-plot($/) {
        my $function = $<function-spec>.made;
        my $variable = $<variable-range-spec>
            ?? $<variable-range-spec><variable-name>.made
            !! self.inferred-variable($function);
        my $range = $<variable-range-spec>
            ?? $<variable-range-spec><range>.made
            !! $<range>.made;
        my $options = $<integration-options-spec>
            ?? $<integration-options-spec>.made
            !! '';
        my $integral = self.integration-code($function, $variable, $range, $options);

        if $<plot-phrase> {
            make '{' ~ $integral ~ ', Plot[' ~ self.wl-function($function)
                ~ ', {' ~ $variable ~ ',' ~ $range ~ '}]}';
        } else {
            make $integral;
        }
    }

    method command-integrate-short($/) {
        my $function = $<function-spec>.made;
        my $variable = self.inferred-variable($function);
        make 'NIntegrate[' ~ self.wl-function($function) ~ ', ' ~ $variable ~ ']';
    }

    method function-spec($/) { make $/.Str.trim; }
    method variable-range-spec($/) { make $<range>.made; }
    method range($/) { make $/.values[0].made; }
    method range-interval($/) { make $<range-boundary>>>.made.join(','); }
    method range-bracket-interval($/) { make $<range-boundary>>>.made.join(','); }
    method range-named($/) {
        my $range = do given $/.Str {
            when 'R+' { '0,Infinity' }
            when 'R-' { '-Infinity,0' }
            default   { '-Infinity,Infinity' }
        };
        make $range;
    }
    method range-boundary($/) {
        my $boundary = $/.Str;
        $boundary = 'Infinity'  if $boundary eq 'Inf' || $boundary eq '+Inf' || $boundary eq 'Infinity' || $boundary eq '+Infinity' || $boundary eq '∞' || $boundary eq '+∞';
        $boundary = '-Infinity' if $boundary eq '-Inf' || $boundary eq '-Infinity' || $boundary eq '-∞';
        make $boundary;
    }

    # NIntegrate options
    method integration-options-spec($/) { make $<integration-option>>>.made.join(', '); }
    method integration-option($/) { make $/.values[0].made; }
    method integration-method-option($/) { make $/.values[0].made; }
    method local-adaptive-strategy($/) { make 'Method -> "LocalAdaptive"'; }
    method global-adaptive-strategy($/) { make 'Method -> "GlobalAdaptive"'; }
    method precision-goal-option($/) { make 'PrecisionGoal -> ' ~ $<number-value>.made; }
    method accuracy-goal-option($/) { make 'AccuracyGoal -> ' ~ $<number-value>.made; }
    method max-recursion-option($/) { make 'MaxRecursion -> ' ~ $<integer-value>.made; }

}
