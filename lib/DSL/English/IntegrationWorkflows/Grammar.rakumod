use v6.d;

use DSL::Shared::Roles::English::PipelineCommand;
use DSL::Shared::Roles::ErrorHandling;
use DSL::English::IntegrationWorkflows::Grammar::ComputationalIntegrationPhrases;
use DSL::English::IntegrationWorkflows::Grammarish;

grammar DSL::English::IntegrationWorkflows::Grammar
        does DSL::English::IntegrationWorkflows::Grammarish
        does DSL::English::IntegrationWorkflows::Grammar::ComputationalIntegrationPhrases
        does DSL::Shared::Roles::English::PipelineCommand
        does DSL::Shared::Roles::ErrorHandling {

}
