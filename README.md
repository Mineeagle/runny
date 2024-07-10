# runny
Runny allows to execute files, such as `.py` files from within Micro. There are two options to run a file:

1. Without arguments
2. With arguments

Currently, the following programming languages are supported:

- Lua
- Python
- Shell (bash & zsh)
- Java
- Go

If would like to see an addition to these, please create an issue on GitHub or feel free to create a pull request.

# Installation

In order to install runny - make sure Micro is installed in the first place - simply clone this repository and run `make`:

```bash
git clone https://github.com/Mineeagle/runny.git
cd runny
make
```

# Usage

Runny allows to execute files, such as `.py` files from within Micro. There are two options to run a file:
1. Without arguments
2. With arguments

Please have a look at the [currently supported files](#supported-file-types) to ensure that runny currently supports your file type.

At any time, you can type `> help runnyhelp` to see the runny help file on how to use runny.

## Execution without arguments

In order to execute a file, open the file in Micro, set your cursor onto it, and press `Ctrl+F5`. This keybinding can be changed in the `bindings.json` file by specifying an entry named `lua:runny.gorun`.

It may look like this:

```json
{
    "Ctrl-F1": "lua:runny.gorun"
}
```

## Execution with arguments

In order to execute the file with arguments, open the file in Micro, set the cursor to it, and then type the following command.

```
> runny <arg1> <arg2> ... <argN>
```

(Alternatively, you can also just press `F5`, and the command prompt will open, ready to take your input.)

Replace the `<args>` with the arguments you want to pass through. It may look like this:

```
> runny hello world!
```

Please be aware that the arguments will be split using spaces. **Do no use arguments that contain spaces!**

## Supported file types

Currently, the following programming languages are supported:

- Lua
- Python
- Shell (bash & zsh)
- Java
- Go

If would like to see an addition to these, please create an issue on [GitHub](https://github.com/Mineeagle/runny) or feel free to create a pull request.

# Customization

You can change some options for runny, or change the keybinding to execute a file:

### Options

| Option                          | Pupose                                                                                    | Default       | Accepted values             |
|---------------------------------|-------------------------------------------------------------------------------------------|---------------|-----------------------------|
| `runny.terminaltype`            | Type of the terminal that is used to execute the file                                     | `interactive` | `interactive` or `emulator` |
| `runny.interpreterpython`       | Python interpreter that will be used to execute python files                              | `python3`     |                             |
| `runny.interpreterlua`          | Lua interpreter that will be used to execute lua files                                    | `lua`         |                             |
| `runny.interpreterbash`         | Bash interpreter that will be used to execute shell files with this shebang `#!/bin/bash` | `bash`        |                             |
| `runny.interpreterzsh`          | Zsh interpreter that will be used to execute shell files with this shebang `#!/bin/zsh`   | `zsh`         |                             |
| `runny.interpreterjava`         | Java executable that will be used to execute compiled java files                          | `java`        |                             |
| `runny.interpreterjavacompiler` | Java compiler                                                                             | `javac`       |                             |
| `runny.interpretergo`           | Go interpreter that will be used to execute go files                                      | `go run`      |                             |

### Keybindings

| Purpose                                                           | name for `bindings.json` | Default |
|-------------------------------------------------------------------|--------------------------|---------|
| Execute the current file without arguments                        | `lua:runny.gorun`        | Ctrl-F5 |
| Open the command line with `runny ` pre-typed to accept arguments | `command-edit:runny`     | F5      |

# Roadmap

- Support more programming languages
- Do some more testing (especially using `zsh` files)
- Add a way to update runny

(This roadmap is in no particular order.)

# Changelog

1.3.0
- Add [runnyhelp](./help/runnyhelp.md) as a help document; accessible using `> help runnyhelp`
- Go is now supported support
- Shortcut to run files with arguments using F5

1.2.0
- Add Java support
- The executed buffer will be saved before running the file
- [makefile](./makefile) can now also uninstall runny

1.1.0
- Add two new supported language for shell scripts:
    - bash
    - zsh

1.0.0
- Initial release
