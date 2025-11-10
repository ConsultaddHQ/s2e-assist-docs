# Installation

Welcome to the **S2E Assist Tool** installation guide. Follow these steps to get your local environment up and running quickly.

---

## Prerequisites

Before setting up the S2E Assist Tool, make sure you have:

* **VM or Local Machine**: A virtual machine or a local environment that meets your system requirements.
* **Container Runtime**: Docker installed and running on the system.
* **Network Access**: Outbound internet access to pull images from Docker Hub.

---

## Setting Up Environment Variables

The S2E Assist tool needs some environment variables to connect to your Elasticsearch cluster and LLM provider.
Create a `.env` file in the same directory where you’ll run the script:

### **1. Required for all setups**

```bash
ES_API_KEY=<your-elasticsearch-api-key>
ES_API_URL=<your-elasticsearch-api-url>
MODEL_PROVIDER=<groq | openai | bedrock>
```

### **2. Additional variables based on MODEL_PROVIDER**

| MODEL_PROVIDER | Required Environment Variables                             |
| -------------- | ---------------------------------------------------------- |
| `groq`         | `GROQ_API_KEY`                                             |
| `openai`       | `OPENAI_API_KEY`                                           |
| `bedrock`      | `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` |

Example `.env` file:

```bash
ES_API_KEY=abc123
ES_API_URL=https://your-es-instance.cloud.es.io
MODEL_PROVIDER=groq
GROQ_API_KEY=your_groq_api_key
```

> 📝 **Tip:** The script automatically loads `.env` if present and validates required variables before starting.

---

## Running the S2E Assist Tool

Use the official **start script** to launch the tool.
The script will automatically:

* Load environment variables from your `.env` file
* Validate required variables
* Spin up all necessary containers using Docker Compose

### Using Curl

```bash
curl -fsSL https://raw.githubusercontent.com/ConsultaddHQ/s2e-assist-docs/main/start.sh | sh -s -- v0.0.1
```

> 💡 You can replace `v0.0.1` with another version tag or omit it to use `latest`.

After the containers start successfully, you can access the tool at:

➡️ **[http://localhost:8081](http://localhost:8081)**

---

## Troubleshooting

If you see errors such as
`❌ Missing required environment variable: ES_API_KEY`,
make sure your `.env` file is correctly filled and in the same directory where you’re running the script.

To inspect logs or running containers:

```bash
docker ps
docker logs s2e-backend
```

To stop all containers:

```bash
docker-compose down
```

---

## Next Steps

* **Create Your First User:**
  After the tool starts, open it in your browser and create the first user to securely access the system.

* **Explore Features:**
  Use the web UI to begin analyzing your Splunk-to-Elasticsearch migration, plan capacity, and manage alerts.

