use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::English::Raku::PipelineCommand;
use DSL::Shared::Actions::Raku::PredicateSpecification;

class DSL::English::IntegrationWorkflows::Actions::Raku::Ecosystem
        is DSL::Shared::Actions::English::Raku::PipelineCommand
        is DSL::Shared::Actions::Raku::PredicateSpecification {

    method TOP($/) { die 'Not implemented yet.' }

}