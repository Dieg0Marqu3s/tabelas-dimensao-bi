let
    // Definindo DataMin e DataMax
    // DataMin = 2025 por padrão

    DataMin = #date(2025, 1, 1),
    DataMax = Date.AddDays(Date.From(DateTime.LocalNow()), -1),
 
    // Cálculo da duração
    Duracao = Duration.Days(DataMax - DataMin) + 1,
 
    // Criação da lista de datas
    Fonte = List.Dates(DataMin, Duracao, #duration(1,0,0,0)),
    ConverteTabela = Table.FromList(Fonte, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
 
    // Renomeando e formatando a coluna para Data
    #"Renomeia Coluna para Data" = Table.RenameColumns(ConverteTabela,{{"Column1", "DATA"}}),
    #"Formata Coluna como Data" = Table.TransformColumnTypes(#"Renomeia Coluna para Data",{{"DATA", type date}}),
    #"Dia Inserido" = Table.AddColumn(#"Formata Coluna como Data", "Dia", each Date.Day([DATA]), Int64.Type),
    DiaSemanaAbrev = Table.AddColumn(#"Dia Inserido", "DIA SEMANA ABREV", each Date.ToText([DATA],"ddd"), type text),
    DiaSemanaNome = Table.AddColumn(DiaSemanaAbrev, "DIA SEMANA NOME", each Date.ToText([DATA],"dddd"), type text),
 
    // Mês
    MesNum = Table.AddColumn(DiaSemanaNome, "MÊS NUM", each Date.Month([DATA]), Int64.Type),
    MesNome = Table.AddColumn(MesNum, "MÊS NOME", each Date.MonthName([DATA]), type text),
    MesNomeAbrev = Table.AddColumn(MesNome, "MÊS NOME ABREV", each Date.ToText([DATA],"MMM"), type text),
 
    // Ano
    Ano = Table.AddColumn(MesNomeAbrev, "ANO", each Date.Year([DATA]), Int64.Type),
 
    #"Colocar Cada Palavra Em Maiúscula" = Table.TransformColumns(Ano, {
        {"MÊS NOME", Text.Proper, type text},
        {"MÊS NOME ABREV", Text.Proper, type text},
        {"DIA SEMANA ABREV", Text.Proper, type text},
        {"DIA SEMANA NOME", Text.Proper, type text}
    }),
    Dia_Nome = Table.AddColumn(#"Colocar Cada Palavra Em Maiúscula", "Dia_Nome", each Text.Combine({Text.From([Dia], "pt-BR"), [DIA SEMANA ABREV]}, " - "), type text),
    #"Semana do Ano Inserida" = Table.AddColumn(Dia_Nome, "Semana do Ano", each Date.WeekOfYear([DATA]), Int64.Type),
    #"Mês Ano Inserido" = Table.AddColumn(#"Semana do Ano Inserida", "MES_ANO", each Text.Combine({[MÊS NOME ABREV], Text.From([ANO], "pt-BR")}, "/"), type text),
    #"Prefixo Inserido" = Table.AddColumn(#"Mês Ano Inserido", "Prefixo", each "Semana " & Text.From([Semana do Ano], "pt-BR"), type text),
    #"Trimestre Inserido" = Table.AddColumn(#"Prefixo Inserido", "Trimestre", each Date.QuarterOfYear([DATA]), Int64.Type)
in
    #"Trimestre Inserido"
