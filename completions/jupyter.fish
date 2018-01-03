function __fish_jupyter_get_cmd
  for c in (commandline -opc)
    if not string match -q -- '-*' $c
      echo $c
    else
      # early stop once we've seen a `-*` modifier
      return
    end
  end
end

function __fish_jupyter_needs_command
  set cmd (__fish_jupyter_get_cmd)
  if not set -q cmd[2]
    return 0
  end
  return 1
end

function __fish_jupyter_using_command
  set prefix 0
  getopts $argv | while read -l key option
    switch $key
      case _
        set cmd_to_match $cmd_to_match $option
      case prefix
        set prefix 1
    end
  end

  set cmd (__fish_jupyter_get_cmd)

  if set -q cmd[2..-1]
    set cmd $cmd[2..-1]

    if [ $prefix != 0 ]
      if not set -q cmd[1..(count $cmd_to_match)]
        return 1
      end
      set cmd $cmd[1..(count $cmd_to_match)]
    end

    if [ "$cmd_to_match" = "$cmd" ]
      return 0
    end
  end
  return 1
end

function __fish_jupyter_needs_command
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 ]
        return 0
    else
        return 1
    end
end

function __fish_jupyter_kernel_list
  jupyter kernelspec list --json | python3 -c 'import sys; import json; print(*("{0}\\t{1}".format(k, v["spec"]["display_name"]) for k, v in json.loads(sys.stdin.read())["kernelspecs"].items()), sep="\\n")'
end

function __fish_jupyter_paging_enum
  printf 'inside\tThe widget pages like a traditional terminal\n'
  printf 'hsplit\tWhen paging is requested, the widget is split horizontally. The top pane contains the console, and the bottom pane contains the paged text\n'
  printf 'vsplit\tSimilar to \'hsplit\', except that a vertical splitter is used\n'
  printf 'custom\tNo action is taken by the widget beyond emitting a \'custom_page_requested(str)\' signal\n'
  printf 'none\tThe text is written directly to the console'
end

function __fish_jupyter_gui_completion_enum
  printf 'plain\tShow the available completion as a text list Below the editing area\n'
  printf 'droplist\tShow the completion in a drop down list navigable by the arrow keys, and from which you can select completion by pressing Return\n'
  printf 'ncurses\tShow the completion as a text list which is navigable by `tab` and arrow keys\n'
end

function __fish_jupyter_to_format_enum
  for fmt in {asciidoc,custom,html,latex,markdown,notebook,pdf,python,rst,script,slides}
    printf '%s\t\n' $fmt
  end
end


############
#  macros  #
############

# general macros

function __fish_jupyter_modifier_debug
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l debug -d 'set log level to logging.DEBUG (maximize logging output)'
end

function __fish_jupyter_modifier_log_level
  complete -xc jupyter -n "__fish_jupyter_using_command $argv" -l log-level -a '0 10 20 30 40 50 DEBUG INFO WARN ERROR CRITICAL' -d 'Set the log level by value or name'
end

function __fish_jupyter_modifier_config
  complete -r -c jupyter -n "__fish_jupyter_using_command $argv" -l config -d 'Full path of a config file'
end

function __fish_jupyter_modifier_y
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -s y -d 'Answer yes to any questions instead of prompting'
end

function __fish_jupyter_modifier_generate_config
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l generate-config -d 'Generate default config file'
end

function __fish_jupyter_modifier_user
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l 'user' -d 'Apply the operation only for the given user'
end

function __fish_jupyter_modifier_sys_prefix
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l 'sys-prefix' -d 'Use sys.prefix as the prefix for installing nbextensions (for environments, packaging)'
end

function __fish_jupyter_modifier_system
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l 'system' -d 'Apply the operation system-wide'
end

function __fish_jupyter_modifier_python
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l 'py' -d 'Install from a Python package'
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l 'python' -d 'Install from a Python package'
end

# console macros

function __fish_jupyter_modifier_existing
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l existing -d 'Connect to an existing kernel. If no argument specified, guess most recent'
end

function __fish_jupyter_modifier_confirm_exit
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l confirm-exit -d 'Set to display confirmation dialog on exit. You can always use \'exit\' or \'quit\', to force a direct exit without any confirmation. This can also be set in the config file by setting `c.JupyterConsoleApp.confirm_exit`'
end

function __fish_jupyter_modifier_no_confirm_exit
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l no-confirm-exit -d 'Don\'t prompt the user when exiting. This will terminate the kernel if it is owned by the frontend, and leave it alive if it is external. This can also be set in the config file by setting `c.JupyterConsoleApp.confirm_exit`'
end

function __fish_jupyter_modifier_ip
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l ip -d 'Set the kernel\'s IP address [default localhost]. If the IP address is'
end

function __fish_jupyter_modifier_transport
  complete -xc jupyter -n "__fish_jupyter_using_command $argv" -l transport -a 'tcp ipc' -d 'Default: \'tcp\''
end

function __fish_jupyter_modifier_hb
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l hb -d 'Set the heartbeat port [default: random]'
end

function __fish_jupyter_modifier_shell
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l shell -d 'Set the shell (ROUTER) port [default: random]'
end

function __fish_jupyter_modifier_iopub
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l iopub -d 'Set the iopub (PUB) port [default: random]'
end

function __fish_jupyter_modifier_stdin
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l stdin -d 'Set the stdin (ROUTER) port [default: random]'
end

function __fish_jupyter_modifier_f
  complete -c jupyter -n "__fish_jupyter_using_command $argv" -s f -d 'JSON file in which to store connection info [default: kernel-<pid>.json]'
end

function __fish_jupyter_modifier_kernel
  complete -xc jupyter -n "__fish_jupyter_using_command $argv" -l kernel -a '(__fish_jupyter_kernel_list)' -d 'The name of the default kernel to start'
end

function __fish_jupyter_modifier_ssh
  complete -f -c jupyter -n "__fish_jupyter_using_command $argv" -l ssh -d 'The SSH server to use to connect to the kernel'
end


############
# commands #
############

# universal options
complete -f -c jupyter -l help -s h -d 'Display the manual of a jupyter command'

# subcommandless options
complete -f -c jupyter -n '__fish_jupyter_needs_command' -l version -d 'show the jupyter command\'s version and exit'
complete -f -c jupyter -n '__fish_jupyter_needs_command' -l config-dir -d 'show Jupyter config dir'
complete -f -c jupyter -n '__fish_jupyter_needs_command' -l data-dir -d 'show Jupyter data dir'
complete -f -c jupyter -n '__fish_jupyter_needs_command' -l runtime-dir -d 'show Jupyter runtime dir'
complete -f -c jupyter -n '__fish_jupyter_needs_command' -l paths -d 'show all Jupyter paths. Add --json for machine-readable format'
complete -f -c jupyter -n '__fish_jupyter_needs_command' -l json -d 'output paths as machine-readable json'

# bundlerextension
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'bundlerextension' -d 'Work with Jupyter bundler extensions'

# console
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'console' -d 'The Jupyter terminal-based Console'

__fish_jupyter_modifier_debug console
__fish_jupyter_modifier_generate_config console
__fish_jupyter_modifier_y console
__fish_jupyter_modifier_existing console
__fish_jupyter_modifier_confirm_exit console
__fish_jupyter_modifier_no_confirm_exit console
complete -f -c jupyter -n '__fish_jupyter_using_command console' -l simple-prompt -d 'Force simple minimal prompt using `raw_input`'
complete -f -c jupyter -n '__fish_jupyter_using_command console' -l no-simple-prompt -d 'Use a rich interactive prompt with prompt_toolkit'
__fish_jupyter_modifier_log_level console
__fish_jupyter_modifier_config console
__fish_jupyter_modifier_ip console
__fish_jupyter_modifier_transport console
__fish_jupyter_modifier_hb console
__fish_jupyter_modifier_shell console
__fish_jupyter_modifier_iopub console
__fish_jupyter_modifier_stdin console
__fish_jupyter_modifier_f console
__fish_jupyter_modifier_kernel console
__fish_jupyter_modifier_ssh console

# kernelspec
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'kernelspec' -d 'Manage Jupyter kernel specifications'

complete -xc jupyter -n '__fish_jupyter_using_command kernelspec' -a 'list' -d 'List installed kernel specifications'
complete -xc jupyter -n '__fish_jupyter_using_command kernelspec' -a 'install' -d 'Install a kernel specification directory'
complete -xc jupyter -n '__fish_jupyter_using_command kernelspec' -a 'uninstall' -d 'Alias for remove'
complete -xc jupyter -n '__fish_jupyter_using_command kernelspec' -a 'remove' -d 'Remove one or more Jupyter kernelspecs by name'
complete -xc jupyter -n '__fish_jupyter_using_command kernelspec' -a 'install-self' -d '[DEPRECATED] Install the IPython kernel spec directory for this Python'

## kernelspec list
__fish_jupyter_modifier_debug kernelspec list
__fish_jupyter_modifier_log_level kernelspec list
__fish_jupyter_modifier_config kernelspec list
complete -f -c jupyter -n '__fish_jupyter_using_command kernelspec list' -l json -d 'Output spec name and location as machine-readable json'

## kernelspec install
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec install" -l 'user' -d 'Install to the per-user kernel registry'
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec install" -l 'replace' -d 'Replace any existing kernel spec with this name'
__fish_jupyter_modifier_sys_prefix kernelspec install
__fish_jupyter_modifier_debug kernelspec install
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec install" -l 'name' -d 'Install the kernel spec with this name'
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec install" -l 'prefix' -d 'Specify a prefix to install to, e.g. an env. The kernelspec will be installed in PREFIX/share/jupyter/kernels/'
__fish_jupyter_modifier_log_level kernelspec install
__fish_jupyter_modifier_config kernelspec install

## kernelspec remove
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec remove --prefix" -a '(__fish_jupyter_kernel_list)'
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec remove --prefix" -s f -d 'Force removal, don\'t prompt for confirmation'
__fish_jupyter_modifier_debug kernelspec remove --prefix
__fish_jupyter_modifier_generate_config kernelspec remove --prefix
__fish_jupyter_modifier_y kernelspec remove --prefix
__fish_jupyter_modifier_log_level kernelspec remove --prefix
__fish_jupyter_modifier_config kernelspec remove --prefix

## kernelspec uninstall
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec uninstall --prefix" -a '(__fish_jupyter_kernel_list)'
complete -f -c jupyter -n "__fish_jupyter_using_command kernelspec uninstall --prefix" -s f -d 'Force removal, don\'t prompt for confirmation'
__fish_jupyter_modifier_debug kernelspec uninstall --prefix
__fish_jupyter_modifier_generate_config kernelspec uninstall --prefix
__fish_jupyter_modifier_y kernelspec uninstall --prefix
__fish_jupyter_modifier_log_level kernelspec uninstall --prefix
__fish_jupyter_modifier_config kernelspec uninstall --prefix


# migrate
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'migrate' -d 'Migrate configuration and data from .ipython prior to 4.0 to Jupyter locations'

# nbconvert
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'nbconvert' -d 'This application is used to convert notebook files (*.ipynb) to various other formats'

__fish_jupyter_modifier_debug nbconvert
__fish_jupyter_modifier_generate_config nbconvert
__fish_jupyter_modifier_y nbconvert
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l execute -d 'Execute the notebook prior to export'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l allow-errors -d 'Continue notebook execution even if one of the cells throws an error and include the error message in the cell output (the default behaviour is to abort conversion). This flag is only relevant if \'--execute\' was specified, too'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l stdin -d 'read a single notebook file from stdin. Write the resulting notebook with default basename \'notebook.*\''
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l stdout -d 'Write notebook output to stdout instead of files'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l inplace -d 'Run nbconvert in place, overwriting the existing notebook (only relevant when converting to notebook format)'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l clear-output -d 'Clear output of current file and save in place, overwriting the existing notebook'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l no-prompt -d 'Exclude input and output prompts from converted document'
__fish_jupyter_modifier_log_level nbconvert
__fish_jupyter_modifier_config nbconvert
complete -xc jupyter -n '__fish_jupyter_using_command nbconvert' -l to -a "(__fish_jupyter_to_format_enum)" -d 'The export format to be used, either one of the built-in formats, or a dotted object name that represents the import path for an `Exporter` class'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l template -d 'Name of the template file to use'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l writer -d 'Writer class used to write the  results of the conversion'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l post -d 'PostProcessor class used to write the results of the conversion'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l output -d 'overwrite base name use for output files. can only be used when converting one notebook at a time'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l output-dir -d 'Directory to write output(s) to. Defaults to output to the directory of each notebook. To recover previous default behaviour (outputting to the current working directory) use . as the flag value'
complete -f -c jupyter -n '__fish_jupyter_using_command nbconvert' -l reveal-prefix -d 'The URL prefix for reveal.js. This can be a a relative URL for a local copy of reveal.js, or point to a CDN. For speaker notes to work, a local reveal.js prefix must be used'
complete -xc jupyter -n '__fish_jupyter_using_command nbconvert' -l nbformat -a '{1,2,3,4}' -d 'The nbformat version to write. Use this to downgrade notebooks'


# nbextension
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'nbextension' -d 'Work with Jupyter notebook extensions'

complete -xc jupyter -n '__fish_jupyter_using_command nbextension' -a 'install' -d 'Install an nbextension'
complete -xc jupyter -n '__fish_jupyter_using_command nbextension' -a 'enable' -d 'Enable an nbextension'
complete -xc jupyter -n '__fish_jupyter_using_command nbextension' -a 'disable' -d 'Disable an nbextension'
complete -xc jupyter -n '__fish_jupyter_using_command nbextension' -a 'uninstall' -d 'Uninstall an nbextension'
complete -xc jupyter -n '__fish_jupyter_using_command nbextension' -a 'list' -d 'List nbextensions'

## nbextension enable
__fish_jupyter_modifier_debug nbextension enable
__fish_jupyter_modifier_user nbextension enable
__fish_jupyter_modifier_system nbextension enable
__fish_jupyter_modifier_sys_prefix nbextension enable
__fish_jupyter_modifier_python nbextension enable
complete -f -c jupyter -n '__fish_jupyter_using_command nbextension enable' -l section -d 'Which config section to add the extension to, \'common\' will affect all pages'

## nbextension disable
__fish_jupyter_modifier_debug nbextension disable
__fish_jupyter_modifier_user nbextension disable
__fish_jupyter_modifier_system nbextension disable
__fish_jupyter_modifier_sys_prefix nbextension disable
__fish_jupyter_modifier_python nbextension disable
complete -f -c jupyter -n '__fish_jupyter_using_command nbextension disable' -l 'section' -d 'Which config section to add the extension to, \'common\' will affect all pages'

## nbextension install
__fish_jupyter_modifier_debug nbextension install
__fish_jupyter_modifier_user nbextension install
__fish_jupyter_modifier_system nbextension install
__fish_jupyter_modifier_sys_prefix nbextension install
__fish_jupyter_modifier_python nbextension install
complete -f -c jupyter -n '__fish_jupyter_using_command nbextension install' -l overwrite -d 'Force overwrite of existing files'
complete -f -c jupyter -n '__fish_jupyter_using_command nbextension install' -l symlink -s s -d 'Create symlink instead of copying files'
__fish_jupyter_modifier_log_level nbextension install
__fish_jupyter_modifier_config nbextension install
complete -c jupyter -n '__fish_jupyter_using_command nbextension install' -l prefix -d 'Installation prefix'
complete -c jupyter -n '__fish_jupyter_using_command nbextension install' -l nbextensions -d 'Full path to nbextensions dir (probably use prefix or user)'
complete -c jupyter -n '__fish_jupyter_using_command nbextension install' -l destination -d 'Destination for the copy or symlink'


## nbextension uninstall
__fish_jupyter_modifier_debug nbextension uninstall
__fish_jupyter_modifier_user nbextension uninstall
__fish_jupyter_modifier_system nbextension uninstall
__fish_jupyter_modifier_sys_prefix nbextension uninstall
__fish_jupyter_modifier_python nbextension uninstall
complete -c jupyter -n '__fish_jupyter_using_command nbextension uninstall' -l prefix -d 'Installation prefix'
complete -c jupyter -n '__fish_jupyter_using_command nbextension uninstall' -l nbextensions -d 'Full path to nbextensions dir (probably use prefix or user)'
complete -c jupyter -n '__fish_jupyter_using_command nbextension uninstall' -l destination -d 'Destination for the copy or symlink'



# notebook
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'notebook' -d 'The Jupyter HTML Notebook'
complete -xc jupyter -n '__fish_jupyter_using_command notebook' -a 'list' -d 'List currently running notebook servers'
complete -xc jupyter -n '__fish_jupyter_using_command notebook' -a 'stop' -d 'Stop currently running notebook server for a given port'
complete -xc jupyter -n '__fish_jupyter_using_command notebook' -a 'password' -d 'Set a password for the notebook server'

## notebook list
complete -f -c jupyter -n '__fish_jupyter_using_command notebook list' -l jsonlist -d 'Produce machine-readable JSON list output'
complete -f -c jupyter -n '__fish_jupyter_using_command notebook list' -l json -d 'Produce machine-readable JSON object on each line of output'
__fish_jupyter_modifier_log_level notebook list
__fish_jupyter_modifier_config notebook list

## notebook stop
__fish_jupyter_modifier_debug notebook stop
__fish_jupyter_modifier_generate_config notebook stop
__fish_jupyter_modifier_y notebook stop
__fish_jupyter_modifier_log_level notebook stop
__fish_jupyter_modifier_config notebook stop

## notebook password
__fish_jupyter_modifier_debug notebook password
__fish_jupyter_modifier_generate_config notebook password
__fish_jupyter_modifier_y notebook password
__fish_jupyter_modifier_log_level notebook password
__fish_jupyter_modifier_config notebook password

# qtconsole
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'qtconsole' -d 'The Jupyter QtConsole'

__fish_jupyter_modifier_debug qtconsole
__fish_jupyter_modifier_generate_config qtconsole
__fish_jupyter_modifier_y qtconsole
complete -f -c jupyter -n '__fish_jupyter_using_command qtconsole' -l plain -d 'Disable rich text support'
complete -f -c jupyter -n '__fish_jupyter_using_command qtconsole' -l banner -d 'Display a banner upon starting the QtConsole'
complete -f -c jupyter -n '__fish_jupyter_using_command qtconsole' -l no-banner -d 'Don\'t display a banner upon starting the QtConsole'
__fish_jupyter_modifier_existing qtconsole
__fish_jupyter_modifier_confirm_exit qtconsole
__fish_jupyter_modifier_no_confirm_exit qtconsole
__fish_jupyter_modifier_log_level qtconsole
__fish_jupyter_modifier_config qtconsole
complete -f -c jupyter -n '__fish_jupyter_using_command qtconsole' -l style -d 'If not empty, use this Pygments style for syntax highlighting. Otherwise, the style sheet is queried for Pygments style information'
complete -c jupyter -n '__fish_jupyter_using_command qtconsole' -l stylesheet -d 'path to a custom CSS stylesheet'
complete -f -c jupyter -n '__fish_jupyter_using_command qtconsole' -l editor -d 'A command for invoking a system text editor. If the string contains a {filename} format specifier, it will be used. Otherwise, the filename will be appended to the end the command'
complete -xc jupyter -n '__fish_jupyter_using_command qtconsole' -l paging -a "(__fish_jupyter_paging_enum)" -d 'The type of paging to use (Default: \'inside\')'
__fish_jupyter_modifier_ip qtconsole
__fish_jupyter_modifier_transport qtconsole
__fish_jupyter_modifier_hb qtconsole
__fish_jupyter_modifier_shell qtconsole
__fish_jupyter_modifier_iopub qtconsole
__fish_jupyter_modifier_stdin qtconsole
__fish_jupyter_modifier_f qtconsole
__fish_jupyter_modifier_kernel qtconsole
__fish_jupyter_modifier_ssh qtconsole
complete -xc jupyter -n '__fish_jupyter_using_command qtconsole' -l gui-completion -a "(__fish_jupyter_gui_completion_enum)" -d 'The type of completer to use (Default: \'ncurses\')'

# run
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'run' -d 'Run Jupyter kernel code'

# serverextension
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'serverextension' -d 'Work with Jupyter server extensions'

# troubleshoot
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'troubleshoot'

# trust
complete -xc jupyter -n '__fish_jupyter_needs_command' -a 'trust' -d 'Sign one or more Jupyter notebooks with your key, to trust their dynamic (HTML, Javascript) output'


