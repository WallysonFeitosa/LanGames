# LanGames 🕹️
Projeto destinado ao banco de dados para gestão de uma Lan House, visando facilitar a gestão de operações, clientes, equipamentos, aluguéis de máquinas e demais funcionalidades essenciais para uma lan house moderna.

Responsaveis<br>
* Wallyson Feitosa<br>
* Gabriel Albuquerque<br>
-------
Funcionalidades<br>
* Gerenciamento de clientes<br>
* Venda de produtos<br>
* Controle de máquinas/estações<br>
* Relatórios e estatísticas<br>
* Sistema de reservas e aluguéis<br>
* Controle de acesso<br>
-------
Ferramentas de criação<br>
* BrModelo<br>
* MySQL<br>
* VS Code<br>
-------
Estrutura (DER)<br>
* upload commit!<br>
<img width="571" height="381" alt="image" src="https://github.com/user-attachments/assets/06798111-53e9-4565-8649-de97e2230738" /><br>
-------
Estrutura (MER)<br>
* upload coommit!<br>
<img width="964" height="652" alt="image" src="https://github.com/user-attachments/assets/bdb722fe-4a6b-4f98-b0a3-a3ee9ef8f7b3" /><br><br>

## Ordem de execução

```bash
# 1. Criar o banco (schema + dados)
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed.sql

# 2. Criar procedures, triggers e views
mysql -u root -p < database/procedures.sql

# 3. Subir o backend
cd backend
cp .env.example .env          # edite se necessário
npm install
npm run dev

# 4. Abrir no navegador
# http://localhost:3000
```

---

## Rodar com Docker (recomendado)

Este projeto pode ser executado com Docker para evitar problemas de configuração local e garantir que o backend e o banco MySQL funcionem juntos.

### Por que usar Docker?

- Isola o ambiente da aplicação, evitando dependências locais quebradas.
- Não precisa instalar Node.js ou MySQL diretamente no Windows.
- Garante que todos usem a mesma versão do Node e do MySQL.
- Facilita subir e parar o sistema com poucos comandos.

### Passo a passo para usar Docker

1. Instale o Docker Desktop no Windows.
   - Link: https://www.docker.com/get-started
   - Ative o WSL 2 se o instalador pedir.

2. Abra o PowerShell ou terminal na pasta do projeto:

```powershell
cd g:..\pbd-alunos
```

3. Suba os containers:

```powershell
docker compose up --build
```

4. Aguarde a construção e o start dos serviços.
   - O container `db` inicia o MySQL.
   - O container `app` constrói e executa o backend Node.

5. Acesse o sistema no navegador:

```text
http://localhost:3000
```

6. Quando terminar, pare os containers:

```powershell
docker compose down
```

