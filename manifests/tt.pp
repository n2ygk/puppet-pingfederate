$stuff = {
  'a' => {'id' => 'A'},
  'b' => {'id' => 'B'},
}

$stuff.each |$k, $v| {
  notify { "${k}: ${v['id']}": }
}

