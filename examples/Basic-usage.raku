#!/usr/bin/env raku
use v6.d;

use DSL::English::IntegrationWorkflows;
use Math::NIntegrate;

my $command = "compute the numerical integral of Sin[x] for x over 0 to π";
say (:$command);

my $res = ToIntegrationWorkflowCode($command, 'Raku');
say "Interpreted as: $res";

# Evaluate by being careful.
# For example, if symbolic boundaries were specified, then the result is "N/A".
{
    use MONKEY-SEE-NO-EVAL;
    $res = try $res.EVAL;
    $res = 'N/A' if $!;
}();

say "Integration result: $res";