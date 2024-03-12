#!/bin/bash

crontab -e
*/2 * * * * /bin/bash -c 'date | tee /tmp/date_log' > /dev/null 2>&1
cat /tmp/date_log
