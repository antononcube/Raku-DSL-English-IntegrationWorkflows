use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::English::PipelineCommand;
use DSL::Shared::Actions::English::Standard::PipelineCommand;

class DSL::English::IntegrationWorklfows::Actions::English::Standard
        does DSL::Shared::Actions::English::Standard::PipelineCommand
        is DSL::Shared::Actions::English::PipelineCommand {

    method TOP($/) { die 'Not implemented yet.' }

}