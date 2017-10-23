define icinga2::objectfile::setup (
  $owner,
  $group,
  $mode,
) {
  assert_private()

  concat { "${title}":
    ensure => present,
    path   => $name,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
    warn   => true,
  }
}
