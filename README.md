puppet-pushover
==========

Description
-----------

A Puppet report handler for sending notifications of failed runs to Pushover.

Requirements
------------

* `puppet` (version 2.6.5 and later)

Installation & Usage
--------------------

1.  Install puppet-pushover as a module in your Puppet master's module
    path.

2.  Update the `apikey` and `userkey` variables in the `pushover.yaml` file with
    your Pushover application key (you'll need to create an application)
    and your user key.

3.  Enable pluginsync and reports on your master and clients in `puppet.conf`

        [master]
        report = true
        reports = pushover
        pluginsync = true
        [agent]
        report = true
        pluginsync = true

4.  Run the Puppet client and sync the report as a plugin

Author
------

James Turnbull <james@lovedthanlost.net>

License
-------

    Author:: James Turnbull (<james@lovedthanlost.net>)
    Copyright:: Copyright (c) 2011 James Turnbull
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
