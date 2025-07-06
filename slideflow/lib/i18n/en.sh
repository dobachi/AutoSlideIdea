#!/bin/bash
# English messages

MESSAGES=(
    # General messages
    ["error"]="Error"
    ["warning"]="Warning"
    ["success"]="Success"
    ["done"]="Done"
    ["info"]="Info"
    
    # SlideFlow specific messages
    ["sf.title"]="SlideFlow - Markdown-based presentation management tool"
    ["sf.usage"]="Usage"
    ["sf.commands"]="Commands"
    ["sf.options"]="Options"
    ["sf.examples"]="Examples"
    
    # Command descriptions
    ["cmd.new.desc"]="Create a new presentation"
    ["cmd.preview.desc"]="Preview presentation"
    ["cmd.ai.desc"]="AI assistance (default: interactive phase support)"
    ["cmd.build.desc"]="Build presentation"
    ["cmd.info.desc"]="Show presentation information"
    ["cmd.list.desc"]="List existing presentations"
    ["cmd.templates.desc"]="List available templates"
    ["cmd.instructions.desc"]="Check AI instruction system status"
    ["cmd.help.desc"]="Show this help"
    
    # AI option descriptions
    ["ai.option.interactive"]="Interactive phase support"
    ["ai.option.quick"]="Quick support (tech/business/academic)"
    ["ai.option.phase"]="Specific phase (planning/research/design/creation/review)"
    ["ai.option.continue"]="Continue previous session"
    
    # Error messages
    ["error.name_required"]="Error: Please specify presentation name"
    ["error.usage_new"]="Usage: slideflow new <name>"
    ["error.dir_not_found"]="Error: Directory not found: %1"
    ["error.no_slides"]="Error: slides.md not found"
    ["error.unknown_command"]="Error: Unknown command: %1"
    ["error.invalid_selection"]="Invalid selection. Copying to clipboard."
    ["error.unsupported_format"]="Error: Unsupported format '%1'"
    ["error.check_dir"]="Please check the presentation directory: %1"
    ["error.template_dir_not_found"]="Template directory not found"
    ["error.supported_formats"]="Supported formats: html, pdf, pptx"
    
    # Success messages
    ["success.created"]="Created successfully!"
    ["success.next_steps"]="Next steps:"
    ["success.preview_server"]="Preview server started"
    ["success.server_url"]="URL: %1"
    ["success.stop_server"]="Press Ctrl+C to stop the server"
    
    # Info messages
    ["info.creating"]="Creating presentation..."
    ["info.starting_server"]="Starting preview server..."
    ["info.building"]="Building..."
    ["info.presentation_info"]="Presentation information"
    ["info.title"]="Title"
    ["info.description"]="Description"
    ["info.author"]="Author"
    ["info.date"]="Date"
    ["info.slides_count"]="Number of slides"
    ["info.select_tool"]="Select a tool to use (1-%1, Enter=1): "
    ["info.quick_support_complete"]="Quick AI support completed!"
    ["info.building_as"]="Building as %1..."
    ["info.file_info"]="File information:"
    ["info.path"]="Path"
    ["info.size"]="Size"
    ["info.last_update"]="Last update"
    ["info.metadata"]="Metadata:"
    ["info.generated_files"]="Generated files:"
    ["info.available_templates"]="Available templates"
    ["info.existing_presentations"]="Existing presentations"
    ["info.no_presentations"]="No presentations found"
    ["info.create_first"]="Create your first presentation:"
    ["info.features"]="Features:"
    ["info.usage_template"]="Usage:"
    ["info.open_presentation"]="Open presentation:"
    
    # Prompts
    ["prompt.select_template"]="Please select a template"
    ["prompt.enter_title"]="Enter title"
    ["prompt.enter_description"]="Enter description (optional)"
    
    # AI related
    ["ai.welcome"]="Welcome to SlideFlow AI Assistant!"
    ["ai.phase_support"]="Phase-based support mode"
    ["ai.quick_support"]="Quick support mode (%1)"
    ["ai.interactive_mode"]="Interactive mode"
    ["ai.select_phase"]="Please select the phase you need support for:"
    ["ai.processing"]="Processing..."
    ["ai.session_saved"]="Session saved"
    ["ai.continuing_session"]="Continuing previous session"
    ["ai.support_mode"]="AI Support Mode"
    ["ai.starting_interactive"]="Starting interactive phase support"
    ["ai.hint_quick"]="Hint: For quick support, use 'slideflow ai --quick <type>'"
    ["ai.working_dir"]="Working directory: %1"
    ["ai.unknown_option"]="Unknown option or invalid path: %1"
    ["ai.usage_ai"]="Usage: slideflow ai [--quick <type>|--phase <phase>|--continue] [path]"
    
    # Others
    ["note.path_omitted"]="Note: If [path] is omitted, the current directory will be used"
    ["misc.or"]="or"
    ["misc.unknown_command"]="Unknown command: %1"
    ["misc.no_presentation"]="No presentation found"
    ["misc.bytes"]="bytes"
)