set -e

until PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -c '\l'; do
  >&2 echo "Waiting for Postgres"
  sleep 1
done

ruby framework/tools/starter/start.rb
