use v6.d;

use DSL::English::IntegrationWorkflows::Grammar;
use DSL::Shared::Actions::Russian::PipelineCommand;
use DSL::Shared::Actions::Russian::Standard::PipelineCommand;

class DSL::English::IntegrationWorklfows::Actions::Russian::Standard
        does DSL::Shared::Actions::Russian::Standard::PipelineCommand
        is DSL::Shared::Actions::Russian::PipelineCommand {

    method TOP($/) { die 'Not implemented yet.' }

}