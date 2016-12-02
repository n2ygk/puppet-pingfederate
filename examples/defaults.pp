# test module with all defaults except test run.properties file
# Learn more about module testing here:
# https://docs.puppetlabs.com/guides/tests_smoke.html
# invoke with no defaults just to see what happens to the run.properties file.
class {'::pingfederate':
  install_dir                         => '/tmp/testfiles/pingfederate',
}
