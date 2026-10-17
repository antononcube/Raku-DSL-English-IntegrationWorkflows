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
    rule integral-type { [<numerical-adjective> | <symbolic-adjective>]? [<integral-noun> | <integration-noun>] }
    rule integration-mode { <symbolically-adverb> | <numerically-adverb> }
    rule integrate-directive { <integration-mode>? <integrate-verb> | <integrate-verb> <integration-mode> }
    token latex-function-spec { '$' <-[$]>* '$' }
    regex plain-function-spec { .+? <?before \s+ ['over' | 'in' | 'for' | 'of'] > }
    rule function-spec { <latex-function-spec> || <plain-function-spec> || \S+ }
    # Defined in DSL::Shared
    #regex variable-name { <.alpha> <.alnum>* }
    #regex number { <[+\-]>? \d+ [ <[.Ee]> <[+\-]>? \d+]? }
    rule range-named { 'R' | 'R+' | 'R-' }
    regex infinity-spec {:i ['+' | '-']? ['Inf' | <infinity-noun> | 'inf' | '∞'] }
    regex range-boundary { <number-value> | <variable-name> | <infinity-spec> }
    regex range-interval { [<.from-preposition> \s+]? <range-boundary> [\s+ [<.to-preposition> | <.and-conjunction>]]? \s+ <range-boundary> }
    rule range-bracket-interval { '[' <range-boundary> ',' <range-boundary> ']' }
    regex range { [[<.in-preposition> | <.over-preposition>]? [\s+ <.the-determiner>]? [\s+ [<.interval-noun> | <.range-noun>]]? \s+]? [<range-bracket-interval> | <range-interval> | <range-named>] }
    token domain-product { 'x' | '×' }
    rule domain-range-spec { [<.in-preposition> | <.over-preposition>] <.the-determiner>? <.domain-noun>? <range-bracket-interval>+ % <domain-product> }
    rule variable-range-spec { [<.for-preposition> | <.of-preposition>] <variable-name> <range> }
    rule integral-request { [<.compute> | <.do-verb>] <integral-type> <.of-preposition> }
    rule plot-phrase { <.plot-noun> <.it-pronoun>? }
    rule command-integrate-and-plot { [<integral-request> | <integrate-directive> [<.and-conjunction> <plot-phrase>]?] <function-spec> [<domain-range-spec> || <variable-range-spec> || <range>] <integration-options-spec>* [ <.and-conjunction> <plot-phrase>]? }
    rule command-integrate-short { [<integral-request> | <integrate-directive>] <function-spec> }

    # Monitor command

    # Plot command
    #rule plot-command { <plot-sampling-points> | }
}
