% PARTE N°1
habitante(denken, humano,1290, auberst).
habitante(voll, enano, 1200, ende).
habitante(serie, elfo, 500, weise).
habitante(fern, humano, 1370, weise).
habitante(stark, humano, 1368, riegel).
habitante(lawine, humano, 1372, auberst).
habitante(kanne, humano, 1365, weise).
habitante(wirbel, humano, 1350, klares).
habitante(lernen, humano, 1315, auberst).
habitante(frieren, elfo, 100, weise).
habitante(eisen, enano, 1150, riegel).

promedioVida(humano,80).
promedioVida(enano,350).

anioDeMuerte(Persona, AnioMuerte) :- 
    habitante(Persona, Especie, Nacimiento,_),
    promedioVida(Especie, Promedio),
    AnioMuerte is Nacimiento + Promedio.

estaViva(Persona, Anio) :-
    habitante(Persona,elfo,Nacimiento,_),
    Anio >= Nacimiento.

estaViva(Persona, Anio) :-
    habitante(Persona,_,Nacimiento,_),
    Anio >= Nacimiento,
    anioDeMuerte(Persona, AnioMuerte),
    AnioMuerte >= Anio.



:- begin_tests(tpIntegrador, []).
    test(kanne_esta_viva_en_1370) :-
        estaViva(kanne, 1370).
    test(kanne_no_esta_viva_en_1300) :-
        not(estaViva(kanne, 1300)).
    test(kanne_no_esta_viva_en_1200) :-
        not(estaViva(kanne, 1200)).
    test(voll_esta_vivo_en_1550) :-
        estaViva(voll, 1550).
    test(voll_no_esta_vivo_en_1551) :-
        not(estaViva(voll, 1551)).
    test(serie_esta_viva_en_5000) :-
        estaViva(serie, 5000).
:- end_tests(tpIntegrador).
