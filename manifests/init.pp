# == Class: atop
#
# Allow to install and configure atop.
#
# === Parameters
#
# [*package_name*]
#   Package name, default to atop.
#
# [*service_name*]
#   Service name, default to atop.
#
# [*service*]
#   Enable atop service, default to false.
#
# [*interval*]
#   Interval between snapshots, default to 600.
#
# [*logpath*]
#   Directory were the log will be saved by the service.
#   Default is /var/log/atop.
class atop (
  $package_name = $atop::params::package_name,
  $service_name = $atop::params::service_name,
  $service      = $atop::params::service,
  $interval     = $atop::params::interval,
  $logpath      = $atop::params::logpath,
) inherits atop::params {
  $service_state = $service ? {
    true    => 'running',
    default => 'stopped',
  }

  package { $package_name:
    ensure => 'installed',
  } ->
  file { $atop::params::conf_file:
    ensure  => 'file',
    owner   => $atop::params::conf_file_owner,
    group   => $atop::params::conf_file_group,
    mode    => $atop::params::conf_file_mode,
    content => template($atop::params::conf_file_template),
    notify  => Service[$service_name],
  } ->
  service { $service_name:
    ensure => $service_state,
    enable => $service,
  }

  # Atop has different raw files between versions
  # If you upgrade and the raw version is from a previous version atop refuses to boot
  # So lets make a symlink
  if ( $::atop_version) {
    file{"${logpath}_${::atop_version}":
      ensure  => 'directory',
      mode    => '0755',
      owner   => root,
      group   => root,
    }
    file{$logpath:
      ensure => 'link',
      force  => true,
      target => "${logpath}_${::atop_version}",
    }
  }
}

# vim: set et sw=2:
