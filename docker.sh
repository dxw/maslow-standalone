#!/usr/bin/env bash
rm -rf tmp
bin/rails server -e development --port 3000 --binding 0.0.0.0
