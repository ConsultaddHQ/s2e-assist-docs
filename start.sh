#!/bin/bash
set -eu

# --- Load .env file if present ---
if [[ -f .env ]]; then
  echo "📦 Loading environment variables from .env..."
  # shellcheck disable=SC2046
  export $(grep -v '^#' .env | xargs)
else
  echo "⚠️  No .env file found. Make sure all required environment variables are exported."
fi

# Get the docker tag from the first argument, default to 'latest'
DOCKER_TAG="${1:-latest}"

# Define the docker-compose.yml content
cat <<EOF > docker-compose.yml
services:
  s2e-frontend:
    container_name: s2e-frontend
    image: hyperflex/s2e-frontend:$DOCKER_TAG
    restart: unless-stopped
    ports:
      - '8081:80'
    depends_on:
      - s2e-backend

  s2e-backend:
    container_name: s2e-backend
    image: hyperflex/s2e-backend:$DOCKER_TAG
    restart: unless-stopped
    ports:
      - '4040:4040'
    environment:
      - ALERTS_MIGRATION_URL=http://alerts-migration:4041
      - CAPACITY_PLANNER_URL=http://capacity-planning:4042
      - S2E_POSTGRES_DB_HOST=s2e-postgres
      - S2E_DB_USERNAME=admin
      - S2E_DB_PASSWORD=admin123
      - ES_API_KEY
      - ES_API_URL
      - MODEL_PROVIDER
      - GROQ_API_KEY
      - OPENAI_API_KEY
      - AWS_REGION
      - AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY
    depends_on:
      s2e-postgres:
        condition: service_healthy
  capacity-planning:
    container_name: capacity-planning
    image: hyperflex/capacity-planning:$DOCKER_TAG
    restart: unless-stopped
    environment:
      - CONTROL_PLANE_URL=http://s2e-backend:4040
    depends_on:
      - s2e-backend
  s2e-postgres:
    container_name: s2e-postgres
    image: postgres:17
    environment:
      - POSTGRES_USER=admin
      - POSTGRES_PASSWORD=admin123
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin"]
      interval: 10s
      retries: 5
volumes:
  postgres_data:
EOF


# Start the services
echo "Starting the containers with tag: $DOCKER_TAG..."
docker-compose up -d

# Wait for a few seconds to allow containers to start
sleep 5

# Check if both containers are running
CONTROL_PLANE=$(docker inspect -f '{{.State.Running}}' s2e-backend 2>/dev/null)
FRONTEND_STATUS=$(docker inspect -f '{{.State.Running}}' s2e-frontend 2>/dev/null)

if [[ "$CONTROL_PLANE" == "true" && "$FRONTEND_STATUS" == "true" ]]; then
    echo "Deployment complete!"
    echo "S2E is running on: http://localhost:8081"
else
    echo "Error: One or more containers failed to start."
    docker ps -a  # Show container statuses for debugging
    exit 1
fi
