let
    Horas = Table.FromList({0..23}, Splitter.SplitByNothing(), {"HORA"}),
    TipoHora = Table.TransformColumnTypes(Horas, {{"HORA", Int64.Type}}),
    Periodo = Table.AddColumn(TipoHora, "PERIODO", each
        if [HORA] < 6 then "MADRUGADA"
        else if [HORA] < 12 then "MANHÃ"
        else if [HORA] < 18 then "TARDE"
        else "NOITE", type text),
    Turno = Table.AddColumn(Periodo, "TURNO", each
        if [HORA] >= 6 and [HORA] < 18 then "DIURNO" else "NOTURNO", type text)
in
    Turno
