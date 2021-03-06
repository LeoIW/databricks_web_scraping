FROM databricksruntime/standard:latest



# 1. Install Chrome (root image is debian)
# See https://stackoverflow.com/questions/49132615/installing-chrome-in-docker-file
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# 2. Install Chrome driver used by Selenium

RUN   LATEST=$(wget -q -O - http://chromedriver.storage.googleapis.com/LATEST_RELEASE) &&  \
      wget https://chromedriver.storage.googleapis.com/$LATEST/chromedriver_linux64.zip -O /tmp/chromedriver_linux64.zip && \
  (rm /tmp/chromedriver/* || mkdir /tmp/chromedriver) && \
   unzip /tmp/chromedriver_linux64.zip -d /tmp/chromedriver/   && \
   sudo add-apt-repository ppa:canonical-chromium-builds/stage   && \
   /usr/bin/yes | sudo apt update   &&  \
   /usr/bin/yes | sudo apt install chromium-browser 
  

ENV PATH="/usr/local/bin/chromedriver:${PATH}"

# 3. Install selenium and scrapy in Python
RUN pip install -U selenium

