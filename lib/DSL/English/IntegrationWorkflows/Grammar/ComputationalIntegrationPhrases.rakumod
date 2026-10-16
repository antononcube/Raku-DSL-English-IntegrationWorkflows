use v6.d;

# Phrases for numerical-integration controls. The shared English pipeline role,
# composed by the concrete grammar, supplies number values and prepositions.
role DSL::English::IntegrationWorkflows::Grammar::ComputationalIntegrationPhrases {
    rule integration-options-spec {
        [ <.with-preposition> | <.using-preposition> ]
        <.a-determiner>?
        <integration-option>+ % <integration-option-separator>
    }

    rule integration-option {
        <integration-method-option> |
        <precision-goal-option> |
        <accuracy-goal-option> |
        <max-recursion-option>
    }
    rule integration-option-separator { ',' <.and-conjunction>? | <.and-conjunction> }

    rule integration-method-option { <local-adaptive-strategy> | <global-adaptive-strategy> }
    rule local-adaptive-strategy { 'local' 'adaptive' 'strategy'? }
    rule global-adaptive-strategy { 'global' 'adaptive' 'strategy'? }
    rule precision-goal-option { 'precision' 'goal' <number-value> }
    rule accuracy-goal-option { 'accuracy' 'goal' <number-value> }
    rule max-recursion-option { 'max' 'recursion' <integer-value> }
}
