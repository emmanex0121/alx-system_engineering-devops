#!/usr/bin/env pup

file { '~/.ssh/config':
    ensure  => file,
    owner   => 'ubuntu',
    group   => 'phoenix',
    mode    => '0600',
    content => "
        Host 54.196.42.238
            IdentityFile ~/.ssh/school
            PasswordAuthentication no
    ",
}

