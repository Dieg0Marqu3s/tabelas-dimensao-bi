let
    // Data e hora atual em UTC
    DataHoraUTC = DateTimeZone.UtcNow(),

    // Conversão para UTC-3 (horário de Brasília)
    DataHoraBrasilia = DateTimeZone.SwitchZone(DataHoraUTC, -3),
    DataHoraFinal = DateTimeZone.RemoveZone(DataHoraBrasilia),

    Fonte = #table(
        {"DATAHORA_ATT", "DATA_ATT", "HORA_ATT"},
        {
            {
                DataHoraFinal,
                Date.From(DataHoraFinal),
                Time.ToText(Time.From(DataHoraFinal), "HH:mm", "pt-BR")
            }
        }
    ),
    #"Tipo Alterado" = Table.TransformColumnTypes(
        Fonte,
        {{"DATAHORA_ATT", type datetime}, {"DATA_ATT", type date}, {"HORA_ATT", type time}}
    )
in
    #"Tipo Alterado"
