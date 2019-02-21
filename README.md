# Mailbox.org Command Line Interface

This is an unofficial command line interface for the Mailbox.org API v1.
Please note, this CLI is still under development and doesn't support all API methods yet.
Please refer to [Status](#status) to check the state of completion.

## Requirements

This CLI requires Ruby 2.0+, any recent Ruby versions will be fine. Please refer to [rbenv](https://github.com/rbenv/rbenv) to install Ruby on your system if you're using OSX or GNU/Linux.
For Windows Users you can use [RubyInstaller](https://rubyinstaller.org/).

## Installation

Clone this repo:

```ruby
git clone https://github.com/loyaruarutoitsu/mailbox-cli.git
```

And then execute:

    $ bundle

## Usage

Change into the cloned repo then execute the following first to authenticate.

    $ bin/cli auth

After that you can list all commands by entering:

    $ bin/cli help

### Status

The following actions have been implemented:

    account_add               # Creates a new account
    account_get               # Returns information about an account
    account_list              # Returns a list of all accounts that can be administrated
    auth                      # Performs a login (Authentication)
    deauth                    # Performs a logout
    domain_add                # Adds a domain
    domain_get DOMAIN         # Returns details about a domain
    domain_list               # Returns a list of all existing domains
    hello_innerworld          # Returns the string 'Hello Inner-World!' if called from a valid session
    hello_world               # Returns the string 'Hello World!'
    mail_backup_list MAIL     # Lists all existing E-Mail-backups
    mail_blacklist_list MAIL  # Lists all blacklist entries
    mail_del MAIL             # Deletes an e-mail address
    mail_get MAIL             # Returns e-mail address details
    mail_list DOMAIN          # Returns a list of e-mail addresses + configuration information
    mail_set MAIL PREFERENCE  # Modifies e-mail address properties
    mail_spamprotect_get      # Read spamprotection settings

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/loyaruarutoitsu/mailbox-cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
This software comes without any warranty or official support.
