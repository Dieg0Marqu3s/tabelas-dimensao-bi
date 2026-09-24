let
    // Altere estes dois parâmetros para adequar o intervalo ao seu calendário.
    AnoInicial = 2025,
    AnoFinal = Date.Year(Date.From(DateTime.FixedLocalNow())) + 1,
    Anos = if AnoInicial >= 1900 and AnoFinal <= 2199
        and AnoInicial <= AnoFinal
        and Number.RoundDown(AnoInicial) = AnoInicial
        and Number.RoundDown(AnoFinal) = AnoFinal
        then {AnoInicial..AnoFinal}
        else error "Informe anos inteiros entre 1900 e 2199, com AnoInicial <= AnoFinal.",

    ObterAno = (Ano as number) as table =>
        let
            Fonte = Json.Document(Web.Contents("https://brasilapi.com.br", [
                RelativePath = "api/feriados/v1/" & Text.From(Ano, "en-US"),
                Timeout = #duration(0, 0, 2, 0)
            ])),
            ListaValidada = if Value.Is(Fonte, type list) and not List.IsEmpty(Fonte)
                then Fonte else error "A BrasilAPI não retornou feriados para " & Text.From(Ano),
            Registros = List.Transform(ListaValidada, each [
                DATA = Date.FromText([date], [Format = "yyyy-MM-dd", Culture = "en-US"]),
                FERIADO = [name],
                TIPO_FONTE = [type]
            ]),
            Tabela = Table.FromRecords(Registros,
                type table [DATA = date, FERIADO = text, TIPO_FONTE = text]),
            AnoValidado = if List.AllTrue(List.Transform(Tabela[DATA], each Date.Year(_) = Ano))
                then Tabela else error "A API retornou datas fora do ano solicitado."
        in
            AnoValidado,

    Combinado = Table.Combine(List.Transform(Anos, each ObterAno(_))),
    ComAno = Table.AddColumn(Combinado, "ANO", each Date.Year([DATA]), Int64.Type),
    ComFonte = Table.AddColumn(ComAno, "FONTE", each "BrasilAPI", type text),
    // Não confundir a classificação da API com aplicabilidade universal.
    ComRevisao = Table.AddColumn(ComFonte, "REVISAR_APLICABILIDADE", each
        List.Contains({"Carnaval", "Corpus Christi", "Sexta-feira Santa", "Páscoa"}, [FERIADO]),
        type logical),
    Ordenado = Table.Sort(ComRevisao, {{"DATA", Order.Ascending}, {"FERIADO", Order.Ascending}})
in
    Ordenado
