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
    rule integral-type { ['numerical' | 'symbolic']? ['integral' | 'integration'] }
    rule integrate { ['symbolically' | 'numerically']? 'integrate' | 'integrate' ['numerically' | 'symbolically'] }
    token latex-function-spec { '$' <-[$]>* '$' }
    regex plain-function-spec { .+? <?before \s+ ['over' | 'in' | 'for' | 'of'] > }
    rule function-spec { <latex-function-spec> || <plain-function-spec> || \S+ }
    # Defined in DSL::Shared
    #regex variable-name { <.alpha> <.alnum>* }
    #regex number { <[+\-]>? \d+ [ <[.Ee]> <[+\-]>? \d+]? }
    rule range-named { 'R' | 'R+' | 'R-' }
    regex infinity-spec {:i ['+' | '-']? ['Inf' | 'Infinity' | 'inf' | '∞'] }
    regex range-boundary { <number-value> | <variable-name> | <infinity-spec> }
    regex range-interval { [<.from-preposition> \s+]? <range-boundary> [\s+ [<.to-preposition> | <.and-conjunction>]]? \s+ <range-boundary> }
    rule range-bracket-interval { '[' <range-boundary> ',' <range-boundary> ']' }
    regex range { [[<.in-preposition> | <.over-preposition>]? [\s+ <.the-determiner>]? [\s+ ['interval' | 'range']]? \s+]? [<range-bracket-interval> | <range-interval> | <range-named>] }
    token domain-product { 'x' | '×' }
    rule domain-range-spec { [<.in-preposition> | <.over-preposition>] <.the-determiner>? 'domain' <range-bracket-interval>+ % <domain-product> }
    rule variable-range-spec { [<.for-preposition> | <.of-preposition>] <variable-name> <range> }
    rule integral-request { [<.compute> | 'do'] <integral-type> <.of-preposition> }
    rule plot-phrase { <.plot-noun> <.it-pronoun>? }
    rule command-integrate-and-plot { [<integral-request> | <integrate> [<.and-conjunction> <plot-phrase>]?] <function-spec> [<domain-range-spec> || <variable-range-spec> || <range>] <integration-options-spec>* [ <.and-conjunction> <plot-phrase>]? }
    rule command-integrate-short { [<integral-request> | <integrate>] <function-spec> }

    # Monitor command

    # Plot command
    #rule plot-command { <plot-sampling-points> | }
}
