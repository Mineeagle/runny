-- imports
micro = import("micro")
config = import("micro/config")
shell = import("micro/shell")

-- Specify the temrinal type [interactive/emulator]
TERMINAL_TYPE_OPTION_NAME = "runny.terminaltype"

-- This is used to define an interpreter for a specific language.
-- Append the language name at the end to get the name runny is looking for
-- Python -> runny.interpreterpython
-- Lua -> runny.interpreterlua
-- This allows to overwrite the standard interpreter defined below
INTERPRETER_OPTION_NAME = "runny.interpreter"

-- standard interpreters; used to determine the standards for executing the files
STANDARD_INTERPRETERS = {}
STANDARD_INTERPRETERS["python"] = "python3"
STANDARD_INTERPRETERS["lua"] = "lua"


-- init function that creates a key binding and the command
function init()
    config.TryBindKey("Ctrl-F5", "lua:runny.gorun", true)
    config.MakeCommand("runny", argrun, NoComplete)
end


---------------------
-- argrun function --
---------------------


-- this function is called when the file is to be executed with arguments
function argrun(bp, args)
    local buf = bp.Buf
    local fileType = buf:FileType()
    local arguments = ""

    -- get the users arguments
    local index = 1
    while pcall(_getValueAtIndex, args, index) do
        arguments = arguments .. " " .. args[index]
        index = index + 1
    end

    -- similiar to gorun; build the command to be executed
    if fileType == "python" then
        command = _getInterpreter("python") .. " " .. buf.Path .. " " .. arguments
    elseif fileType == "lua" then
        command = _getInterpreter("lua") .. " " .. buf.Path .. " " .. arguments
    else
        return
    end

    -- execute the command using the _runTerminal function
    _runTerminal(command)
end


-- helper function that allows to make use of the pcall error handling function
function _getValueAtIndex(args, index)
    return args[index]
end


---------------------
-- gorun function --
---------------------

-- function that runs the current file; standard key binding is Ctrl-F5
function gorun(bp)
    local buf = bp.Buf
    local fileType = buf:FileType()

    -- build the command to be executed
    if fileType == "python" then
        command = _getInterpreter("python") .. " " .. buf.Path
    elseif fileType == "lua" then
        command = _getInterpreter("lua") .. " " .. buf.Path
    else
        return
    end

    -- execute the command using the _runTerminal function
    _runTerminal(command)
end


----------------------
-- Helper functions --
----------------------


-- helper function to execute a command with the users preferences
function _runTerminal(command)
    local type = _getTypePreference()

    if type == "interactive" then
        shell.RunInteractiveShell(command, true, false)
    elseif type == "emulator" then
        local curPane = micro.CurPane()
        shell.RunTermEmulator(curPane, command, true, false, nil, nil)
    else
        shell.RunInteractiveShell(command, true, false)
    end
end


-- helper function to get the terminal type preference
function _getTypePreference()
    local option = config.GetGlobalOption(TERMINAL_TYPE_OPTION_NAME)
    if option == "interactive" or option == "emulator" then
        return option
    else
        return "interactive"
    end
end


-- helper function to retrieve the interpreter preference for a given language
function _getInterpreter(language)
    local option = config.GetGlobalOption(INTERPRETER_OPTION_NAME .. language)
    if option == nil then
        return STANDARD_INTERPRETERS[language]
    else
        return option
    end
end
