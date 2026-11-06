// Realiza um de-para, substituindo valores de uma coluna de forma dinâmica
// Caso queira remover valores que não forem iguais ao substituir, basta trocar o _ no final para null ou ""

= Table.TransformColumns(
        #"Cabeçalhos Promovidos",
        {
            "COLUNA",
            each 
                if _ = "VALOR 1" then "VALOR A"
                else if _ = "VALOR 2" then "VALOR B"
                else if _ = "VALOR 3" then "VALOR C"
                else if _ = 1 then 10
                else if _ = 2 then 20
                else if _ = 3 then 30
                else _ // Se o valor não for localizado, mantem o valor original
        }
    )
