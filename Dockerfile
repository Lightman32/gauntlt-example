FROM abbasg/base-gauntlt-docker:latest

ARG environment_address

WORKDIR /gauntlt

ADD . . 

ENV TEST_HOSTNAME $environment_address
ENV TEST_URL=https://$TEST_HOSTNAME/

# Hackish solution until we find a way to pull in env variables in gauntlt by default
RUN sed -i 's@TEST_URL@'"$TEST_URL"'@' attackfiles/*.attack && \
mkdir reports || true

CMD gauntlt -f json > /gauntlt/reports/cucumber.json
