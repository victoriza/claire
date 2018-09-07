# Claire Redfield

This project aim is to provide with an **easy** way to check **vulnerabilities** in your Docker containers (private or public Docker registry) that can also be easily integrated as part of your CI/CD

**NOTE:** This is a personal and *WIP* repo.
 
## How do I check vulnerabilities ? 

From the command line we can run vulnerability checks on containers, 
in this example we search for *vulnerabilities* on the Docker image 
Postgres 9.5.1 that runs on Debian8
    
run: `check.sh postgres:9.5.1`

output:
    
    Got results from Clair API v3  
    Found 248 vulnerabilities  
    Unknown: 7  
    Negligible: 43  
    Low: 23  
    Medium: 121  
    High: 54  

    CVE-2017-2519: [High]  
    Found in: sqlite3 [3.8.7.1-1+deb8u1]  
    Fixed By:  
    An issue was discovered in certain Apple products. iOS before 10.3.2 is affected. macOS before 10.12.5 is affected. tvOS before 10.2.1 is affected. watchOS before 3.2.2 is affected. The issue involves the "SQLite" component. It allows remote attackers to execute arbitrary code or cause a denial of service (memory corruption and application crash) via a crafted SQL statement.
    https://security-tracker.debian.org/tracker/CVE-2017-2519
    -----------------------------------------
    CVE-2017-10989: [High]
    Found in: sqlite3 [3.8.7.1-1+deb8u1]
    Fixed By:
    The getNodeSize function in ext/rtree/rtree.c in SQLite through 3.19.3, as used in GDAL and other products, mishandles undersized RTree blobs in a crafted database, leading to a heap-based buffer over-read or possibly unspecified other impact.
    https://security-tracker.debian.org/tracker/CVE-2017-10989
    -----------------------------------------
    ...
    ...

This project use three containers:
+ Clair 
    + In regular intervals, Clair ingests vulnerability metadata from a configured set of sources and stores it in the database.
    + Clients use the Clair API to index their container images; this creates a list of _features_ present in the image and stores them in the database.
    + Klar uses the Clair API to query the database for vulnerabilities of a particular image; correlating vulnerabilities and features is done for each request, avoiding the need to rescan images. 
+ Postgres
    + Clair DB 
+ Klar
    + Allows us to easily interact with Clair API (v3)

## How to use Claire

0) Clone the repo `git@github.com:victoriza/claire.git` , `cd claire`
1) Run `docker-compose -f ./docker-compose.yml up -d` (it may take up to 10 minutes to populate the DB)
2) Copy `dev.env.templ` to `dev.env` (and update it to match the needs of your env):
3) Test it, run `./check.sh postgres:9.5.2`

## AWS Setup (Quick example)

Since Clair needs to populate the DB it's probably worth it to do not rebuild the env all the time, 
in my case I decided to have Clair in AWS and run the scripts from Jenkins

#### AWS Clair
1) Spin Claire in an **EC2 instance**
2) Add a Security Group with **TCP** ports **[6060-6161]** open
3) Create a new Type A record Route53 to that machine IP

#### On your CI/CD
1) Clone the repo
2) `docker build -t klar .`
3) Update `dev.env` to point to the precious mentioned `record`
4) Now your CI/CD (Like Jenkins) can run `./check.sh [TAG]:[VERSION]` on every build

## FAQ

### Docker Registry fails

Double check the credentials on your dev.env file.  
In case you dockerize it, make sure to run
`docker login`

### Clair cannot be found
You may need to adjust the `CLAIR_ADDR=localhost`from `dev.env`  
In my case I have Clair running in a separate host.

### Terminology

#### Container

- *Container* - the execution of an image
- *Image* - a set of tarballs that contain the filesystem contents and run-time metadata of a container
- *Layer* - one of the tarballs used in the composition of an image, often expressed as a filesystem delta from another layer

#### Specific to Clair

- *Ancestry* - the Clair-internal representation of an Image
- *Feature* - anything that when present in a filesystem could be an indication of a *vulnerability* (e.g. the presence of a file or an installed software package)
- *Feature Namespace* (featurens) - a context around *features* and *vulnerabilities* (e.g. an operating system or a programming language)
- *Vulnerability Source* (vulnsrc) - the component of Clair that tracks upstream vulnerability data and imports them into Clair's database
- *Vulnerability Metadata Source* (vulnmdsrc) - the component of Clair that tracks upstream vulnerability metadata and associates them with vulnerabilities in Clair's database

https://github.com/coreos/clair/blob/master/Documentation/terminology.md
 
### Heavily based on:

### Clair

Clair is an open source project for the static analysis of vulnerabilities in application containers (currently including appc and docker).
https://github.com/coreos/clair

### Klar

A simple tool to analyze images stored in a private or public Docker registry for security vulnerabilities using Clair.
https://github.com/optiopay/klar