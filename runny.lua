-- imports
micro = import("micro")
config = import("micro/config")
shell = import("micro/shell")

-- Add the runny help file
config.AddRuntimeFile("runny", config.RTHelp, "help/runnyhelp.md")

-- Specify the terminal type [interactive/emulator]
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
STANDARD_INTERPRETERS["bash"] = "bash"
STANDARD_INTERPRETERS["zsh"] = "zsh"
STANDARD_INTERPRETERS["java"] = "java"
STANDARD_INTERPRETERS["javacompiler"] = "javac"
STANDARD_INTERPRETERS["go"] = "go run"


-- init function that creates a key binding and the command
function init()
    config.TryBindKey("Ctrl-F5", "lua:runny.gorun", true)
    config.TryBindKey("F5", "command-edit:runny ", true)
    config.MakeCommand("runny", argrun, NoComplete)
end


---------------------
-- argrun function --
---------------------


-- this function is called when the file is to be executed with arguments
function argrun(bp, args)
    local buf = bp.Buf
    buf:Save()
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
        command = _getInterpreter("lua") .. " " .. buf.Path .. " " .. argument
    elseif fileType == "go" then
        command = _getInterpreter("go") .. " " .. buf.Path .. " " .. arguments
    elseif fileType == "shell" then
        local type =_determineShellType(buf.Path)

        -- check if the shell file is unsupported
        if type == nil then
            return
        end

        -- build the command as usual
        command = _getInterpreter(type) .. " " .. buf.Path .. " " .. arguments
    elseif fileType == "java" then

        -- get compiled file path
        local filePathWithoutExtension = string.sub(buf.Path, 1, string.len(buf.Path) - string.len(".java"))
        compiledFilePath = filePathWithoutExtension .. ".class"

        -- compile the java file
        shell.RunCommand(_getInterpreter("javacompiler") .. " " .. buf.Path)

        -- build the command to execute the compiled file
        command = _getInterpreter("java") .. " " .. filePathWithoutExtension .. " " .. arguments
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
    buf:Save()
    local fileType = buf:FileType()

    -- build the command to be executed
    local command = ""
    if fileType == "python" then
        command = _getInterpreter("python") .. " " .. buf.Path
    elseif fileType == "lua" then
        command = _getInterpreter("lua") .. " " .. buf.Path
    elseif fileType == "go" then
        command = _getInterpreter("go") .. " " .. buf.Path
    elseif fileType == "shell" then
        local type =_determineShellType(buf.Path)

        -- check if the shell file is unsupported
        if type == nil then
            return
        end

        -- build the command as usual
        command = _getInterpreter(type) .. " " .. buf.Path
    elseif fileType == "java" then

        -- get compiled file path
        local filePathWithoutExtension = string.sub(buf.Path, 1, string.len(buf.Path) - string.len(".java"))
        compiledFilePath = filePathWithoutExtension .. ".class"

        -- compile the java file
        shell.RunCommand(_getInterpreter("javacompiler") .. " " .. buf.Path)

        -- build the command to execute the compiled file
        command = _getInterpreter("java") .. " " .. filePathWithoutExtension
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


-- helper function that allows to differenciate between different types of shell files
-- currently it determines whether a file is a bash file or a zsh file
function _determineShellType(path)
    local ioutil = import("io/ioutil")
    local fmt = import("fmt")

    -- read file from path and store contents into resultString
    local resultString, err = ioutil.ReadFile(path)
    local fileStr = fmt.Sprintf("%s", resultString)

    -- return the type of script used; nil if no shebang is there
    local type = nil

    if string.sub(fileStr, 1, string.len("#!/bin/bash")) == "#!/bin/bash" then
        type = "bash"
    elseif string.sub(fileStr, 1, string.len("#!/bin/zsh")) == "#!/bin/zsh" then
        type = "zsh"
    end

    return type
end
