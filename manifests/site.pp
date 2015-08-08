
notify{"Started on  ${fqdn}": }


Package{  allow_virtual => false }

# set default
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# enable epel for now
yumrepo {"epel":
#  descr       => 'Extra Packages for Enterprise Linux 7 - $basearch',
#  ensure      => present,
#  mirrorlist  => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
  enabled     => 1,
}

Yumrepo<| |> -> Package<| |>

/* install random packages */
package{["vim-enhanced", "psmisc", "htop"]:
  ensure => present,
}

class { "redis":
   bind             => '0.0.0.0',
   maxmemory        => '32m',
   maxmemory_policy => 'volatile-random',
   save_db_to_disk  => true,
   notify_service   => true,
}