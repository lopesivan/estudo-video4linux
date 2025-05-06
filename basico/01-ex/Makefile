# Define o arquivo Makefile principal a ser incluído
MAKEFILE := vide4linux.mak

# Obtém o diretório raiz do repositório Git
GIT_ROOT := $(shell git rev-parse --show-toplevel)

# Define o comando base para execução
MAKE_CMD = $(MAKE) -f $(MAKEFILE)

# Declara os targets que não correspondem a arquivos
.PHONY: all clean

# Target principal que será executado por padrão
all:
	$(MAKE_CMD)

# Target para rodar programa
run:
	$(MAKE_CMD) $@

# json para lsp
compile_commands.json:
	$(MAKE_CMD) bear

# testa memória do programa
free:
	$(MAKE_CMD) $@

# lista devices
devices:
	$(MAKE_CMD) ls$@

# Target para limpeza dos arquivos gerados
clean:
	$(MAKE_CMD) clean
	test -e compile_commands.json && rm compile_commands.json
