#!/bin/bash

# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

GHC_KYTHE=ghc_kythe_wrapper
VERIFIER=/opt/kythe/tools/verifier

BASIC="testdata/basic"

RESULT=0

die() {
  RESULT=-1
  echo "*********************************"
  echo "* THERE WAS AN ERROR, SEE ABOVE *"
  echo "*********************************"
}

for fut in \
    "$BASIC/Anchors.hs" \
    "$BASIC/CrossRef1.hs $BASIC/CrossRef2.hs" \
    "$BASIC/DataRef.hs" \
    "$BASIC/FunctionArgRef.hs" \
    "$BASIC/LocalRef.hs" \
    "$BASIC/RecordReadRef.hs" \
    "$BASIC/RecordWriteRef.hs" \
    "$BASIC/RecursiveRef.hs" \
    "$BASIC/TypeclassRef.hs" \
    "$BASIC/TypeDef.hs"

do
  echo "Verifying: $fut"
  $GHC_KYTHE -- $fut 2> /dev/null | $VERIFIER -goal_prefix '-- -' $fut \
    || die
done

exit $RESULT
