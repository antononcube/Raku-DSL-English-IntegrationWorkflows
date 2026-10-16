use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::Bulgarian::PipelineCommand;
use DSL::Shared::Actions::Bulgarian::Standard::PipelineCommand;

class DSL::English::IntegrationWorklfows::Actions::Bulgarian::Standard
        does DSL::Shared::Actions::Bulgarian::Standard::PipelineCommand
        is DSL::Shared::Actions::Bulgarian::PipelineCommand {

    method TOP($/) { die 'Not implemented yet.' }

}