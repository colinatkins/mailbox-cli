# Mailbox.org Command Line Interface

This is an unofficial command line interface for the [Mailbox.org API v1](https://api.mailbox.org/v1/doc/methods/index.html).
It comes without official warranty or support. If you have questions about the API please contact Mailbox.org Support.

## Requirements

This CLI requires Ruby 2.0+, any recent Ruby versions will be fine. Please refer to [rbenv](https://github.com/rbenv/rbenv) to install Ruby on your system if you're using OSX or GNU/Linux.
For Windows Users you can use [RubyInstaller](https://rubyinstaller.org/).

## Installation

Clone this repo with OSX Terminal or GNU/Linux command line or through other git tools:

```bash
git clone https://github.com/loyaruarutoitsu/mailbox-cli.git
```

And then change into the directory and execute dependency package installation through command line:

    $ cd mailbox-cli
    $ bundle

## Usage

Authenticate once to execute any subsequent commands.

    $ bin/cli auth

After the first successful authentication your account-name and password is saved within the directory inside the file ".auth.yml".
That Auth info is used for any subsequent commands.

**Attention:** The password is not encrypted so do not share that file with anyone.

After that you can list all commands by entering:

    $ bin/cli help
    
### Example

#### Creating domain and first mail address

    $ bin/cli domain_add
    $ bin/cli mail_add max@mustermann-maschinen.de
    
#### Setting aliases for mail address

    $ bin/cli mail_set max@mustermann-maschinen.de aliases
    $ info@mustermann-maschinen.de,office@mustermann-maschinen.de
    
### Preferences

If you are unsure about what preferences you can use when creating accounts, domains or mails please check the official [API documentation](https://api.mailbox.org/v1/doc/methods/index.html).

### Commands

The following commands have been implemented:

| Command                                         | Desc                  |
| ----------------------------------------------- | --------------------- |
| bin/cli account_add                             | Creates a new account |
| bin/cli account_del                             | (Method not implemented yet) Deletes an existing account |
| bin/cli account_get                             | Returns information about an account |
| bin/cli account_list                            | Returns a list of all accounts that can be administrated |
| bin/cli account_set PREFERENCE                  | Change preferences of an account |
| bin/cli auth                                    | Performs a login (Authentication) |
| bin/cli context_list                            | Returns a list of Context-IDs and associated domains |
| bin/cli deauth                                  | Performs a logout |
| bin/cli domain_add                              | Adds a domain |
| bin/cli domain_capabilities_set DOMAIN          | Modifies domain emails capabilities |
| bin/cli domain_del DOMAIN                       | Removes a domain from an account |
| bin/cli domain_get DOMAIN                       | Returns details about a domain |
| bin/cli domain_list                             | Returns a list of all existing domains |
| bin/cli domain_set DOMAIN PREFERENCE            | Modifies domain properties |
| bin/cli hello_innerworld                        | Returns the string 'Hello Inner-World!' if called from a valid session |
| bin/cli hello_world                             | Returns the string 'Hello World!' |
| bin/cli help [COMMAND]                          | Describe available commands or one specific command |
| bin/cli mail_add MAIL                           | Adds an e-mail address |
| bin/cli mail_backup_import MAIL                 | Import an E-Mail-Backup into the users mailaccount |
| bin/cli mail_backup_list MAIL                   | Lists all existing E-Mail-backups |
| bin/cli mail_blacklist_add MAIL ADD_ADDRESS     | Adds an address to the blacklist |
| bin/cli mail_blacklist_del MAIL DELETE_ADDRESS  | Deletes an address from the blacklist |
| bin/cli mail_blacklist_list MAIL                | Lists all blacklist entries |
| bin/cli mail_del MAIL                           | Deletes an e-mail address |
| bin/cli mail_get MAIL                           | Returns e-mail address details |
| bin/cli mail_list DOMAIN                        | Returns a list of e-mail addresses + configuration information |
| bin/cli mail_register TOKEN                     | Adds an e-mail address (using a predefined token) |
| bin/cli mail_set MAIL PREFERENCE                | Modifies e-mail address properties |
| bin/cli mail_spamprotect_get MAIL               | Read spamprotection settings |
| bin/cli mail_spamprotect_set MAIL               | Sets the spamprotection settings |
| bin/cli search                                  | Searches in accounts, domains and e-mails |
| bin/cli test_accountallowed                     | Confirms if the account can be administrated using the current ACLs |
| bin/cli test_domainallowed DOMAIN               | Confirms if the domain can be administrated using the current ACLs |
| bin/cli utils_validator                         | Performs a validation |

## Contributing

Please report bugs if you find them. Feel free to test the software and contribute by sending suggestions on how to improve the software.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
This software comes without any warranty or official support.
