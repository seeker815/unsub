# Unsub ![Version](https://img.shields.io/gem/v/unsub.svg?style=flat-square)

Proof-of-concept autoscaling "polyfill" for Sensu, Icinga & Chef

On _launch_:

- Icinga: Disable host downtime
- Chef: Remove tag "termianted", add tag "launched"

On _terminate_:

- Sensu: Remove host's client
- Icinga: Enable host downtime
- Chef: Remove tag "launched", add tag "terminated"



## Installation, Usage &c.

### Installation

Download the appropriate package for your system from the [GitHub releases page](https://github.com/sczizzo/unsub/releases)

If you've got a sane Ruby environment around, you can use RubyGems:

    $ gem install unsub

### Usage

Just call for help!

    $ unsub help
    Commands:
      unsub art            # Show the application art
      unsub go ...         # Start the main event loop
      unsub help [COMMAND] # Describe available commands or one specific command
      unsub version        # Show the application version

Probably you're most interested in the default command (`go`):

    $ unsub help go
    Usage:
      unsub go \
        -c, --icinga-cmd=ICINGA_CMD \
        -k, --knife-file=KNIFE_FILE \
        -q, --queue-url=QUEUE_URL   \
        -s, --sensu-url=SENSU_URL

    Options:
      -d, [--database=DATABASE]    # Local database path
                                   # Default: .ops1722.db
      -q, --queue-url=QUEUE_URL    # SQS Queue URL
      -c, --icinga-cmd=ICINGA_CMD  # Icinga Command URI
      -s, --sensu-url=SENSU_URL    # Sensu API base URL
      -k, --knife-file=KNIFE_FILE  # Knife file for Chef
                                   # Default: $HOME/.chef/knife.rb
      -l, [--log=LOG]              # Log to file instead of STDOUT
      -v, [--debug], [--no-debug]  # Enable DEBUG-level logging
      -z, [--trace], [--no-trace]  # Enable TRACE-level logging

    Start the main event loop

Here's an example:

    $ unsub \
      -q 'https://sqs.my-region.amazonaws.com/123456789/my-queue' \
      -c 'http://username:password@icinga/cgi-bin/icinga/cmd.cgi' \
      -s 'http://sensu:1234' -d '/var/data/unsub.db'



## Changelog

### v1.0

_In development_

- Initial support for Sensu, Icinga & Chef