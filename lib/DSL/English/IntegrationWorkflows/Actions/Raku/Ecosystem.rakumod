use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::English::Raku::PipelineCommand;
use DSL::Shared::Actions::Raku::PredicateSpecification;

class DSL::English::IntegrationWorkflows::Actions::Raku::Ecosystem
        is DSL::Shared::Actions::English::Raku::PipelineCommand
        is DSL::Shared::Actions::Raku::PredicateSpecification {

    method inferred-variables(Str:D $function, Int:D $dimensions = 1 --> Array:D) {
        my @characters = $function.comb(/<[a..z]>/);
        my @variables = @characters.reverse.unique.head($dimensions).reverse;
        my @fallback = <x y z u v w>;
        @variables.push: @fallback[@variables.elems] while @variables.elems < $dimensions;
        @variables.Array
    }

    method inferred-variable(Str:D $function --> Str:D) { self.inferred-variables($function)[0] }

    method raku-function(Str:D $function, @variables --> Str:D) {
        my $expression = $function;
        $expression = $expression.subst('Sin[', 'sin(', :g)
                .subst('Cos[', 'cos(', :g)
                .subst('Exp[', 'exp(', :g)
                .subst('Log[', 'log(', :g)
                .subst('Sqrt[', 'sqrt(', :g)
                .trans(']' => ')')
                .subst('^', ' **', :g);
        for @variables -> $variable {
            $expression = $expression.subst(rx/ << $variable >> /, '$^' ~ $variable, :g);
        }
        '{' ~ $expression ~ '}'
    }

    method raku-method(Str:D $method --> Str:D) {
        my $key = $method.lc.subst(rx/<[\s_\-]>/, '', :g);
        my %methods =
                adaptivemontecarlo => 'adaptive-monte-carlo',
                adaptivequasimontecarlo => 'adaptive-quasi-monte-carlo',
                doubleexponential => 'double-exponential',
                globaladaptive => 'global-adaptive',
                localadaptive => 'local-adaptive',
                montecarlo => 'monte-carlo',
                quasimontecarlo => 'quasi-monte-carlo',
                evenoddsubdivision => 'even-odd-subdivision',
                symbolicpiecewisesubdivision => 'symbolic-piecewise-subdivision',
                unitcuberescaling => 'unit-cube-rescaling',
                cartesianrule => 'cartesian-rule',
                clenshawcurtisrule => 'clenshaw-curtis-rule',
                gausskronrodrule => 'gauss-kronrod-rule',
                lobattokronrodrule => 'lobatto-kronrod-rule',
                montecarlorule => 'monte-carlo-rule',
                multidimensionalrule => 'multidimensional-rule',
                newtoncotesrule => 'newton-cotes-rule',
                trapezoidalrule => 'trapezoidal-rule';
        %methods{$key} // die "Unknown Math::NIntegrate method: $method"
    }

    method integration-code(Str:D $function, @iterators, Str:D $options = '' --> Str:D) {
        'nintegrate(' ~ $function ~ ', ' ~ @iterators.join(', ')
                ~ ($options.chars ?? ', ' ~ $options !! '') ~ ')'
    }

    # Top-level grammar structure
    method TOP($/) { make $<workflow-command>.made; }
    method workflow-commands-list($/) { make $<workflow-command>>>.made.join(";\n"); }
    method workflow-command($/) { make $/.values[0].made; }
    method integration-command($/) { make $/.values[0].made; }

    method command-integrate-and-plot($/) {
        my $function-source = $<function-spec>.Str;
        my @variables;
        my @iterators;
        if $<domain-range-spec> {
            my @ranges = $<domain-range-spec><range-bracket-interval>>>.made;
            @variables = self.inferred-variables($function-source, @ranges.elems);
            for @ranges.kv -> $i, $range {
                @iterators.push: "['{@variables[$i]}'," ~ $range ~ ']';
            }
        } else {
            my $variable = $<variable-range-spec>
                    ?? $<variable-range-spec><variable-name>.made
                    !! self.inferred-variable($function-source);
            my $range = $<variable-range-spec>
                    ?? $<variable-range-spec><range>.made
                    !! $<range>.made;
            @variables = $variable;
            @iterators.push: "['$variable'," ~ $range ~ ']';
        }
        my $function = self.raku-function($<function-spec>.made, @variables);
        my $options = $<integration-options-spec>
                ?? $<integration-options-spec>>>.made.join(', ')
                !! '';
        make self.integration-code($function, @iterators, $options);
    }

    method command-integrate-short($/) {
        my $function-source = $<function-spec>.Str;
        my $variable = self.inferred-variable($function-source);
        make 'nintegrate(' ~ self.raku-function($<function-spec>.made, [$variable]) ~ ", '$variable')";
    }

    # Mathematical expression and range rendering
    method function-spec($/) {
        make $<latex-function-spec> ?? $<latex-function-spec>.made
        !! ($<plain-function-spec> ?? $<plain-function-spec>.made !! $/.Str.trim);
    }
    method plain-function-spec($/) { make $/.Str.trim; }
    method latex-function-spec($/) { make $/.Str.substr(1, *-1); }
    method variable-range-spec($/) { make $<range>.made; }
    method range($/) { make $/.values[0].made; }
    method range-interval($/) { make $<range-boundary>>>.made.join(','); }
    method range-bracket-interval($/) { make $<range-boundary>>>.made.join(','); }
    method range-named($/) {
        my $range = do given $/.Str {
            when 'R+' { '0,Inf' }
            when 'R-' { '-Inf,0' }
            default   { '-Inf,Inf' }
        };
        make $range;
    }
    method range-boundary($/) {
        my $boundary = $/.Str;
        $boundary = 'Inf'  if $boundary eq 'Infinity' || $boundary eq '+Infinity' || $boundary eq '+Inf' || $boundary eq '∞' || $boundary eq '+∞';
        $boundary = '-Inf' if $boundary eq '-Infinity' || $boundary eq '-∞';
        make $boundary;
    }

    # Math::NIntegrate options
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
    method integration-method-option($/) { make 'method => "' ~ self.raku-method($<integration-method-name>.Str) ~ '"'; }
    method precision-goal-option($/) { make 'precision-goal => ' ~ $<number-value>.made; }
    method accuracy-goal-option($/) { make 'accuracy-goal => ' ~ $<number-value>.made; }
    method max-recursion-option($/) { make 'max-recursion => ' ~ $<integer-value>.made; }
    method recursion-levels-option($/) { make 'max-recursion => ' ~ $<integer-value>.made; }
    method without-singularity-handling-option($/) { make 'singularity-handler => "none"'; }

}