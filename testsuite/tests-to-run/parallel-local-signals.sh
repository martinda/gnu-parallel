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

exec > >(tee /tmp/parallel$$)
exec 2>&1

echo '############################################'
echo '### Test SIGTERM (wait for jobs to finish) #'
echo '############################################'
nproc=5
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

echo '#############################################'
echo '### Test SIGTERM 1 (kill spawned processes) #'
echo '#############################################'
parallel --propagate-sigterm1 -k -j $nproc $level1_prog ::: {0..99} &
parallel_pid=$!
echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
echo "### Waiting for GNU parallel to complete"
wait $parallel_pid
ret=$?
if [[ $ret -ne 143 ]]; then
  echo "Error: expected exit status 143, but it is $ret"
fi
echo "### Checking that the TERM traps were executed"
lingering_pid_files=(*.pid)
if [[ ${#lingering_pid_files[@]} -gt 0 ]]; then
  echo "Error: some pid files remain, this means the traps did not execute properly"
  printf "%s\n" "${lingering_pid_files[@]}"
fi
rm -rf *.pid
for ((idx=0; idx<$nproc; idx++)); do
  [[ ! -e terminated-level1.$idx ]] && echo "Error: terminated-level1.$idx should exist but it does not"
  [[ ! -e terminated-level2.$idx ]] && echo "Error: terminated-level2.$idx should exist but it does not"
  [[ -e killed-level1.$idx ]] && echo "Error: killed-level1.$idx should not exist but it does"
  [[ -e killed-level2.$idx ]] && echo "Error: killed-level2.$idx should not exist but it does"
done
rm -rf terminated-* killed-*

echo '#############################################'
echo '### Test SIGTERM 2 (kill spawned processes) #'
echo '#############################################'
parallel --propagate-sigterm2 -k -j $nproc $level1_prog ::: {0..99} &
parallel_pid=$!
echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
wait $parallel_pid
ret=$?
if [[ $ret -ne 143 ]]; then
  echo "Error: expected exit status 143, but it is $ret"
fi
echo "### Checking that the TERM traps were executed"
lingering_pid_files=(*.pid)
if [[ ${#lingering_pid_files[@]} -gt 0 ]]; then
  echo "Error: some pid files remain, this means the traps did not execute properly"
  printf "%s\n" "${lingering_pid_files[@]}"
fi
rm -rf *.pid
for ((idx=0; idx<$nproc; idx++)); do
  [[ ! -e terminated-level1.$idx ]] && echo "Error: terminated-level1.$idx should exist but it does not"
  [[ ! -e terminated-level2.$idx ]] && echo "Error: terminated-level2.$idx should exist but it does not"
  [[ -e killed-level1.$idx ]] && echo "Error: killed-level1.$idx should not exist but it does"
  [[ -e killed-level2.$idx ]] && echo "Error: killed-level2.$idx should not exist but it does"
done
rm -rf terminated-* killed-*

## Question for Ole: How do I exit the test?
## Question for Ole: How do I integrate this test with the others?
exit 1

echo '#################################################'
echo '### Test SIGINT (do not kill spawned processes) #'
echo '#################################################'
parallel -k -j $nproc $level1_prog ::: {0..99} &
parallel_pid=$!
echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
echo "Sending kill -TERM in 5 seconds..."; sleep 5; kill -TERM $parallel_pid
wait $parallel_pid
echo "### Checking for lingering files, they should exist"
pids=()
for ((idx=0; idx<$nproc; idx++)); do
  [[ ! -e level1.$idx.pid ]] && echo "Error: level1.$idx.pid should exist but it does not"
  [[ ! -e level2.$idx.pid ]] && echo "Error: level2.$idx.pid should exist but it does not"
  [[ ! -e level3.$idx.pid ]] && echo "Error: level3.$idx.pid should exist but it does not"
  pids+=($(cat level1.$idx.pid))
  pids+=($(cat level2.$idx.pid))
  pids+=($(cat level3.$idx.pid))
done
wait ${pids[@]}
echo "### Checking for lingering files, there should be none."
lingering_files=(*.pid killed-* terminated-*)
if [[ ${#lingering_files} -gt 0 ]]; then
  echo "Error: some files have been left behind"
  printf "%s\n" "${lingering_files[@]}"
fi
rm -rf "${lingering_files[@]}"

echo '##########################################'
echo '### Test SIGINT (kill spawned processes) #'
echo '##########################################'
parallel --propagate-sigint -k -j $nproc $level1_prog ::: {0..99} &
parallel_pid=$!
echo "Sending kill -INT in 5 seconds..."; sleep 5; kill -INT $parallel_pid
wait $parallel_pid
echo "### Checking that the INT traps were executed"
lingering_pid_files=(*.pid)
if [[ ${#lingering_pid_files[@]} -gt 1 ]]; then
  echo "Error: some pid files remain, this means the traps did not execute properly"
  printf "%s\n" "${lingering_pid_files[@]}"
fi
rm -rf *.pid
for ((idx=0; idx<$nproc; idx++)); do
  [[ -e terminated-level1.$idx ]] && echo "Error: terminated-level1.$idx should not exist but it does"
  [[ -e terminated-level2.$idx ]] && echo "Error: terminated-level2.$idx should not exist but it does"
  [[ ! -e killed-level1.$idx ]] && echo "Error: killed-level1.$idx should exist but it does not"
  [[ ! -e killed-level2.$idx ]] && echo "Error: killed-level2.$idx should exist but it does not"
done
rm -rf terminated-* killed-*

echo '####################################################'
echo '### Test Control-C SIGINT (kill spawned processes) #'
echo '####################################################'
# Control-C is emulated by sending SIGINT to the process group
# and is expected to kill everything
parallel --propagate-sigint -k -j $nproc $level1_prog ::: {0..99} &
parallel_pid=$!
echo "Sending Control-C in 5 seconds..."; sleep 5; kill -INT -$parallel_pid
wait $parallel_pid
echo "### Checking that the INT traps were executed"
lingering_pid_files=(*.pid)
if [[ ${#lingering_pid_files[@]} -gt 0 ]]; then
  echo "Error: some pid files remain, this means the traps did not execute properly"
  printf "%s\n" "${lingering_pid_files[@]}"
fi
rm -rf *.pid
for ((idx=0; idx<$nproc; idx++)); do
  [[ -e terminated-level1.$idx ]] && echo "Error: terminated-level1.$idx should not exist but it does"
  [[ -e terminated-level2.$idx ]] && echo "Error: terminated-level2.$idx should not exist but it does"
  [[ ! -e killed-level1.$idx ]] && echo "Error: killed-level1.$idx should exist but it does not"
  [[ ! -e killed-level2.$idx ]] && echo "Error: killed-level2.$idx should exist but it does not"
done
rm -rf terminated-* killed-*

# ssh?

# Clean up
rm $level1_prog $level2_prog

#rm -rf /tmp/parallel$$
