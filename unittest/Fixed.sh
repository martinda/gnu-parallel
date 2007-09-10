#!/bin/bash

ls tests-to-run/test*.sh | perl -pe 's:(.*/(.*)).sh:cp actual-results/$2 wanted-results/$2:' | sh -x
