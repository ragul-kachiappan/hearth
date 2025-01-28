# hearth

Build a local chat room with Llama based bot feature accessible via Wifi.

Tech Stack
- Starlette for minimal web server
- Postgres (could be NoSQL)
- std html, css, js for frontend. With htmx and lightweight frameworks like alpine
- Containerized with Docker
- Deployed with k8s along with ArgoCD. (microk8s or something similar)

Specialities about the project.

I'm building it mainly to test my newly acquired skills and deep dive into it.

- End to End project with main focus on backend concepts.
- Fully async server including the DB client.
- try out uv for package management.
- websocket support.
- Redis for caching.
- Background workers.
- Starlette, Redis, ChromaDB, Postgres, Nginx container setup.
- Logging to sentry.
- Possibly Oauth with gmail. Not mandatory.
- Proper test suite.
- Proper markdown docs.
- Deployment to GKE with GCP free credits
- cicd for linting checks (ruff, yaml, toml, js, html, css).
- prometheus, elk stack for monitoring and logging.
```
Environment Variables:

Could move them to a .env file
Should use more secure password management in production


Logging:

Could add log rotation
Might want to consider adding a logging service like ELK stack


Monitoring:

Could add Prometheus/Grafana for metrics
Health check endpoints could be more comprehensive


Scaling:

Could add replicas for the web service
Might want to consider using Docker Swarm or Kubernetes for larger deployments
```