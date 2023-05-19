PWD := $(shell pwd)

download:
	wget -r -np --accept=zip  http://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/

mun:
	wget https://raw.githubusercontent.com/mapaslivres/municipios-br/main/tabelas/municipios.csv

build:
	docker build -t cnefe2csv . --rm

run:
	docker rm cnefe2csv & docker run --name cnefe2csv -v $(PWD)/output:/app/output cnefe2csv
