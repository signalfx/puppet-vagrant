# Public: Installs Vagrant
#
# Usage:
#
#   include vagrant

class vagrant(
  $version = '2.0.2',
  $completion = false
) {
  validate_bool($completion)

  $ensure_completion = $completion ? {
    true    => 'present',
    default => 'absent',
  }

  package { "Vagrant_${version}":
    ensure   => installed,
    source   => "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.dmg",
    provider => 'pkgdmg'
  }

  file { "/Users/${::boxen_user}/.vagrant.d":
    ensure  => directory,
    require => Package["Vagrant_${version}"],
  }

  homebrew::tap { 'homebrew/completions':
    ensure => $ensure_completion,
  }

  package { 'vagrant-completion':
    ensure   => $ensure_completion,
    provider => 'homebrew',
    require  => Homebrew::Tap['homebrew/completions'],
  }
}
