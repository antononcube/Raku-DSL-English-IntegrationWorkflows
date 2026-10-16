use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::English::WL::PipelineCommand;
use DSL::Shared::Actions::WL::PredicateSpecification;

class DSL::English::IntegrationWorklfows::Actions::WL::System
        is DSL::Shared::Actions::English::WL::PipelineCommand
        is DSL::Shared::Actions::WL::PredicateSpecification {

    method TOP($/) { die 'Not implemented yet.' }

}