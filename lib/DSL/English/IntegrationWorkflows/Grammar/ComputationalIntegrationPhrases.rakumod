use v6.d;

use DSL::Shared::Utilities::FuzzyMatching;

# Phrases for numerical-integration controls. The shared English pipeline role,
# composed by the concrete grammar, supplies number values and prepositions.
role DSL::English::IntegrationWorkflows::Grammar::ComputationalIntegrationPhrases {
    rule integration-options-spec {
        [ <.with-preposition> | <.using-preposition> ] <.a-determiner>? <integration-option>+ % <integration-option-separator> |
        <without-singularity-handling-option> |
        <recursion-levels-option>
    }

    rule integration-option {
        <integration-method-option> |
        <precision-goal-option> |
        <accuracy-goal-option> |
        <max-recursion-option> |
        <min-recursion-option> |
        <recursion-levels-option>
    }
    rule integration-option-separator { ',' <.and-conjunction>? | <.and-conjunction> }

    rule integration-method-option { [<.the-determiner> | <.a-determiner> | <.some-determiner>]? <integration-method-name> <.strategy>? }
    rule integration-method-name {
        <adaptive-monte-carlo> |
        <adaptive-quasi-monte-carlo> |
        <double-exponential> |
        <global-adaptive> |
        <local-adaptive> |
        <monte-carlo-rule> |
        <monte-carlo> |
        <quasi-monte-carlo> |
        <even-odd-subdivision> |
        <symbolic-piecewise-subdivision> |
        <unit-cube-rescaling> |
        <cartesian-rule> |
        <clenshaw-curtis-rule> |
        <gauss-kronrod-rule> |
        <lobatto-kronrod-rule> |
        <multidimensional-rule> |
        <newton-cotes-rule> |
        <trapezoidal-rule>
    }

    token strategy { :i 'strategy'  | ([\w]+) <?{ is-fuzzy-match($0.Str, 'strategy', 2) }> }
    token msep { [ \h+ | '_' | '-' ]+ }

    # Integration strategies
    token adaptive-monte-carlo { :i 'AdaptiveMonteCarlo' | 'adaptive' <msep> 'monte' <msep> 'carlo' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'adaptivemontecarlo', 3) }> }
    token adaptive-quasi-monte-carlo { :i 'AdaptiveQuasiMonteCarlo' | 'adaptive' <msep> 'quasi' <msep> 'monte' <msep> 'carlo' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'adaptivequasimontecarlo', 3) }> }
    token double-exponential { :i 'DoubleExponential' | 'double' <msep> 'exponential' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'doubleexponential', 3) }> }
    token global-adaptive { :i 'GlobalAdaptive' | 'global' <msep> 'adaptive' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'globaladaptive', 3) }> }
    token local-adaptive { :i 'LocalAdaptive' | 'local' <msep> 'adaptive' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'localadaptive', 3) }> }
    # This breaks MonteCarloRule test in "02-WL-actions.rakutest" if <monte-carlo-rule> is placed after <monte-carlo> in <integration-method-name>
    token monte-carlo { :i 'MonteCarlo' | 'monte' <msep> 'carlo' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'montecarlo', 1) }> }
    token quasi-monte-carlo { :i 'QuasiMonteCarlo' | 'quasi' <msep> 'monte' <msep> 'carlo' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'quasimontecarlo', 3) }> }

    # Integration preprocessors
    token even-odd-subdivision { :i 'EvenOddSubdivision' | 'even' <msep> 'odd' <msep> 'subdivision' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'evenoddsubdivision', 3) }> }
    token symbolic-piecewise-subdivision { :i 'SymbolicPiecewiseSubdivision' | 'symbolic' <msep> 'piecewise' <msep> 'subdivision' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'symbolicpiecewisesubdivision', 3) }> }
    token unit-cube-rescaling { :i 'UnitCubeRescaling' | 'unit' <msep> 'cube' <msep> 'rescaling' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'unitcuberescaling', 3) }> }

    # Integration rules
    token cartesian-rule { :i 'CartesianRule' | 'cartesian' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'cartesianrule', 3) }> }
    token clenshaw-curtis-rule { :i 'ClenshawCurtisRule' | 'clenshaw' <msep> 'curtis' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'clenshawcurtisrule', 3) }> }
    token gauss-kronrod-rule { :i 'GaussKronrodRule' | 'gauss' <msep> 'kronrod' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'gausskronrodrule', 3) }> }
    token lobatto-kronrod-rule { :i 'LobattoKronrodRule' | 'lobatto' <msep> 'kronrod' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'lobattokronrodrule', 3) }> }
    token monte-carlo-rule { :i 'MonteCarloRule' | 'monte' <msep> 'carlo' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'montecarlorule', 3) }> }
    token multidimensional-rule { :i 'MultidimensionalRule' | 'MultiDimensionalRule' | 'multidimensional' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'multidimensionalrule', 3) }> }
    token newton-cotes-rule { :i 'NewtonCotesRule' | 'newton' <msep> 'cotes' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'newtoncotesrule', 3) }> }
    token trapezoidal-rule { :i 'TrapezoidalRule' | 'trapezoidal' <msep> 'rule' | ([\w | <msep>]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'trapezoidalrule', 3) }> }
    rule precision-goal-option { 'precision' <goal-noun> <number-value> }
    rule accuracy-goal-option { 'accuracy' <goal-noun> <number-value> }
    rule max-recursion-option { <maximum> <recursion-noun> <integer-value> }
    rule min-recursion-option { <minimum> <recursion-noun> <integer-value> }
    rule recursion-levels-option { <.with-preposition>? 'up' <.to-preposition> <integer-value> <recursion-noun> 'levels' }
    rule without-singularity-handling-option { 'without' 'singularity' 'handling' }

    # Words
    token goal-noun {:i goal }
    token infinity-noun {:i infinity | ([\w]+) <?{ is-fuzzy-match($0.Str, 'infinity', 2) }> }
    token integral-noun {:i integral    | ([\w]+) <?{ $0.Str ∉ <integrand integrate integration> && is-fuzzy-match($0.Str, 'integral', 2) }> }
    token integrand-verb {:i integrand  | ([\w]+) <?{ $0.Str ∉ <integral integrate integration> && is-fuzzy-match($0.Str, 'integrand', 2) }> }
    token integrate-verb {:i integrate  | ([\w]+) <?{ $0.Str ∉ <integrand integral integration> && is-fuzzy-match($0.Str, 'integrate', 2) }> }
    token integration-noun {:i integration | ([\w]+) <?{ $0.Str ∉ <integrand integrate integral> && is-fuzzy-match($0.Str, 'integration', 2) }> }
    token interval-noun {:i interval  | ([\w]+) <?{ is-fuzzy-match($0.Str, 'intreval', 2) }> }
    token numerical-adjective {:i numerical | numeric | ([\w]+) <?{ $0.Str ne 'numerically' && is-fuzzy-match($0.Str, 'numeric', 2) }> }
    token numerically-adverb {:i numerically | ([\w]+) <?{ $0.Str ∉ <numerical numeric> && is-fuzzy-match($0.Str, 'numerically', 2) }> }
    token range-noun {:i range | ([\w]+) <?{ is-fuzzy-match($0.Str, 'range', 1) }> }
    token recursion-noun {:i recursion | ([\w]+) <?{ is-fuzzy-match($0.Str, 'recursion', 2) }> }
    token symbolic-adjective {:i symbolic | ([\w]+) <?{ $0.Str ne 'symbolically' && is-fuzzy-match($0.Str, 'symbolic', 2) }> }
    token symbolically-adverb {:i symbolically | ([\w]+) <?{ $0.Str ne 'symbolic' && is-fuzzy-match($0.Str, 'symbolically', 2) }> }
}
