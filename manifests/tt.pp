[{'name' => 'a'},{'name' => 'b'},{'name' => 'c'}].each |$a| {
  $b = $a
  notify { $b['name']: }
}

