SITE=$1
PAGE=$2

grep $PAGE $(pwd)/nginx/$SITE_access.log > $(pwd)/$SITE.FILTER_PAGE.log

docker volume create --name awstats-db-filter
docker run --rm -v /tmp:/web-logs:ro -e LOG_FORMAT="%host %other %other %time1 %methodurl %code %bytesd %refererquot %uaquot" -e SITE_DOMAIN=$SITE -v awstats-db-filter:/etc/awstats -v awstats-db-filter:/var/lib/awstats openmicroscopy/awstats /web-logs/$SITE.FILTER_PAGE.log

docker run -d -p 8081:8080 -v awstats-db-filter:/etc/awstats -v awstats-db-filter:/var/lib/awstats openmicroscopy/awstats httpd
