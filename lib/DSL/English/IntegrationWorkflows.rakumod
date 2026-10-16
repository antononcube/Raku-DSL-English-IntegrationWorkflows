=begin pod

=head1 DSL::English::IntegrationWorkflows

C<DSL::English::IntegrationWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify symbolic or numerical integration workflows.

=head1 Synopsis

    use DSL::English::IntegrationWorkflows;
    my $cmd = "compute the integral of x^2 over 0.1 and 0.9";
    my $rcode = ToIntegrationWorkflowCode($cmd);
    my $pcode = ToIntegrationWorkflowCode($cmd, target => "Raku::Ecosystem");

=end pod

unit module DSL::English::IntegrationWorkflows;

use DSL::Shared::Utilities::CommandProcessing;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::English::IntegrationWorkflows::Actions::Bulgarian::Standard;
use DSL::English::IntegrationWorkflows::Actions::English::Standard;
#use DSL::English::IntegrationWorkflows::Actions::Python::Ecosystem;
use DSL::English::IntegrationWorkflows::Actions::Raku::Ecosystem;
use DSL::English::IntegrationWorkflows::Actions::Russian::Standard;
use DSL::English::IntegrationWorkflows::Actions::WL::System;

my %targetToAction{Str} =
    "Bulgarian"             => DSL::English::QuantileRegressionWorkflows::Actions::Bulgarian::Standard,
    "English"               => DSL::English::QuantileRegressionWorkflows::Actions::English::Standard,
    "Raku"                  => DSL::English::QuantileRegressionWorkflows::Actions::Raku::NIntegrate,
    "Raku-NIntegrate"       => DSL::English::QuantileRegressionWorkflows::Actions::Raku::NIntegrate,
    "Russian"               => DSL::English::QuantileRegressionWorkflows::Actions::Russian::Standard,
    "Mathematica"           => DSL::English::QuantileRegressionWorkflows::Actions::WL::Standard,
    "WL"                    => DSL::English::QuantileRegressionWorkflows::Actions::WL::Standard,
    "WL-System"             => DSL::English::QuantileRegressionWorkflows::Actions::WL::Standard,
    "WL-Standard"           => DSL::English::QuantileRegressionWorkflows::Actions::WL::Standard;

my %targetToAction2{Str} = %targetToAction.grep({ $_.key.contains('-') }).map({ $_.key.subst('-', '::') => $_.value }).Hash;
%targetToAction = |%targetToAction , |%targetToAction2;

my Str %targetToSeparator{Str} =
    "Bulgarian"             => "\n",
    "English"               => "\n",
    "Mathematica"           => ";\n",
    "Python"                => "\n",
    "Python-NIntegrate"     => "\n",
    "R"                     => "\n",
    "R-NIntegrate"          => "\n",
    "Raku"                  => ";\n",
    "Raku-NIntegrate"       => ";\n",
    "Russian"               => "\n",
    "WL"                    => ";\n",
    "WL-System"             => ";\n",
    "WL-Standard"           => ";\n";

my Str %targetToSeparator2{Str} = %targetToSeparator.grep({ $_.key.contains('-') }).map({ $_.key.subst('-', '::') => $_.value }).Hash;
%targetToSeparator = |%targetToSeparator , |%targetToSeparator2;

#-----------------------------------------------------------
proto ToIntegrationWorkflowCode(Str $command, | ) is export {*}

multi ToIntegrationWorkflowCode(Str $command, Str :$target = 'R-QRMon', *%args ) {
    return ToIntegrationWorkflowCode($command, $target, |%args);
}

multi ToIntegrationWorkflowCode( Str $command, Str $target = 'R-QRMon', *%args ) {

    my $lang = %args<language>:exists ?? %args<language> !! 'English';
    $lang = $lang.wordcase;

    my $gname = "DSL::{$lang}::IntegrationWorkflows::Grammar";

    try require ::($gname);
    if ::($gname) ~~ Failure { die "Failed to load the grammar $gname." }

    my Grammar $grammar = ::($gname);

    DSL::Shared::Utilities::CommandProcessing::ToWorkflowCode( $command,
                                                               :$grammar,
                                                               :%targetToAction,
                                                               :%targetToSeparator,
                                                               :$target,
                                                               |%args )

}