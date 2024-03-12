#!/bin/bash

sudo docker pull nginx

sudo docker run -d -p 80:80 --name my-nginx Test