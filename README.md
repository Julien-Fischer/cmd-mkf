# mkf (make file)

Save time by generating timestamped and preformatted files for your meeting minutes, logs, etc.
This command is design to be simple to use and easily adaptable to your specific needs.

## Features

- **Automatic File Generation**: Create files with a name based on the current date and time in ISO format.
- **Customizable Templates**: Use preformatted templates to structure your documents, and create your owns.
- **Time-saving**: Automate file creation for your meetings, logs, or any other documentation needs.

## Customization

You can customize the templates used by the script or create your own by adding them in the `/usr/local/share/mkf/templates` directory.


## Prerequisites

- **Operating System**: Linux (tested on Debian 12 and Kubuntu 24)
- **Bash**: Ensure that Bash is installed on your system (usually installed by default on most Unix/Linux distributions)

## Parameters

Here is the output of `mkf -h`, showing all available options:

```
Usage:

  mkf [filename] [-cdeotT][-ihv]

Main operation mode:

  -c, --content=content           The content to write in this file
  -d, --directory=directory       The directory where the file will be generated
  -e, --extension=extension       Specify the desired extension (no extension by default)
  -o, --open[=software]           Automatically opens the file upon generation using default or specified software.
  -t, --time                      Uses a datetime prefix instead of a date prefix.
  -T, --template=template_name    Initializes the file using the specified template
  
Information output:
  
  -h, --help                      Display this help message and exit
  -i, --info                      Provide info about this software: version, release date, author
  -v, --version                   Print the command version
```


## Examples

#### Create a file with default title and no extension
```
➜ mkf
created: 2024-09-15 in: /home/username/Desktop
```

#### Create a file with current datetime as prefix
```
➜ mkf -t
created: 2024-09-15_11-32-54 in: /home/username/Desktop
```

#### Create a file with default title and .txt extension
```
➜ mkf -e txt
created: 2024-09-15.txt in: /home/username/Desktop
```

#### Create and open a file with specified software (e.g. VIM)
```
➜ mkf -o vim
created: 2024-09-20 in: /home/username/Desktop
opening 2024-09-20 in vim
```

#### Create a file with initial content
```
➜ mkf stats.log -d ~/logs -c "hello world!"
created: 2024-09-15_stats.log in: /home/username/logs
➜ cat ~/logs/2024-09-15_stats.log 
hello world!
```

#### Create a file from the specified template
```
➜ mkf important-meeting.txt -T meeting
created: 2024-09-15_important-meeting.log in: /home/username/meetings
```

## Install

1. Download or clone this repository:
```
git clone https://github.com/Julien-Fischer/cmd-mkf
```

2. Execute the installer
```
cd cmd-mkf/src; ./install.sh
```

3. Confirm `mkf` is installed:
```
mkf -v
```

## Uninstall

To remove `mkf`, run the uninstallation wizard.
```
➜ cd /usr/local/bin; ./mkf-uninstall.sh
This will uninstall mkf.
Are you sure you want to proceed? (y/n): y
Uninstalling...
  Removing 2 templates:
  - log
  - meeting
  Removing command files...
    Removed mkf-uninstall.sh from /usr/local/bin
    Removed mkf from /usr/local/bin
    Removed mkf-functions.sh from /usr/local/bin
mkf successfully uninstalled.
```

## Contributing

`mkf` is an open-source project; community contributions are welcome.

If you want to improve this script or add new features, feel free to open a pull request.

## License

Apache 2.0. See [License](https://github.com/Julien-Fischer/cmd-mkf/blob/master/LICENSE).
