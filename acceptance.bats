#!/usr/bin/env bats

@test "no droplets exist" {
  run tugboat droplets
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "You don't appear to have any droplets." ]
}

@test "provisioner runs successfully" {
  run puppet apply tests/init.pp --modulepath ../ --debug --summarize --detailed-exitcodes
  [ "$status" -eq 2 ]
}

@test "second run is idempotent" {
  run puppet apply tests/init.pp --modulepath ../ --debug --summarize --detailed-exitcodes
  [ "$status" -eq 0 ]
}

@test "we can count the correct number of droplets" {
  run bash -c "tugboat droplets | wc -l | tr -d ' '"
  [ "$status" -eq 0 ]
  [ "$output" -eq 2 ]
}

@test "we can list hosts with tugboat" {
  run tugboat droplets
  [ "$status" -eq 0 ]
  [[ "$output" == *"test-digitalocean"* ]]
  [[ "$output" == *"test-digitalocean-1"* ]]
}

@test "clean up all droplets" {
  sleep 60 # droplets can only be deleted a little after they are created
  run tugboat destroy -n test-digitalocean -c
  run tugboat destroy -n test-digitalocean-1 -c
  [ "$status" -eq 0 ]
}

@test "droplets have been cleaned up" {
  sleep 20 # the droplets are destroyed asyncronously
  run tugboat droplets
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "You don't appear to have any droplets." ]
}
