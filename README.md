# mkf (make file)

A simple bash command that generates files prefixed with the date in ISO format.

The filenames follow this structure: `\<current_date\>_\<file-name\>.\<extension\>`

Where 
- `current_date` represents today's date in the ISO `yyyy-MM-dd` format
- `filename` is an optional name for the file
- `extension` is an optional file extension

## Examples

#### Create a file with default title and no extension
```
➜ mkf
created: 2024-09-15 in: /home/username/programming/command-mkf
```

#### Create a file with default title and .log extension
```
➜ mkf -e txt
created: 2024-09-15.txt in: /home/username/programming/command-mkf
```

#### Create a file in a specific directory
```
➜ mkf -d .. -e log
created: 2024-09-15.log in: /home/username/programming
```

#### Create file with initial content
```
➜ mkf stats.log -d ~/logs -c "hello world!"
created: 2024-09-15_stats.log in: /home/username/logs
➜ cat ~/logs/2024-09-15_stats.log 
hello world!
```

#### Erase an existing file
```
➜ mkf hello.log
File '2024-09-15_hello.log' already exists. Do you want to override it? (y/n): y
Overriding existing file...
created: 2024-09-15_hello.log in: /home/username/programming/command-mkf
```

## Parameters

Here is the output of `mkf -h`, showing all available options:

```
Usage:
  mkf [filename] [-deocvih]
Options:
  -e, --extension=extension  Specify the desired extension (no extension by default)
  -d, --directory=directory  The directory where the file will be generated
  -c, --content=content      The content to write in this file
  -o, --open                 Automatically opens the file upon generation.
  -v, --version              Print the command version
  -i, --info                 Provide info about this software: version, release date, author
  -h, --help                 Display this help message and exit
```

## Install

### From Source

1. Clone this repository: `git clone https://github.com/Julien-Fischer/cmd-mkf`.
2. Grant execution permissions: `cd cmd-mkf; chmod +x mkf`
3. Move the script to user executables, for instance: `sudo mv mkf /usr/local/bin`

Confirm `mkf` is installed:

```
➜ mkf -v
mkf version 0.1.0 [2024-09-15]
```

## License

Apache 2.0. See `LICENSE`.
