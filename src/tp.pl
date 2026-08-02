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

% PARTE N°2
recuerdo(wirbel, rescatar_a_la_hermana, presencio, 1390).
recuerdo(frieren, rescatar_a_la_hermana , presencio, 1390).
recuerdo(lawine, destruir_al_demonio_aura, cancion, 1393).
recuerdo(voll, destruir_al_demonio_aura, libro(50), 1400).
recuerdo(serie, destruir_al_rey_demonio, libro(100), 1335).
recuerdo(kanne, recuperar_al_gato_perdido, presencio, 1375).

hazania(rescatar_a_la_hermana, klares, dos(stark, fern)).
hazania(destruir_al_demonio_aura, weise, frieren).
hazania(destruir_al_demonio_aura, auberst, denken).
hazania(destruir_al_rey_demonio, ende, cuatro(frieren, himmel, heiter, eisen)).
hazania(recuperar_al_gato_perdido, weise, dos(himmel, frieren)).

recuerda(Persona, Hazania, AnioPedido):-
    recuerdo(Persona, Hazania, FormaPresenciarlo, AnioDeRecuerdo),
    AnioPedido >= AnioDeRecuerdo,
    recuerdaHasta(Persona, FormaPresenciarlo, AnioPedido, AnioDeRecuerdo).

recuerdaHasta(Persona, presencio, AnioPedido, _):-
    estaViva(Persona, AnioPedido).

recuerdaHasta(_, cancion, AnioPedido, AnioDeRecuerdo):-
    estaViva(Persona, AnioPedido),
    AnioHasta is AnioDeRecuerdo + 15,
    AnioPedido =< AnioHasta.

recuerdaHasta(_, libro(Paginas), AnioPedido, AnioDeRecuerdo):-
    estaViva(Persona, AnioPedido),
    AnioHasta is AnioDeRecuerdo + Paginas,
    AnioPedido =< AnioHasta.

hazaniaCorroborada(Hazania):-
    hazania(Hazania, UnLugar, Realizadores1),
    not((hazania(Hazania, OtroLugar, Realizadores2), 
            sonVersionesDistintas(UnLugar, Realizadores1, OtroLugar, Realizadores2)
        )).

sonVersionesDistintas(UnLugar, _, OtroLugar, _):-
    UnLugar \= OtroLugar.

sonVersionesDistintas(_, Realizadores1, _, Realizadores2):-
    Realizadores1 \= Realizadores2.




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
    test(lawine_no_recuerda_destruir_al_demonio_aura_en_1380) :-
        not(recuerda(lawine, destruir_al_demonio_aura, 1380)).
    test(lawine_recuerda_destruir_al_demonio_aura_en_1400) :-
        recuerda(lawine, destruir_al_demonio_aura, 1400).
    test(lawine_ya_no_recuerda_destruir_al_demonio_aura_1410) :-
         not(recuerda(lawine, destruir_al_demonio_aura, 1410)).
    test(voll_recuerda_destuir_al_demonio_aura_en_1450) :-
        recuerda(voll, destruir_al_demonio_aura, 1450).
    test(voll_no_recuerda_destuir_al_demonio_aura_en_1460) :-
        not(recuerda(voll, destruir_al_demonio_aura, 1460)).
    test(wirbel_recuerda_rescatar_a_la_hermana_en_1430) :-
        recuerda(wirbel, rescatar_a_la_hermana, 1430).
    test(wirbel_ya_no_recuerda_rescatar_a_la_hermana_en_1440) :-
        not(recuerda(wirbel, rescatar_a_la_hermana, 1440)).
    test(rescatar_a_la_hermana_es_corroborada) :-
        hazaniaCorroborada(rescatar_a_la_hermana).
    test(destruir_al_demonio_aura_no_es_corroborada) :-
        not(hazaniaCorroborada(destruir_al_demonio_aura)).
    test(destruir_al_demonio_aura_paso_al_olvido_en_1460) :-
        pasoAlOlvido(destruir_al_demonio_aura, 1460).
    test(destruir_al_demonio_aura_no_paso_al_olvido_en_1440) :-
        not(pasoAlOlvido(destruir_al_demonio_aura, 1440)).
:- end_tests(tpIntegrador).

