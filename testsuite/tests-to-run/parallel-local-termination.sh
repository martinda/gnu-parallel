#!/bin/bash

level1_prog=$(mktemp)
level2_prog=$(mktemp)

cat <<EOF >$level2_prog
#!/bin/bash
echo "Started level2 \$1"
function onkill {
  touch killed-level2.\$1
  rm level3.\$1.pid
  kill -INT \$pid
  trap - INT
  kill \$\$
}
function onterm {
  touch terminated-level2.\$1
  rm level3.\$1.pid
  # We don't need to kill the spawned process because GNU Parallel kills the process tree
  # kill -TERM \$pid
  exit 143
}
trap 'onkill \$1' INT
trap 'onterm \$1' TERM
sleep 20 & pid=\$!
echo \$pid >level3.\$1.pid
wait \$pid
rm level3.\$1.pid
echo "Done level2 \$1"
EOF
chmod +x $level2_prog

cat <<EOF >$level1_prog
#!/bin/bash
echo \$\$ >level1.\$1.pid
function onkill {
  echo \$\$ >killed-level1.\$1.pid
  rm level[12].\$1.pid
  kill -INT \$pid
  trap - INT
  kill \$\$
}
function onterm {
  touch terminated-level1.\$1
  rm level[12].\$1.pid
  # We don't need to kill the spawned process because GNU Parallel kills the process tree
  # kill -TERM \$pid
  exit 143
}
echo "Started level1 \$1"
trap 'onkill \$1' INT
trap 'onterm \$1' TERM
$level2_prog \$1 & pid=\$!
echo \$pid >level2.\$1.pid
wait \$pid
rm level2.\$1.pid
echo "Done level1 \$1"
rm level1.\$1.pid
EOF
chmod +x $level1_prog

# Monitor for the default termination sequence
# The default termination sequence is TERM, wait 200ms, TERM, wait 200ms, KILL
# This termination sequence is sent to all processes in the process tree
# The cannot monitor the KILL, but we can monitor the first two TERM
# The 200ms interval is a bit short for an accurate measurement, so we're not measuring it
#
default_term_seq_monitor=$(mktemp)
cat <<EOF >$default_term_seq_monitor
#!/bin/bash
rm -rf "\$2"
trap 'echo "TERM" >>"\$2";' TERM
# Spawn a child process that does not die with SIGTERM so we can test
# that GNU Parallel does not wait for it to die
sleep 20 &
pid=\$!
echo "# \$1 Wait for the first TERM"
wait \$pid
trap 'echo "TERM" >>"\$2"; kill \$pid;' TERM
sleep 20 &
pid=\$!
echo "# \$1 Wait for the second TERM"
wait \$pid
sleep 20 &
pid=\$!
echo "# \$1 Wait for the KILL"
wait \$pid
echo "This line should not be printed" >>"\$2"
EOF
chmod +x $default_term_seq_monitor

# A monitor for a custom termination sequence (TERM,2,TERM,4,INT)
custom_term_seq_monitor=$(mktemp)
cat <<EOF >$custom_term_seq_monitor
#!/bin/bash
rm -rf "\$2"
start=\$(date +%s)
trap 'echo "TERM: \$((\$(date +%s) - \$start))" >>"\$2";' TERM
trap 'echo "INT: \$((\$(date +%s) - \$start))" >>"\$2"; trap - INT; kill -INT \$\$;' INT
sleep 30 &
pid=\$!
echo "# \$1 Wait for TERM"
wait \$pid
sleep 30 &
pid=\$!
trap 'echo "TERM: \$((\$(date +%s) - \$start))" >>"\$2"; kill \$pid;' TERM
echo "# \$1 Wait for TERM 2"
wait \$pid
sleep 30 &
pid=\$!
echo "# \$1 Wait for INT"
wait \$pid
echo "This line should not be printed" >>"\$2"
EOF
chmod +x $custom_term_seq_monitor

# A monitor for a custom termination sequence (TERM,2,QUIT,4,INT)
custom_term_seq_monitor_quit=$(mktemp)
cat <<EOF >$custom_term_seq_monitor_quit
#!/bin/bash
rm -rf "\$2"
start=\$(date +%s)
trap 'echo "TERM: \$((\$(date +%s) - \$start))" >>"\$2";' TERM
trap 'echo "QUIT: \$((\$(date +%s) - \$start))" >>"\$2"; kill \$pid;' QUIT
trap 'echo "INT: \$((\$(date +%s) - \$start))" >>"\$2"; trap - INT; kill -INT \$\$;' INT
sleep 30 &
pid=\$!
echo "# \$1 Wait for TERM"
wait \$pid
sleep 30 &
pid=\$!
echo "# \$1 Wait for QUIT"
wait \$pid
sleep 30 &
pid=\$!
echo "# \$1 Wait for INT"
wait \$pid
echo "This line should not be printed" >>"\$2"
EOF
chmod +x $custom_term_seq_monitor_quit

# Redirect all output
exec > >(tee /tmp/parallel$$)
exec 2>&1

nproc=5

function test1 {
  echo '############################################'
  echo '### Test SIGTERM (wait for jobs to finish) #'
  echo '############################################'
  parallel -k -j $nproc $level1_prog ::: {0..99} &
  parallel_pid=$!
  echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
  wait $parallel_pid
  echo "### Checking for lingering files, there should be none."
  shopt -s nullglob
  lingering_files=(*.pid killed-* terminated-*)
  if [[ ${#lingering_files} -gt 0 ]]; then
    echo "Error: some files have been left behind"
    printf "%s\n" "${lingering_files[@]}"
  fi
  rm -rf "${lingering_files[@]}"
}

function test2 {
  echo '####################################################################'
  echo '### Test SIGTERM (send two SIGTERM, do not kill spawned processes) #'
  echo '####################################################################'
  parallel -k -j $nproc $level1_prog ::: {0..99} &
  parallel_pid=$!
  echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
  echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
  wait $parallel_pid
  echo "### Checking for lingering pid files, they should exist"
  pids=()
  for ((idx=0; idx<$nproc; idx++)); do
    [[ ! -e level1.$idx.pid ]] && echo "Error: level1.$idx.pid should exist but it does not"
    [[ ! -e level2.$idx.pid ]] && echo "Error: level2.$idx.pid should exist but it does not"
    [[ ! -e level3.$idx.pid ]] && echo "Error: level3.$idx.pid should exist but it does not"
    pids+=($(cat level1.$idx.pid))
    pids+=($(cat level2.$idx.pid))
    pids+=($(cat level3.$idx.pid))
  done
  rm -rf *.pid
  for pid in ${pids[@]}; do
    ps $pid 2>&1 >/dev/null || echo "Error: pid $pid is not running but it should. GNU Parallel should not kill this process."
  done
  echo "### Waiting for spawned processes to complete, be patient."
  for pid in ${pids[@]}; do
    while ps $pid 2>&1 >/dev/null; do sleep 1; done
  done
  echo "### Checking for lingering files, there should be none."
  lingering_files=(*.pid killed-* terminated-*)
  if [[ ${#lingering_files} -gt 0 ]]; then
    echo "Error: some files have been left behind"
    printf "%s\n" "${lingering_files[@]}"
  fi
  rm -rf "${lingering_files[@]}"
}

function test3 { 
  echo '##############################################################'
  echo '### Test --timeout (expect the default termination sequence) #'
  echo '##############################################################'
  parallel --timeout 2 -k -j $nproc $default_term_seq_monitor {} term_seq.{}.txt ::: {0..4} &
  parallel_pid=$!
  echo "Timing out in 2 seconds..."
  wait $parallel_pid
  (echo "TERM"; echo "TERM") >expected.txt
  for ((idx=0; idx<$nproc; idx++)); do
    if ! diff -q expected.txt term_seq.${idx}.txt; then
      echo "Expected termination sequence:"
      cat expected.txt
      echo "Actual termination sequence:"
      cat term_seq.${idx}.txt
      echo "Error: expected termination sequence is different than the actual termination sequence."
    fi
  done
  rm term_seq.*.txt
  rm expected.txt
}

function test4 {
  echo '###########################################################'
  echo '### Test --timeout (expect a custom termination sequence) #'
  echo '###########################################################'
  nproc=1
  parallel --debug term --term-seq TERM,2,TERM,4,INT --timeout 2 -k -j $nproc $custom_term_seq_monitor {} term_seq.{}.txt ::: 0 &
  parallel_pid=$!
  echo "Timing out in 2 seconds..."
  wait $parallel_pid
  (echo "TERM: 2"; echo "TERM: 4"; echo "INT: 8") >expected.txt
  for ((idx=0; idx<$nproc; idx++)); do
    if ! diff -q expected.txt term_seq.${idx}.txt; then
      echo "Expected termination sequence:"
      cat expected.txt
      echo "Actual termination sequence:"
      cat term_seq.${idx}.txt
      echo "Error: expected termination sequence is different than the actual termination sequence."
    fi
  done
  rm term_seq.*.txt
  rm expected.txt
}

function test5 {
  echo '########################################'
  echo '### Test --timeout (TERM,2,QUIT,4,INT) #'
  echo '########################################'
  nproc=1
  parallel --debug term --term-seq TERM,2,QUIT,4,INT --timeout 2 -k -j $nproc $custom_term_seq_monitor_quit {} term_seq.{}.txt ::: 0 &
  parallel_pid=$!
  echo "Timing out in 2 seconds..."
  wait $parallel_pid
  (echo "TERM: 2"; echo "QUIT: 4"; echo "INT: 8") >expected.txt
  for ((idx=0; idx<$nproc; idx++)); do
    if ! diff -q expected.txt term_seq.${idx}.txt; then
      echo "Expected termination sequence:"
      cat expected.txt
      echo "Actual termination sequence:"
      cat term_seq.${idx}.txt
      echo "Error: expected termination sequence is different than the actual termination sequence."
    fi
  done
  rm term_seq.*.txt
  rm expected.txt
}

test1
test2
test3
test4
test5

# Clean up
rm $level1_prog
rm $level2_prog
rm $default_term_seq_monitor
rm $custom_term_seq_monitor
rm $custom_term_seq_monitor_quit

rm -rf /tmp/parallel$$

# Not sure about how to write these tests, so exit 1
exit 1
