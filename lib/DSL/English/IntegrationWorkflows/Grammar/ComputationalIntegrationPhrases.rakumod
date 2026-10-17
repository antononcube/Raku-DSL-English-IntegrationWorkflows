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

    rule integration-method-option { <integration-method-name> <.strategy>? }
    rule integration-method-name {
        <adaptive-monte-carlo> |
        <adaptive-quasi-monte-carlo> |
        <double-exponential> |
        <global-adaptive> |
        <local-adaptive> |
        <monte-carlo> |
        <quasi-monte-carlo> |
        <even-odd-subdivision> |
        <symbolic-piecewise-subdivision> |
        <unit-cube-rescaling> |
        <cartesian-rule> |
        <clenshaw-curtis-rule> |
        <gauss-kronrod-rule> |
        <lobatto-kronrod-rule> |
        <monte-carlo-rule> |
        <multidimensional-rule> |
        <newton-cotes-rule> |
        <trapezoidal-rule>
    }

    token strategy { :i 'strategy'  | ([\w]+) <?{ is-fuzzy-match($0.Str, 'strategy', 2) }> }
    token method-name-separator { [ \h+ | '_' | '-' ]+ }

    # Integration strategies
    token adaptive-monte-carlo { :i 'AdaptiveMonteCarlo' | 'adaptive' <method-name-separator> 'monte' <method-name-separator> 'carlo' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'adaptivemontecarlo', 3) }> }
    token adaptive-quasi-monte-carlo { :i 'AdaptiveQuasiMonteCarlo' | 'adaptive' <method-name-separator> 'quasi' <method-name-separator> 'monte' <method-name-separator> 'carlo' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'adaptivequasimontecarlo', 3) }> }
    token double-exponential { :i 'DoubleExponential' | 'double' <method-name-separator> 'exponential' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'doubleexponential', 3) }> }
    token global-adaptive { :i 'GlobalAdaptive' | 'global' <method-name-separator> 'adaptive' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'globaladaptive', 3) }> }
    token local-adaptive { :i 'LocalAdaptive' | 'local' <method-name-separator> 'adaptive' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'localadaptive', 3) }> }
    token monte-carlo { :i 'MonteCarlo' | 'monte' <method-name-separator> 'carlo' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'montecarlo', 3) }> }
    token quasi-monte-carlo { :i 'QuasiMonteCarlo' | 'quasi' <method-name-separator> 'monte' <method-name-separator> 'carlo' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'quasimontecarlo', 3) }> }

    # Integration preprocessors
    token even-odd-subdivision { :i 'EvenOddSubdivision' | 'even' <method-name-separator> 'odd' <method-name-separator> 'subdivision' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'evenoddsubdivision', 3) }> }
    token symbolic-piecewise-subdivision { :i 'SymbolicPiecewiseSubdivision' | 'symbolic' <method-name-separator> 'piecewise' <method-name-separator> 'subdivision' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'symbolicpiecewisesubdivision', 3) }> }
    token unit-cube-rescaling { :i 'UnitCubeRescaling' | 'unit' <method-name-separator> 'cube' <method-name-separator> 'rescaling' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'unitcuberescaling', 3) }> }

    # Integration rules
    token cartesian-rule { :i 'CartesianRule' | 'cartesian' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'cartesianrule', 3) }> }
    token clenshaw-curtis-rule { :i 'ClenshawCurtisRule' | 'clenshaw' <method-name-separator> 'curtis' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'clenshawcurtisrule', 3) }> }
    token gauss-kronrod-rule { :i 'GaussKronrodRule' | 'gauss' <method-name-separator> 'kronrod' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'gausskronrodrule', 3) }> }
    token lobatto-kronrod-rule { :i 'LobattoKronrodRule' | 'lobatto' <method-name-separator> 'kronrod' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'lobattokronrodrule', 3) }> }
    token monte-carlo-rule { :i 'MonteCarloRule' | 'monte' <method-name-separator> 'carlo' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'montecarlorule', 3) }> }
    token multidimensional-rule { :i 'MultidimensionalRule' | 'MultiDimensionalRule' | 'multidimensional' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'multidimensionalrule', 3) }> }
    token newton-cotes-rule { :i 'NewtonCotesRule' | 'newton' <method-name-separator> 'cotes' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'newtoncotesrule', 3) }> }
    token trapezoidal-rule { :i 'TrapezoidalRule' | 'trapezoidal' <method-name-separator> 'rule' | ([\w]+) <?{ is-fuzzy-match($0.Str.subst(/\W/):g, 'trapezoidalrule', 3) }> }
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
