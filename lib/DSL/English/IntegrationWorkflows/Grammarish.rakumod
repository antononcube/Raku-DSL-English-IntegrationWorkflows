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
    rule request-preamble { 'compute' | 'what' 'is' }
    rule compute { <request-preamble> 'the'? }
    rule integral-type { ['numerical' | 'symbolic']? 'integral' }
    rule integrate { ['symbolically' | 'numerically']? 'integrate' | 'integrate' ['numerically' | 'symbolically'] }
    rule function-spec { \S+ }
    # Defined in DSL::Shared
    #regex variable-name { <.alpha> <.alnum>* }
    rule range-NAMED { 'R' | 'R+' | 'R-' }
    regex INFINITY {:i ['+' | '-']? ['Inf' | 'Infinity' | 'inf' | '∞'] }
    regex number { <[+\-]>? \d+ [ <[.Ee]> <[+\-]>? \d+]? }
    regex range-boundary { <number> | <variable-name> | <INFINITY> }
    regex range-interval { ['from' \s+]? <range-boundary> [\s+ ['to' | 'and']]? \s+ <range-boundary> }
    regex range { [['in' | 'over']? [\s+ 'the']? [\s+ 'interval']?] \s+ [<range-interval> | <range-NAMED>] }
    rule variable-range-spec { ['for' | 'of'] <variable-name> <range> }
    rule integral-request { <.compute> <integral-type> 'of' }
    rule plot { 'plot' 'it'? }
    rule command-integrate-and-plot { [<integral-request> | <integrate> ['and' <plot>]?] <function-spec> [<variable-range-spec> | <range>] ['and' <plot>]? }
    rule command-integrate-short { [<integral-request> | <integrate>] <function-spec> }

    # Monitor command

    # Plot command
    #rule plot-command { <plot-sampling-points> | }
}
