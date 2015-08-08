
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

/* stop CentOS 7 firewalld */
service {"firewalld":
  ensure => stopped,
  enable => false,
}

# set up redis on private network
$node_config = hiera('nodes')
$redis_address = $node_config[$::hostname]['ip_addr']

$master_host = hiera('redis_master')
$master_address = $node_config[$master_host]['ip_addr']

$is_redis_master = ($master_address == $redis_address)

class { "redis":
   bind             => "${redis_address} 127.0.0.1",
   maxmemory        => '32m',
   maxmemory_policy => 'volatile-random',
   save_db_to_disk  => true,
   notify_service   => true,
   slaveof          => $is_redis_master ? {
                          false => "${master_address} 6379",
                          true => undef
                    }
}

class {"redis::sentinel":
  # take action after 5 seconds of unreachability
  down_after => '5000',
  # for production, quorum should be 2!
  quorum     => 2,
  master_name => 'my-cluster',
  redis_host => $master_address,
}