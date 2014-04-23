puppet-atop
===========

Puppet module for managing atop.

Tested under:
* Scientific Linux 5
* Scientific Linux 6
* CentOS 6
* Debian Wheezy

## Usage

Install atop and disable service.

``` ruby
class { 'atop': }
```

Install atop, configure and enable service.

``` ruby
class { 'atop':
  service  => true,
  interval => 120,
}
```
