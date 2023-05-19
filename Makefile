PWD := $(shell pwd)

download:
	wget -r -np --accept=zip  http://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/

build:
	docker build -t cnefe2csv . --rm

run:
	docker run -v $(PWD)/output:/app/output cnefe2csv