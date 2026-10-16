role DSL::English::IntegrationWorkflows::Grammarish {

    # TOP
    rule TOP { <workflow-command> }

    # Workflow commands list
    rule workflow-commands-list { [ [ <.ws>? <workflow-command> <.ws>? ]+ % <.list-of-commands-separator> ] <.list-of-commands-separator>? }

    # Workflow command
    rule workflow-command {
        | <pipeline-command>
        | <integration-command>
        #| <monitor-command>
        #| <plot-command>
    }

    # Integration command
    rule integration-command { <command-integrate-and-plot> | <command-integrate-short> }

    # First grammar derived from 2014 blog and presentation DSL / Functional Parsers examples
    rule request-preamble { <compute-directive> | <what-pronoun> <is-verb> }
    rule compute { <request-preamble> <the-determiner>? }
    rule integral-type { ['numerical' | 'symbolic']? 'integral' }
    rule integrate { ['symbolically' | 'numerically']? 'integrate' | 'integrate' ['numerically' | 'symbolically'] }
    rule function-spec { \S+ }
    # Defined in DSL::Shared
    #regex variable-name { <.alpha> <.alnum>* }
    #regex number { <[+\-]>? \d+ [ <[.Ee]> <[+\-]>? \d+]? }
    rule range-named { 'R' | 'R+' | 'R-' }
    regex infinity-spec {:i ['+' | '-']? ['Inf' | 'Infinity' | 'inf' | '∞'] }
    regex range-boundary { <number-value> | <variable-name> | <infinity-spec> }
    regex range-interval { [<.from-preposition> \s+]? <range-boundary> [\s+ [<.to-preposition> | <.and-conjunction>]]? \s+ <range-boundary> }
    regex range { [[<.in-preposition> | <.over-preposition>]? [\s+ <.the-determiner>]? [\s+ 'interval']?] \s+ [<range-interval> | <range-named>] }
    rule variable-range-spec { [<.for-preposition> | <.of-preposition>] <variable-name> <range> }
    rule integral-request { <.compute> <integral-type> <.of-preposition> }
    rule plot { <.plot-noun> <.it-pronoun>? }
    rule command-integrate-and-plot { [<integral-request> | <integrate> [<.and-conjunction> <plot>]?] <function-spec> [<variable-range-spec> | <range>] [ <.and-conjunction> <.plot-noun>]? }
    rule command-integrate-short { [<integral-request> | <integrate>] <function-spec> }

    # Monitor command

    # Plot command
    #rule plot-command { <plot-sampling-points> | }
}
