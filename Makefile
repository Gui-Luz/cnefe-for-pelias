PWD := $(shell pwd)

download:
	wget -r -np --accept=zip  http://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/

mun:
	wget https://raw.githubusercontent.com/mapaslivres/municipios-br/main/tabelas/municipios.csv

build:
	docker build -t cnefe4pelias . --rm

run:
	docker rm cnefe4pelias & docker run --name cnefe4pelias -v $(PWD)/output:/app/output cnefe4pelias
