PATH=/tmp/nginx
docker volume create --name awstats-db
for FILE in $PATH/*
do
  filename=$(basename -- "$FILE")
  SITE="${filename%%.*}"
  docker run --rm -v $PATH:/web-logs:ro -e LOG_FORMAT="%host %other %other %time1 %methodurl %code %bytesd %refererquot %uaquot" -e SITE_DOMAIN=$SITE -v awstats-db:/etc/awstats -v awstats-db:/var/lib/awstats openmicroscopy/awstats /web-logs/$SITE_access.log
done

docker run -d -p 8080:8080 -v awstats-db:/etc/awstats -v awstats-db:/var/lib/awstats openmicroscopy/awstats httpd
