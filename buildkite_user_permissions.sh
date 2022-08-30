#! /usr/bin/bash
mkdir temp
htmlq -f /tmp/buildkite_users.html -a href a | grep -a users > /tmp/buildkite_user_urls1.list
sed 's/\/organizations/\n\/organizations/g' /tmp/buildkite_user_urls1.list > /tmp/buildkite_user_urls2.list
sed -n '/users\/[a-zA-Z0-9]/p' /tmp/buildkite_user_urls2.list > /tmp/buildkite_user_urls3.list
 sed 's/\/home.*//' /tmp/buildkite_user_urls3.list > /tmp/buildkite_user_urls.list