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
    rule integration-command { <COMMAND1> | <COMMAND2> }

    # First grammar derived from 2014 blog and presentation DSL / Functional Parsers examples
    rule REQUEST-PREAMBLE { 'compute' | 'what' 'is' }
    rule COMPUTE { <REQUEST-PREAMBLE> 'the'? }
    rule INTEGRAL-TYPE { ['numerical' | 'symbolic']? 'integral' }
    rule INTEGRATE { ['symbolically' | 'numerically']? 'integrate' | 'integrate' ['numerically' | 'symbolically'] }
    rule FUNCTION { \S+ }
    regex VAR { <.alpha> <.alnum>* }
    rule RANGE-NAMED { 'R' | 'R+' | 'R-' }
    regex INFINITY {:i ['+' | '-']? ['Inf' | 'Infinity' | 'inf' | '∞'] }
    regex number { <[+\-]>? \d+ [ <[.Ee]> <[+\-]>? \d+]? }
    regex RANGE-BOUNDARY { <number> | <VAR> | <INFINITY> }
    regex RANGE-INTERVAL { ['from' \s+]? <RANGE-BOUNDARY> [\s+ ['to' | 'and']]? \s+ <RANGE-BOUNDARY> }
    regex RANGE { [['in' | 'over']? [\s+ 'the']? [\s+ 'interval']?] \s+ [<RANGE-INTERVAL> | <RANGE-NAMED>] }
    rule VAR-RANGE-SPEC { ['for' | 'of'] <VAR> <RANGE> }
    rule INTEGRAL-REQUEST { <.COMPUTE> <INTEGRAL-TYPE> 'of' }
    rule PLOT { 'plot' 'it'? }
    rule COMMAND1 { [<INTEGRAL-REQUEST> | <INTEGRATE> ['and' <PLOT>]?] <FUNCTION> [<VAR-RANGE-SPEC> | <RANGE>] ['and' <PLOT>]? }
    rule COMMAND2 { [<INTEGRAL-REQUEST> | <INTEGRATE>] <FUNCTION> }

    # Monitor command

    # Plot command
    #rule plot-command { <plot-sampling-points> | }
}
