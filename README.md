# Life Dashboard

## Running locally

`smashing start`

## Crontab

Install crontab lines:

`0 2 * * * bin/fetch_insight_timer.sh <email> <password> > /path/to/life-dashboard/data/insight_sessions_export.csv`
`0 2 * * * bin/fetch_map_my_run.sh <email> <password> > /path/to/life-dashboard/data/map_my_run.csv`

Run this at least once.


## TODO
