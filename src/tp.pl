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
hazania(destruir_a_schlat_el_omnisciente, ende, el_heroe_del_sur).

recuerda(Persona, Hazania, AnioPedido):-
    conocio(Persona, Hazania, FormaPresenciarlo, AnioDeRecuerdo),
    AnioPedido >= AnioDeRecuerdo,
    recuerdaHasta(Persona, FormaPresenciarlo, AnioPedido, AnioDeRecuerdo).

conocio(Persona, Hazania, Forma, Anio) :-
    recuerdo(Persona, Hazania, Forma, Anio).

recuerdaHasta(Persona, presencio, AnioPedido, _):-
    estaViva(Persona, AnioPedido).

recuerdaHasta(Persona, cancion, AnioPedido, AnioDeRecuerdo):-
    estaViva(Persona, AnioPedido),
    AnioHasta is AnioDeRecuerdo + 15,
    AnioPedido =< AnioHasta.

recuerdaHasta(Persona, libro(Paginas), AnioPedido, AnioDeRecuerdo):-
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

pasoAlOlvido(Hazania, Anio) :-
    hazania(Hazania, _, _), 
    not(recuerda(_, Hazania, Anio)).

% PARTE N°3
conmemoracion(weise, festividad(destruir_al_rey_demonio, 1340)).
conmemoracion(auberst, estatua(bronce, el_equipo_de_heroes, destruir_al_rey_demonio, 1370)).
conmemoracion(auberst, estatua(marmol, el_heroe_del_sur, destruir_a_schlat_el_omnisciente, 1340)).

mantenimiento(el_equipo_de_heroes, 1400).
mantenimiento(el_equipo_de_heroes, 1450).
mantenimiento(el_heroe_del_sur, 1410).

conocio(Persona, Hazania, festividad, AnioConocio) :-
    habitante(Persona, _, Nacimiento, Pueblo),
    conmemoracion(Pueblo, festividad(Hazania, AnioInicioFestividad)),
    AnioConocio is max(Nacimiento, AnioInicioFestividad).

conocio(Persona, Hazania, estatua(Material, NombreEstatua, Hazania, AnioInicio), AnioConocio) :-
    habitante(Persona, _, Nacimiento, Pueblo),
    conmemoracion(Pueblo, estatua(Material, NombreEstatua, Hazania, AnioInicio)),
    AnioConocio is max(Nacimiento, AnioInicio).

recuerdaHasta(Persona, festividad, AnioPedido, _) :-
    estaViva(Persona, AnioPedido).

recuerdaHasta(Persona, estatua(Material, NombreEstatua, Hazania, AnioInicio), AnioPedido, _) :-
    estaViva(Persona, AnioPedido),
    estatuaEnBuenEstado(Material, NombreEstatua, AnioInicio, AnioPedido).

vidaUtilMaterial(marmol, 30).
vidaUtilMaterial(bronce, 15).

estatuaEnBuenEstado(Material, _, AnioInicio, AnioPedido) :-
    vidaUtilMaterial(Material, VidaMaxima),
    AnioPedido >= AnioInicio,
    Diferencia is AnioPedido - AnioInicio,
    Diferencia =< VidaMaxima.

estatuaEnBuenEstado(Material, NombreEstatua, _, AnioPedido) :-
    vidaUtilMaterial(Material, VidaMaxima),
    mantenimiento(NombreEstatua, AnioMantenimiento),
    AnioPedido >= AnioMantenimiento,
    Diferencia is AnioPedido - AnioMantenimiento,
    Diferencia =< VidaMaxima.


% PARTE N°2
% PUNTO 4

recuerdaHazaniaPueblo(Pueblo, Hazania, AnioDado) :-
    habitante(Persona,_,_,Pueblo),
    recuerda(Persona, Hazania, AnioDado).

cantidadDeHojasLeidas(Pueblo, AnioDado, CantidadTotalDePaginas) :-
    findall(Paginas,(habitante(Persona,_,_,Pueblo),conocio(Persona, _, libro(Paginas), AnioDado)), TotalPaginas),
    sum_list(TotalPaginas, CantidadTotalDePaginas).
    
puebloMasLector(Pueblo, AnioDado):-
    cantidadDeHojasLeidas(Pueblo, AnioDado, CantidadDeHojas),
    not((
        cantidadDeHojasLeidas(OtroPueblo, AnioDado, CantidadDeHojas2),
        OtroPueblo \= Pueblo,
        CantidadDeHojas2 > CantidadDeHojas
    )).

puebloMusical(Pueblo, AnioDado) :-
    cantidadHazaniasNoMusicales(Pueblo, AnioDado, CantidadTotalHazaniasNoMusicales),
    cantidadHazaniasMusicales(Pueblo,AnioDado, CantidadTotalHazaniasMusicales),
    CantidadTotalHazaniasMusicales > CantidadTotalHazaniasNoMusicales.

cantidadHazaniasNoMusicales(Pueblo, AnioDado, CantidadTotalHazaniasNoMusicales) :-
    findall(Hazania, 
        (habitante(Persona,_,_,Pueblo), recuerda(Persona, Hazania, AnioDado), conocio(Persona,Hazania, FormaDeConocimiento,_), FormaDeConocimiento \= cancion),
        ListaHazaniasNoMusicales),
    length(ListaHazaniasNoMusicales, CantidadTotalHazaniasNoMusicales).

cantidadHazaniasMusicales(Pueblo, AnioDado, CantidadTotalHazaniasMusicales) :-
    findall(Hazania, (habitante(Persona,_,_,Pueblo), recuerda(Persona, Hazania, AnioDado), conocio(Persona, Hazania, cancion,_)), ListaHazaniasMusicales),
    length(ListaHazaniasMusicales, CantidadTotalHazaniasMusicales).
    
esChismoso(Pueblo, AnioDado) :- 
    recuerdaHazaniaPueblo(Pueblo, _, AnioDado),
    forall(
        recuerdaHazaniaPueblo(Pueblo, Hazania, AnioDado),
        not(hazaniaCorroborada(Hazania))
    ).

hazaniaImportante(Hazania, Pueblo, AnioDado) :-
    recuerdaHazaniaPueblo(Pueblo, Hazania, AnioDado),
    forall(
        (habitante(Persona, _,_, Pueblo), estaViva(Persona, AnioDado)),
        recuerda(Persona, Hazania, AnioDado)   
    ).

tiemposSinPrecedentes(Pueblo, AnioDado) :-
    habitante(_, _ , _, Pueblo),
    hazaniaImportante(_, Pueblo, AnioDado),
    forall(
        hazaniaImportante(Hazania, Pueblo, AnioDado),
        (habitante(Persona,_,_,Pueblo),
        recuerdo(Persona, Hazania, presencio, _))
    ).


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
    test(lawine_recuerda_rey_demonio_1400_por_estatua) :-
        recuerda(lawine, destruir_al_rey_demonio, 1400).
    test(lawine_no_recuerda_rey_demonio_1390_porque_estatua_rota) :-
        not(recuerda(lawine, destruir_al_rey_demonio, 1390)).
    test(fern_recuerda_rey_demonio_1400_por_festividad) :-
        recuerda(fern, destruir_al_rey_demonio, 1400).
    test(en_weise_se_recuerda_destruir_al_rey_demonio_en_1400) :-
        recuerdaHazaniaPueblo(weise,destruir_al_rey_demonio,1400).
    test(en_klares_se_recuerda_rescatar_a_la_hermana_de_wirbel_en_1395) :-
        recuerdaHazaniaPueblo(klares,rescatar_a_la_hermana,1395).
    test(en_klares_no_se_recuerda_destruir_al_rey_demonio_en_1395) :-
        not(recuerdaHazaniaPueblo(klares,destruir_al_rey_demonio,1395)).
    test(en_weise_se_leyeron_100_paginas_en_1335):-
        cantidadDeHojasLeidas(weise, 1335, 100).
    test(en_weise_se_leyeron_0_paginas_en_1336):-
        cantidadDeHojasLeidas(weise, 1336, 0).
    test(ende_es_el_pueblo_mas_lector_en_1440) :-
        puebloMasLector(ende,1440).
    test(auberst_es_musical_en_1395) :-
        puebloMusical(auberst,1395).
    test(weise_no_es_musical_en_1400) :-
        not(puebloMusical(weise,1400)).
    test(ende_es_chismoso_en_1420) :-
        esChismoso(ende,1420).
    test(weise_no_es_chismoso_en_1400) :-
        not(esChismoso(weise,1400)).
    test(destruir_al_rey_demonio_es_importante_para_weise_en_1400) :-
        hazaniaImportante(destruir_al_rey_demonio, weise, 1400).
    test(recuperar_al_gato_perdido_no_es_importante_para_weise_en_1400) :-
        not(hazaniaImportante(recuperar_al_gato_perdido, weise, 1400)).
    test(klares_vive_tiempos_sin_precedentes_en_1395) :-
        tiemposSinPrecedentes(klares, 1395).
    test(klares_vive_tiempos_sin_precedentes_en_1395) :-
        tiemposSinPrecedentes(klares, 1395).
    test(weise_no_vive_tiempos_sin_precedentes_en_1400) :-
        not(tiemposSinPrecedentes(weise, 1400)).
:- end_tests(tpIntegrador).

