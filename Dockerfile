FROM devkitpro/devkitarm

WORKDIR /tmp

RUN mkdir --parents ~/.config/lovebrew

RUN wget https://github.com/lovebrew/lovepotion/releases/download/2.4.0/Nintendo.3DS-1f46c97.zip -O 3ds.zip && ls

RUN unzip 3ds.zip &&\
    ls &&\
    mv LOVEPotion.elf ~/.config/lovebrew/3DS.elf

RUN wget https://github.com/lovebrew/lovebrew/releases/download/0.5.5/Linux-1e73122.zip -O linux.zip

RUN unzip linux.zip &&\
    chmod +x lovebrew &&\
    mv lovebrew /usr/bin

WORKDIR /opt/project

COPY . /opt/project/

RUN lovebrew --version

CMD [ "lovebrew", "build" ]