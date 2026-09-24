let
    // Fonte oficial: API de Localidades do IBGE. Acesso anônimo.
    Fonte = Json.Document(Web.Contents("https://servicodados.ibge.gov.br", [
        RelativePath = "api/v1/localidades/municipios",
        Query = [orderBy = "nome"],
        Timeout = #duration(0, 0, 2, 0)
    ])),
    ListaValidada = if Value.Is(Fonte, type list) and not List.IsEmpty(Fonte)
        then Fonte else error "A API do IBGE não retornou uma lista de municípios válida.",
    Registros = List.Transform(ListaValidada, (Municipio as record) =>
        let
            // A estrutura antiga pode ser nula em municípios mais recentes.
            UFAtual = try Municipio[#"regiao-imediata"][#"regiao-intermediaria"][UF] otherwise null,
            UFRegistro = if Value.Is(UFAtual, type record) then UFAtual
                else Municipio[microrregiao][mesorregiao][UF]
        in [
            COD_IBGE = Text.From(Municipio[id], "en-US"),
            MUNICIPIO = Municipio[nome],
            COD_UF = Text.From(UFRegistro[id], "en-US"),
            UF = UFRegistro[sigla],
            ESTADO = UFRegistro[nome],
            REGIAO = UFRegistro[regiao][nome],
            MUNICIPIO_UF = Municipio[nome] & " - " & UFRegistro[sigla]
        ]),
    Tabela = Table.FromRecords(Registros, type table [
        COD_IBGE = text, MUNICIPIO = text, COD_UF = text, UF = text,
        ESTADO = text, REGIAO = text, MUNICIPIO_UF = text
    ]),
    ChaveValidada = if Table.RowCount(Tabela) = List.Count(List.Distinct(Tabela[COD_IBGE]))
        then Tabela else error "O IBGE retornou códigos de município duplicados.",
    Ordenado = Table.Sort(ChaveValidada, {{"UF", Order.Ascending}, {"MUNICIPIO", Order.Ascending}})
in
    Ordenado
