% PARTE N°1 (Punto 1) GRUPAL
% BASE DE CONOCIMIENTO
habitante(denken, humano, 1290, auberst).
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

promedioVida(humano, 80).
promedioVida(enano, 350).

recuerdo(wirbel, rescatar_a_la_hermana, presencio, 1390).
recuerdo(frieren, rescatar_a_la_hermana , presencio, 1390).
recuerdo(lawine, destruir_al_demonio_aura, cancion, 1393).
recuerdo(voll, destruir_al_demonio_aura, libro(50), 1400).
recuerdo(serie, destruir_al_rey_demonio, libro(100), 1335).
recuerdo(kanne, recuperar_al_gato_perdido, presencio, 1375).
recuerdo(denken, rescatar_a_la_hermana, libro(50), 1400). % Agregado para test de Punto 5

% implementacion de listas en vez de functores dos/2 o cuatro/4
hazania(rescatar_a_la_hermana, klares, [stark, fern]).
hazania(destruir_al_demonio_aura, weise, [frieren]).
hazania(destruir_al_demonio_aura, auberst, [denken]).
hazania(destruir_al_rey_demonio, ende, [frieren, himmel, heiter, eisen]).
hazania(recuperar_al_gato_perdido, weise, [himmel, frieren]).
hazania(destruir_a_schlat_el_omnisciente, ende, [el_heroe_del_sur]).

conmemoracion(weise, festividad(destruir_al_rey_demonio), 1340).
conmemoracion(auberst, estatua(bronce, el_equipo_de_heroes, destruir_al_rey_demonio), 1370).
conmemoracion(auberst, estatua(marmol, el_heroe_del_sur, destruir_a_schlat_el_omnisciente), 1340).

mantenimiento(el_equipo_de_heroes, 1400).
mantenimiento(el_equipo_de_heroes, 1450).
mantenimiento(el_heroe_del_sur, 1410).

% Agregado para tener un generador de pueblos unicos y evitar repetir los calculos por cada persona que vivia en un pueblo.
pueblo(Pueblo) :-
    findall(P, habitante(_, _, _, P), ListaPueblos),
    list_to_set(ListaPueblos, PueblosUnicos),
    member(Pueblo, PueblosUnicos).

anioDeMuerte(Persona, AnioMuerte) :- 
    habitante(Persona, Especie, Nacimiento, _),
    promedioVida(Especie, Promedio),
    AnioMuerte is Nacimiento + Promedio.

estaViva(Persona, Anio) :-
    habitante(Persona, _, Nacimiento, _),
    Anio >= Nacimiento,
    not(yaFallecio(Persona, Anio)).

% correcion al punto 1b
yaFallecio(Persona, Anio) :-
    anioDeMuerte(Persona, AnioMuerte),
    Anio > AnioMuerte.


% PARTE N°1 (Puntos 2 y 3)
recuerda(Persona, Hazania, AnioPedido) :-
    conocio(Persona, Hazania, FormaPresenciarlo, AnioDeRecuerdo),
    AnioPedido >= AnioDeRecuerdo,
    estaViva(Persona, AnioPedido), % correccion 2b estaViva movido a recuerda. Ademas ya no se usa Persona en recuerdaHasta, ya que no es necesario para la logica de recordar.
    recuerdaHasta(FormaPresenciarlo, AnioPedido, AnioDeRecuerdo).


% FUNCIONES DE CONOCER HAZAÑIA
conocio(Persona, Hazania, Forma, AnioConocio) :- 
    recuerdo(Persona, Hazania, Forma, AnioConocio).

anioQueConocio(Nacimiento, AnioInicio, AnioInicio) :-
    Nacimiento =< AnioInicio.

anioQueConocio(Nacimiento, AnioInicio, Nacimiento) :-
    Nacimiento > AnioInicio.

conocio(Persona, Hazania, festividad, AnioConocio) :-
    habitante(Persona, _, Nacimiento, Pueblo),
    conmemoracion(Pueblo, festividad(Hazania), AnioInicio),
    anioQueConocio(Nacimiento, AnioInicio, AnioConocio).

conocio(Persona, Hazania, estatua(Material, NombreEstatua, AnioInicio), AnioConocio) :-
    habitante(Persona, _, Nacimiento, Pueblo),
    conmemoracion(Pueblo, estatua(Material, NombreEstatua, Hazania), AnioInicio),
    anioQueConocio(Nacimiento, AnioInicio, AnioConocio).

% FUNCIONES DE RECORDAR LA HAZAÑIA POR CIERTO TIEMPO
recuerdaHasta(presencio, _, _).

recuerdaHasta(cancion, AnioPedido, AnioDeRecuerdo) :-
    AnioHasta is AnioDeRecuerdo + 15,
    AnioPedido =< AnioHasta.

recuerdaHasta(libro(Paginas), AnioPedido, AnioDeRecuerdo) :-
    AnioHasta is AnioDeRecuerdo + Paginas,
    AnioPedido =< AnioHasta.

recuerdaHasta(festividad, _, _).

recuerdaHasta(estatua(Material, NombreEstatua, AnioInicio), AnioPedido, _) :-
    estatuaEnBuenEstado(Material, NombreEstatua, AnioInicio, AnioPedido).

% FUNCIONES DE ESTATUAS
vidaUtilMaterial(marmol, 30).
vidaUtilMaterial(bronce, 15).

estatuaEnBuenEstado(Material, _, AnioInicio, AnioPedido) :-
    vidaUtilMaterial(Material, VidaMaxima),
    AnioPedido >= AnioInicio,
    AnioPedido - AnioInicio =< VidaMaxima.

estatuaEnBuenEstado(Material, NombreEstatua, _, AnioPedido) :-
    vidaUtilMaterial(Material, VidaMaxima),
    mantenimiento(NombreEstatua, AnioMantenimiento),
    AnioPedido >= AnioMantenimiento,
    AnioPedido - AnioMantenimiento =< VidaMaxima.

% OTRAS FUNCIONES DEL PUNTO 2 Y 3
% correccion 2c hazaniaCorroborada usando forall
hazaniaCorroborada(Hazania) :-
    hazania(Hazania, LugarOriginal, RealizadoresOriginales),
    forall(hazania(Hazania, OtroLugar, OtrosRealizadores), (LugarOriginal = OtroLugar, RealizadoresOriginales = OtrosRealizadores)).

pasoAlOlvido(Hazania, Anio) :-
    hazania(Hazania, _, _), 
    not(recuerda(_, Hazania, Anio)).

% PARTE N°2 (Punto 4)

recuerdaHazaniaPueblo(Pueblo, Hazania, AnioDado) :-
    habitante(Persona, _, _, Pueblo),
    recuerda(Persona, Hazania, AnioDado).

cantidadDeHojasLeidas(Pueblo, AnioDado, CantidadTotalDePaginas) :-
    findall(Paginas, (habitante(Persona, _, _, Pueblo), recuerda(Persona, Hazania, AnioDado), conocio(Persona, Hazania, libro(Paginas), _)),TotalPaginas),
    sum_list(TotalPaginas, CantidadTotalDePaginas).
    
puebloMasLector(Pueblo, AnioDado) :-
    cantidadDeHojasLeidas(Pueblo, AnioDado, MaxHojas),
    not((
        cantidadDeHojasLeidas(OtroPueblo, AnioDado, OtrasHojas),
        OtroPueblo \= Pueblo,
        OtrasHojas > MaxHojas
    )).

puebloMusical(Pueblo, AnioDado) :-
    pueblo(Pueblo), 
    hazaniasMusicales(Pueblo, AnioDado, CantidadHazaniasMusicales),
    hazaniasNoMusicales(Pueblo, AnioDado, CantidadHazaniasNoMusicales),
    CantidadHazaniasMusicales > CantidadHazaniasNoMusicales.

hazaniasMusicales(Pueblo, AnioDado, CantidadHazaniasMusicales) :-
    findall(Hazania, (habitante(Persona, _, _, Pueblo), conocio(Persona, Hazania, cancion, _), recuerda(Persona, Hazania, AnioDado)), ListaConDuplicados),
    list_to_set(ListaConDuplicados, HazaniasMusicalesSinDuplicados),
    length(HazaniasMusicalesSinDuplicados, CantidadHazaniasMusicales).

hazaniasNoMusicales(Pueblo, AnioDado, CantidadHazaniasNoMusicales) :-
    findall(Hazania, (habitante(Persona, _, _, Pueblo), recuerda(Persona, Hazania, AnioDado),not(conocio(Persona, Hazania, cancion, _))), ListaConDuplicados),
    list_to_set(ListaConDuplicados, HazaniasNoMusicalesSinDuplicados),
    length(HazaniasNoMusicalesSinDuplicados, CantidadHazaniasNoMusicales).
    
esChismoso(Pueblo, AnioDado) :- 
    recuerdaHazaniaPueblo(Pueblo, _, AnioDado),
    forall(
        recuerdaHazaniaPueblo(Pueblo, Hazania, AnioDado),
        not(hazaniaCorroborada(Hazania))
    ).

hazaniaImportante(Hazania, Pueblo, AnioDado) :-
    recuerdaHazaniaPueblo(Pueblo, Hazania, AnioDado),
    forall(
        (habitante(Persona, _, _, Pueblo), estaViva(Persona, AnioDado)),
        recuerda(Persona, Hazania, AnioDado)   
    ).

tiemposSinPrecedentes(Pueblo, AnioDado) :-
    habitante(_, _, _, Pueblo),
    hazaniaImportante(_, Pueblo, AnioDado),
    forall(
        hazaniaImportante(Hazania, Pueblo, AnioDado),
        (habitante(Persona, _, _, Pueblo), 
        conocio(Persona, Hazania, presencio, _))
    ).

% Punto 5

heroe(Persona) :-
    hazania(Hazania, _, Participantes),
    member(Persona, Participantes), 
    conocio(_, Hazania, _, _).      

inspiro(Inspirador, Heroe) :-
    heroe(Heroe),
    conocio(Heroe, Hazania, _, _), 
    hazania(Hazania, _, Participantes),
    member(Inspirador, Participantes),
    Inspirador \= Heroe.

caminoDeInspiracion(HeroeA, HeroeB, [HeroeA, HeroeB]) :-
    inspiro(HeroeA, HeroeB).

caminoDeInspiracion(HeroeA, HeroeB, [HeroeA, UnInspirado | Resto]) :-
    inspiro(HeroeA, UnInspirado),
    not(member(HeroeA, [UnInspirado | Resto])),
    caminoDeInspiracion(UnInspirado, HeroeB, [UnInspirado | Resto]).


% TESTS

:- begin_tests(tpIntegrador, []).

    % --- Tests Parte 1 ---
    test(persona_esta_viva_durante_su_expectativa_de_vida) :- estaViva(kanne, 1370).
    test(persona_no_esta_viva_antes_de_su_nacimiento) :- not(estaViva(kanne, 1300)).
    test(enano_esta_vivo_durante_su_expectativa_extendida) :- estaViva(voll, 1550).
    test(enano_no_esta_vivo_al_superar_su_expectativa) :- not(estaViva(voll, 1551)).
    test(elfo_esta_vivo_indefinidamente) :- estaViva(serie, 5000).
    test(persona_no_recuerda_hazania_antes_de_conocerla) :- not(recuerda(lawine, destruir_al_demonio_aura, 1380)).
    test(persona_recuerda_hazania_por_cancion_dentro_de_su_duracion) :- recuerda(lawine, destruir_al_demonio_aura, 1400).
    test(persona_olvida_hazania_por_cancion_tras_vencer_duracion) :- not(recuerda(lawine, destruir_al_demonio_aura, 1410)).
    test(hazania_unica_es_corroborada) :- hazaniaCorroborada(rescatar_a_la_hermana).
    test(hazania_multiples_versiones_no_es_corroborada) :- not(hazaniaCorroborada(destruir_al_demonio_aura)).
    test(hazania_sin_nadie_que_la_recuerde_pasa_al_olvido) :- pasoAlOlvido(destruir_al_demonio_aura, 1460).
    test(persona_recuerda_hazania_por_estatua_mantenida) :- recuerda(lawine, destruir_al_rey_demonio, 1400).
    test(persona_olvida_hazania_por_estatua_deteriorada) :- not(recuerda(lawine, destruir_al_rey_demonio, 1390)).

    % --- Tests Punto 4 ---
    test(pueblo_recuerda_hazania_si_al_menos_un_habitante_la_recuerda) :- recuerdaHazaniaPueblo(weise, destruir_al_rey_demonio, 1400).
    test(pueblo_suma_correctamente_todas_las_paginas_leidas) :- cantidadDeHojasLeidas(weise, 1335, 100).
    test(pueblo_con_mayor_cantidad_de_hojas_leidas_es_el_mas_lector) :- puebloMasLector(ende, 1400).
    test(pueblo_musical_si_mayor_parte_de_hazanias_recordadas_son_canciones) :- puebloMusical(auberst, 1395).
    test(pueblo_no_musical_si_canciones_no_superan_a_otros_medios) :- not(puebloMusical(weise, 1400)).
    test(pueblo_chismoso_si_ninguna_hazania_recordada_esta_corroborada) :- esChismoso(ende, 1420).
    test(hazania_importante_si_absolutamente_todo_el_pueblo_vivo_la_recuerda) :- hazaniaImportante(destruir_al_rey_demonio, weise, 1400).
    test(tiempos_sin_precedentes_si_toda_hazania_importante_fue_presenciada) :- tiemposSinPrecedentes(klares, 1395).

    % --- Tests Punto 5 ---
    test(persona_participante_en_hazania_conocida_es_heroe) :- heroe(frieren).
    test(persona_sin_participacion_en_hazania_conocida_no_es_heroe) :- not(heroe(wirbel)).
    test(heroe_inspira_a_otro_si_este_conoce_su_hazania) :- inspiro(frieren, fern).
    test(inspiracion_funciona_hacia_atras_en_el_tiempo) :- inspiro(stark, frieren).
    test(cadena_de_inspiracion_valida_con_multiples_eslabones) :- caminoDeInspiracion(himmel, denken, [himmel, frieren, fern, denken]).
    test(cadena_de_inspiracion_invalida_si_no_hay_relacion_de_inspiracion) :- not(caminoDeInspiracion(denken, frieren, [denken, frieren])).
    test(cadena_de_inspiracion_no_permite_ciclos_repetidos) :- not(caminoDeInspiracion(frieren, frieren, [frieren, fern, frieren])).
:- end_tests(tpIntegrador).
