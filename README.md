# Claire Redfield

A project to check vulnerabilities in your Docker containers (private or public Docker registry) and integrate it as part of your CI/CD.

###How to use it (locally)

1) Start Clair + Postgres `docker-compose -f ./docker-compose.yml up -d`
2) Copy `dev.env.templ` to `dev.env` (and update it to match the needs of your env)
3) Test (check Postgres 9.5.2 on Debian 8 vulnerabilities) `docker run --env-file=dev.env klar postgres:9.5.2`

###How to use it CI/CD AWS Setup (Hello World)
1) Spin Clair in an EC2 instance (See step 1)
2) Add a Security Group with TCP ports [6060-6161] open
3) Create a record Route53 to that machine IP
4) Update `dev.env` to point to that IP
5) Now your CI/CD (Like Jenkins) can run `docker run --env-file=dev.env klar [TAG]:[VERSION]` on every build

##FAQ
#####Docker Registry fails
Double check the credentials on your dev.env file.
In case you are dockerising it, make sure to run
`docker login`

#####Clair cannot be found
You may need to adjust the `CLAIR_ADDR=localhost`from `dev.env`
In my case I have Clair running in a separate host.
 
###Based on:

###Clair
Clair is an open source project for the static analysis of vulnerabilities in application containers (currently including appc and docker).
https://github.com/coreos/clair

###Klar
A simple tool to analyze images stored in a private or public Docker registry for security vulnerabilities using Clair.
https://github.com/optiopay/klar