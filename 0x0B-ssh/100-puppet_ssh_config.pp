file { '/home/phoenix/.ssh/config':
    ensure  => file,
    owner   => 'phoenix',
    group   => 'phoenix',
    mode    => '0600',
    content => "
        Host 54.196.42.238
            IdentityFile ~/.ssh/school
            PasswordAuthentication no
    ",
}

