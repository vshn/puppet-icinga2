define icinga2::objectfile (
  $ensure,
  $target_dir,
  $owner,
  $group,
  $mode,
  $order,
  $content,
) {
  assert_private()
  validate_re($ensure, '^(present|file|absent)$')
  validate_absolute_path($target_dir)
  validate_string($order)
  validate_string($content)

  include ::icinga2

  $_default_owner = $::icinga2::config_owner
  $_default_group = $::icinga2::config_group
  $_default_mode = $::icinga2::config_mode

  # Ensure resource name is unique per parameter combination
  if ($owner == $_default_owner and
      $group == $_default_group and
      $mode == $_default_mode) {
    $_target = "${target_dir}/objects.conf"
  } else {
    $_target = "${target_dir}/objects-${owner}-${group}-${mode}.conf"
  }

  ensure_resource('icinga2::objectfile::setup', $_target, {
    owner => $owner,
    group => $group,
    mode  => $mode,
    })

  if ($ensure == 'file' or $ensure == 'present') {
    ::concat::fragment { "${_target}-${title}":
      target  => $_target,
      order   => regsubst(sprintf("20 %s %s", $order, $title), '[/:]', '_', 'G'),
      content => $content,
      notify  => $_notify,
    }
  }
}
