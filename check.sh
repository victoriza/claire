
#!/bin/sh
echo "## Checking Docker image $1 this can take a while##"
docker run --env-file=dev.env klar $1