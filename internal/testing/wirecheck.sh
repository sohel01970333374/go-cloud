#!/usr/bin/env bash
# Copyright 2018 The Go Cloud Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Runs only tests relevant to the current pull request.
# At the moment, this only gates running the Wire test suite.
# See https://github.com/google/go-cloud/issues/28 for solving the
# general case.

set -o pipefail

if [[ $# -gt 0 ]]; then
  echo "usage: wirecheck.sh" 1>&2
  exit 64
fi

module="github.com/google/go-cloud"
go mod vendor || exit 1
mapfile -t all_pkgs < <( go list "$module/..." ) || exit 1
# TODO(light): Find out why the GO111MODULE=off override is necessary
# and then remove it.
GO111MODULE=off wire check "${all_pkgs[@]}" || exit 1
