# Biblioteca de tabelas BI

Consultas reutilizáveis em linguagem M (Power Query) para projetos de Power BI.

## Consultas disponíveis

| Consulta | Arquivo | Finalidade |
| --- | --- | --- |
| Tabela Calendario | [Calendario.pq](Calendario/Calendario.pq) | Gerar uma linha por dia, com atributos de calendário. |
| Tabela de Estado | [Estados.pq](Geografia/Estados.pq) | Carregar os dados geográficos incorporados à consulta. |

## Como usar

1. No Power BI Desktop, abra **Transformar dados**.
2. Crie uma **Consulta em branco** e abra o **Editor Avançado**.
3. Substitua todo o conteúdo pelo código do arquivo `.pq` desejado, de `let` até a última etapa após `in`.
4. Nomeie a consulta como **Tabela Calendario** ou **Tabela de Estado**.
5. Confira os tipos e valores na prévia e selecione **Fechar e Aplicar**.

Os arquivos contêm apenas a expressão M. Os rótulos `Tabela Calendario =` e `Tabela de Estado =` do conteúdo fornecido foram separados do código para permitir colá-lo no Editor Avançado. A lógica e os dados incorporados foram preservados.

## Calendário

- Início: `DataMin = #date(2025, 1, 1)`; altere esse valor para reutilizar a consulta em outro intervalo.
- Fim: último dia do mês seguinte à data obtida por `DateTime.LocalNow()` na execução da consulta.
- Intervalo inclusivo: inclui a data inicial e a final.
- Colunas: `DATA`, `Dia`, `DIA SEMANA ABREV`, `DIA SEMANA NOME`, `MÊS NUM`, `MÊS NOME`, `MÊS NOME ABREV`, `ANO`, `Dia_Nome`, `Semana do Ano`, `MES_ANO`, `Prefixo`, `Trimestre`, `InicioMes`.
- Nomes de dias e meses não têm cultura explícita nas chamadas originais de formatação. Confira o resultado no ambiente de destino.
- `Date.WeekOfYear` foi preservado sem argumento de primeiro dia da semana; o código não define uma regra ISO explicitamente.
- O limite final é recalculado na execução da consulta; não é um valor fixo gravado no repositório.

## Estados

- Colunas: `ESTADO`, `UF`, `CAPITAL`, `LATITUDE`, `LONGITUDE`, `PAIS`, `ESTADO_UF`.
- A origem é um JSON incorporado, codificado em Base64 e comprimido com Deflate. Não depende de arquivo externo.
- `LATITUDE` e `LONGITUDE` são convertidas em número e arredondadas para seis casas decimais.
- A conversão numérica foi preservada sem cultura explícita. Confira os separadores decimais no ambiente de destino.
- Os dados são os fornecidos pelo autor; sua fonte geográfica original não foi informada.

## Reutilização e manutenção

Copiar uma consulta cria uma versão independente no projeto de destino. Alterações neste repositório não atualizam automaticamente os códigos já copiados para outros projetos.

Esta versão inicial não foi executada em um mecanismo Power Query nesta sessão. Valide a atualização das consultas no Power BI antes de usá-las nos seus modelos.
