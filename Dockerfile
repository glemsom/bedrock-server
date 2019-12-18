FROM ubuntu:18.04

# Set Minecraft bedrock versuin
ENV VERSION=1.14.1.4

# Install dependencies, download and extract the bedrock server
RUN apt-get update && \
    apt-get install -y unzip curl libcurl4 libssl1.0.0 && \
    rm -rf /var/lib/apt/lists/* && \
    curl https://minecraft.azureedge.net/bin-linux/bedrock-server-${VERSION}.zip --output bedrock-server.zip && \
    unzip bedrock-server.zip -d bedrock-server && \
    rm bedrock-server.zip

VOLUME /bedrock-server/data

# Delete default config (supplied from volume)
run rm -f /bedrock-server/server.properties /bedrock-server/permissions.json /bedrock-server/whitelist.json

# Setup symlinks from volume
RUN ln -s /bedrock-server/data/worlds             /bedrock-server/worlds            && \
    ln -s /bedrock-server/data/server.properties  /bedrock-server/server.properties && \
    ln -s /bedrock-server/data/permissions.json   /bedrock-server/permissions.json  && \
    ln -s /bedrock-server/data/whitelist.json     /bedrock-server/whitelist.json

ADD run.sh /bedrock-server/run.sh

EXPOSE 19132/udp
EXPOSE 19133/udp

WORKDIR /bedrock-server
ENV LD_LIBRARY_PATH=.
CMD ./run.sh
