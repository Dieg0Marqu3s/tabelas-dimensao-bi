# Biblioteca de tabelas BI

Consultas reutilizáveis em Power Query (linguagem M) para projetos de Power BI.

## Tabelas

| Tabela | Arquivo | Fonte/uso |
| --- | --- | --- |
| Calendário | `Calendario/Calendario.pq` | Datas e atributos de calendário; início em 01/01/2025 e fim dinâmico. |
| Estados | `Geografia/Estados.pq` | Estados, UF, capitais e coordenadas; dados incorporados no código. |
| Municípios | `Geografia/Municipios.pq` | Municípios, códigos IBGE, UF, estado e região; consulta a API do IBGE. |
| Feriados | `Calendario/Feriados.pq` | Feriados por ano, de 2025 até o ano seguinte; consulta a BrasilAPI. |
| Períodos | `Periodos/Periodo.pq` | Classificação das 24 horas em período e turno. |

## Como usar

1. No Power BI, abra **Transformar dados > Consulta em branco > Editor Avançado**.
2. Cole o conteúdo de um arquivo `.pq`, do `let` ao `in`.
3. Confira os tipos e atualize a consulta.

Municípios e Feriados usam acesso anônimo à internet e precisam de atualização das credenciais no Power BI Service. Feriados não incluem automaticamente todas as regras estaduais e municipais; revise a aplicabilidade antes de usá-los como dias não úteis.

## Parâmetros principais

- Calendário: altere `DataMin` para mudar o início.
- Feriados: altere `AnoInicial` e `AnoFinal` no começo do arquivo.
- Períodos: a classificação segue `0–5` Madrugada, `6–11` Manhã, `12–17` Tarde e `18–23` Noite.
