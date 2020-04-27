# Dicas e truques no docker
# https://medium.com/@renato.groffe/docker-guia-de-refer%C3%AAncia-gratuito-70c14cfd8132

# Primeiros passos de teste do doscker
docker version
docker run hello-world
# Caso de erro de inicialização de máquina é necessário acessar a virtualização da bios
# https://mashtips.com/enable-virtualization-windows-10/

# Modo Interativo
 
docker run hello-world bash --version

# quais containers ativos no momento e os não ativos
docker ps
docker ps -a

# executar um container no modo interativo
docker run -it hello-world bash
docker container run -it hello-world bash

# incluindo nome no container
docker run --name meuContainerHelloWord hello-world
docker container run --name meuContainerHelloWord hello-world

# Comando para listar os containers
docker container ls -a

# Comando para iniciar meu container criado
docker container start -ai meuContainerHelloWord

# Mapeando portas dos containers
# Ajustar o docker para que tenha a possibilidade de rodar os comandos a seguir no link a baixo
# https://stackoverflow.com/questions/48066994/docker-no-matching-manifest-for-windows-amd64-in-the-manifest-list-entries
docker pull nginx
docker container run --name container-nginx -p 8080:80 nginx

# Mapear diretórios para o container
cd 'C:\Users\Lenovo\Desktop\Lenin Git\Docker-Curso\exemplo-volume'
#analisar o porque do mau funcionamento e não mapeamento das pastas
docker run --name container-nginx -v /html:/usr/share/nginx/html -p 8080:80 nginx

# Rodar o container em background 
docker container run -d --name exercicio-demon-basic -p 8080:80 -v /html:/usr/share/nginx/html nginx

# Gerenciando containers existentes
docker container start exercicio-demon-basic
docker container ps 
docker container restart exercicio-demon-basic
docker container stop exercicio-demon-basic

# Manipulação de containers 
docker container ps 
docker ps
docker container ps -a
docker ps -a
docker container ls
docker container ls -a
docker container list 
docker container list -a
docker container start exercicio-demon-basic
docker container logs exercicio-demon-basic
docker container inspect exercicio-demon-basic #inspencionar as configurações do container
docker container exec exercicio-demon-basic uname -or #executar um comando no container
docker container stop exercicio-demon-basic

# Nova sintaxe do Docker Client
docker container ls
docker image ls
docker volume ls
docker image rm id container

# Detalhando Imagens
docker image pull redis:latest #baixar imagen na sua versão
docker image ls # para listar as imagens
docker image rm redis:latest exemplo-redis-lenin #Removendo uma imagem pelo nome
docker image inspect redis:latest #inspecionando imagen
docker image tag redis:latest exemplo-redis-lenin #Criando uma imagem com nome
docker image build # buildando a imagem
docker image push # publicar no hambiente da empresa ou no docker hub

# Criando Imagens
# Criar uma pasta com um arquivo Dockerfile exatamente com esse nome como na pasta primeiro-build
# Em seguida rodar os seguintes comandos
docker image build -t primeiro-build . #criando imagem
docker image ls #listando imagens disponíveis
docker container run -p 8080:80 primeiro-build #criando container apartir da imagen criada

# Criando uma imagen com argumentos
# Criar uma pasta com um arquivo Dockerfile exatamente com esse nome como na pasta build-com-argumentos
# Entrar na pasta e em seguida executar os seguintes comandos
docker image build -t build-com-argumento . #criando imagem
docker image ls #listando imagens disponíveis
docker container run build-com-argumento bash -c 'echo $S3_BUCKET' #criando o container vendo a variavel default de argumento
docker image build --build-arg S3_BUCKET=myapp -t  build-com-argumento . #Alterando o parametro da imagem default e atualizando a imagem

# Criando uma imagen com copia
# Criar uma pasta com um arquivo Dockerfile exatamente com esse nome como na pasta build-com-copia
# Entrar na pasta e em seguida executar os seguintes comandos
docker image build -t build-com-copia . #criando imagem
docker image ls #listando imagens disponíveis
docker container run -p 8080:80 build-com-copia

# Criando uma imagem de servidor com uma página
# Criar uma pasta com um arquivo Dockerfile exatamente com esse nome como na pasta build-dev
# Entrar na pasta e em seguida executar os seguintes comandos
docker image build -t build-dev .
docker run -it -v (Get-Location).path:/app -p 80:8000 --name pyton-serve build-dev


#Publicando uma imagen no docker hub
docker image tag primeiro-build lmuller439/imagem-teste-docker-hub:1.0 #Criando uma tag da imagem com o nome do repositorio/seunome:versão
docker login -u "lmuller439" -p "senha" docker.io # logando no docker hub
docker push lmuller439/imagem-teste-docker-hub:1.0 # fazendo o push

# Tipos de Resdes
docker network ls
docker network inspect bridge

# criação de containers que não envolve conexão com rede None Network
docker container run -d --net none debian
docker container run --rm --net none alpine ash -c "ifconfig"

# criação de containers do tipo bridge
docker container run -d --name container-bridge-1 alpine sleep 1000
docker container exec -it container-bridge-1 ifconfig
docker container run -d --name container-bridge-2 alpine sleep 1000
docker container exec -it container-bridge-2 ifconfig

docker container exec -it container-bridge-1 ping 172.17.0.3
docker container exec -it container-bridge-1 ping www.google.com

# criando container em redes
docker network create --driver bridge rede_nova_bridge #criando uma nova rede do tipo bridge
docker network ls
docker network inspect rede_nova_bridge
docker container run -d --name container-bridge-nova-rede-1 --net rede_nova_bridge alpine sleep 1000 #criando um container novo na nova rede criada
docker container exec -it container-bridge-nova-rede-1 ifconfig #verificando as configurações de redes do container criado
docker network connect bridge container-bridge-nova-rede-1 # configurando para que o container tenha acesso interno como externo das redes bridge
docker container exec -it container-bridge-nova-rede-1 ifconfig # verificando se a configuração de acesso a redes foi adicionado
docker container exec -it container-bridge-nova-rede-1 ping 172.17.0.2 
docker network disconnect bridge container-bridge-nova-rede-1 # desconectar a redes externas
docker container exec -it container-bridge-nova-rede-1 ifconfig # verificando se foi desconectado a redes externas

# Configurando multiplos containers
docker-compose up # sobe os containers configurados nos arquivo yml da pasta node-mongo-compose

# Exercicio Final e Conclusão
docker-compose up -d #executar a aplicação em modo dimond(background)
docker-compose ps #listar se existe processos rodando
docker-compose down #parar os processos rodando
docker-compose exec db psql -U postgres -c '\l' #listar a estrutura existente nesse container de banco de dados
docker-compose exec db psql -U postgres -f /scripts/check.sql #executar script de check para ver a tabela e seus dados
docker-compose logs -f -t #detalhamento dos containers executando e seus status
docker-compose up -d --scale worker=3 #executar a aplicação em modo dimond(background) escalando o worker em 3 instancias de containers para tratar os envios de e-mail
docker-compose logs -f -t worker #detalhando os logs de works
docker-compose exec db psql -U postgres -d email_sender -c 'select * from emails' #Consulta os dados no container de banco de dados na tabela de email_sender