use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::English::WL::PipelineCommand;
use DSL::Shared::Actions::WL::PredicateSpecification;

class DSL::English::IntegrationWorkflows::Actions::WL::System
        is DSL::Shared::Actions::English::WL::PipelineCommand
        is DSL::Shared::Actions::WL::PredicateSpecification {

    method wl-function(Str:D $function --> Str:D) { $function.trans('*' => '&') }

    method inferred-variables(Str:D $function, Int:D $dimensions = 1 --> Array:D) {
        my @characters = $function.comb(/<[a..z]>/);
        my @variables = @characters.reverse.unique.head($dimensions).reverse;
        my @fallback = <x y z u v w>;
        @variables.push: @fallback[@variables.elems] while @variables.elems < $dimensions;
        @variables.Array
    }

    method inferred-variable(Str:D $function --> Str:D) { self.inferred-variables($function)[0] }

    method integration-code(Str:D $function, @iterators, Str:D $options = '' --> Str:D) {
        'NIntegrate[' ~ self.wl-function($function) ~ ', ' ~ @iterators.join(', ')
            ~ ($options.chars ?? ', ' ~ $options !! '') ~ ']'
    }

    method TOP($/) { make $<workflow-command>.made; }
    method workflow-commands-list($/) { make $<workflow-command>>>.made.join(";\n"); }
    method workflow-command($/) { make $/.values[0].made; }
    method integration-command($/) { make $/.values[0].made; }

    method command-integrate-and-plot($/) {
        my $function = $<function-spec>.made;
        my $function-source = $<function-spec>.Str;
        my @iterators;
        if $<domain-range-spec> {
            my @ranges = $<domain-range-spec><range-bracket-interval>>>.made;
            my @variables = self.inferred-variables($function-source, @ranges.elems);
            for @ranges.kv -> $i, $range {
                @iterators.push: '{' ~ @variables[$i] ~ ',' ~ $range ~ '}';
            }
        } else {
            my $variable = $<variable-range-spec>
                ?? $<variable-range-spec><variable-name>.made
                !! self.inferred-variable($function-source);
            my $range = $<variable-range-spec>
                ?? $<variable-range-spec><range>.made
                !! $<range>.made;
            @iterators.push: '{' ~ $variable ~ ',' ~ $range ~ '}';
        }
        my $options = $<integration-options-spec>
            ?? $<integration-options-spec>>>.made.join(', ')
            !! '';
        my $integral = self.integration-code($function, @iterators, $options);

        if $<plot-phrase> {
            my $iterator = @iterators[0];
            make '{' ~ $integral ~ ', Plot[' ~ self.wl-function($function)
                ~ ', ' ~ $iterator ~ ']}';
        } else {
            make $integral;
        }
    }

    method command-integrate-short($/) {
        my $function = $<function-spec>.made;
        my $variable = self.inferred-variable($function);
        make 'NIntegrate[' ~ self.wl-function($function) ~ ', ' ~ $variable ~ ']';
    }

    method function-spec($/) {
        make $<latex-function-spec> ?? $<latex-function-spec>.made
            !! ($<plain-function-spec> ?? $<plain-function-spec>.made !! $/.Str.trim);
    }
    method plain-function-spec($/) { make $/.Str.trim; }
    method latex-function-spec($/) {
        my $latex = $/.Str.substr(1, *-1);
        my $escaped = $latex.subst('\\', '\\\\', :g).subst('"', '\\"', :g);
        make 'ToExpression["' ~ $escaped ~ '", TeXForm]';
    }
    method variable-range-spec($/) { make $<range>.made; }
    method range($/) { make $/.values[0].made; }
    method range-interval($/) { make $<range-boundary>>>.made.join(','); }
    method range-bracket-interval($/) { make $<range-boundary>>>.made.join(','); }
    method domain-range-spec($/) { make $<range-bracket-interval>>>.made; }
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
    method integration-options-spec($/) {
        if $<without-singularity-handling-option> {
            make $<without-singularity-handling-option>.made;
        } elsif $<recursion-levels-option> {
            make $<recursion-levels-option>.made;
        } else {
            make $<integration-option>>>.made.join(', ');
        }
    }
    method integration-option($/) { make $/.values[0].made; }
    method integration-method-option($/) { make 'Method -> "' ~ $<integration-method-name>.made ~ '"'; }
    method integration-method-name($/) { make $/.values[0].made; }
    method adaptive-monte-carlo($/) { make 'AdaptiveMonteCarlo'; }
    method adaptive-quasi-monte-carlo($/) { make 'AdaptiveQuasiMonteCarlo'; }
    method double-exponential($/) { make 'DoubleExponential'; }
    method global-adaptive($/) { make 'GlobalAdaptive'; }
    method local-adaptive($/) { make 'LocalAdaptive'; }
    method monte-carlo($/) { make 'MonteCarlo'; }
    method quasi-monte-carlo($/) { make 'QuasiMonteCarlo'; }
    method even-odd-subdivision($/) { make 'EvenOddSubdivision'; }
    method symbolic-piecewise-subdivision($/) { make 'SymbolicPiecewiseSubdivision'; }
    method unit-cube-rescaling($/) { make 'UnitCubeRescaling'; }
    method cartesian-rule($/) { make 'CartesianRule'; }
    method clenshaw-curtis-rule($/) { make 'ClenshawCurtisRule'; }
    method gauss-kronrod-rule($/) { make 'GaussKronrodRule'; }
    method lobatto-kronrod-rule($/) { make 'LobattoKronrodRule'; }
    method monte-carlo-rule($/) { make 'MonteCarloRule'; }
    method multidimensional-rule($/) { make 'MultidimensionalRule'; }
    method newton-cotes-rule($/) { make 'NewtonCotesRule'; }
    method trapezoidal-rule($/) { make 'TrapezoidalRule'; }
    method precision-goal-option($/) { make 'PrecisionGoal -> ' ~ $<number-value>.made; }
    method accuracy-goal-option($/) { make 'AccuracyGoal -> ' ~ $<number-value>.made; }
    method max-recursion-option($/) { make 'MaxRecursion -> ' ~ $<integer-value>.made; }
    method recursion-levels-option($/) { make 'MaxRecursion -> ' ~ $<integer-value>.made; }
    method without-singularity-handling-option($/) { make 'Method -> {"GlobalAdaptive", "SingularityHandler" -> None}'; }

}
