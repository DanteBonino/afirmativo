%tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tamaño, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

%Ubicaciones:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%Cadena de mando:
%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).

%Punto 1:
frecuenta(Agente, Lugar):-
    lugarDeTarea(Agente, Lugar).
frecuenta(Agente, buenosAires):-
    tarea(Agente,_,_).
frecuenta(vega, quilmes).
frecuenta(Agente, marDelPlata):-
    tarea(Agente, vigilar(Lugares), _),
    member(negocioDeAlfajores, Lugares).

%Punto 2:
inaccesible(Lugar):-
    ubicacion(Lugar),
    not(frecuenta(_,Lugar)).

%Punto 3:
afinado(Agente):-
    tarea(Agente,_,_),
    not(trabajaEnMasDeUnLugar(Agente)).

lugarDeTarea(Agente, LugarDeTarea):-
    tarea(Agente,_,LugarDeTarea).

trabajaEnMasDeUnLugar(Agente):-
    lugarDeTarea(Agente, Lugar),
    lugarDeTarea(Agente, OtroLugar),
    OtroLugar \= Lugar.

%Punto 5:
agentePremiado(Agente):-
    puntuacionAgente(Agente, Puntuacion),
    forall(puntuacionAgente(_, PuntuacionOtroAgente), Puntuacion >= PuntuacionOtroAgente).

puntuacionAgente(Agente, Puntuacion):-
    tarea(Agente,_,_),
    findall(PuntosTarea, puntosPorTarea(Agente, PuntosTarea), PuntosTotales),
    sum_list(PuntosTotales, Puntuacion).

puntosPorTarea(Agente, PuntosTarea):-
    tarea(Agente, Tarea,_),
    puntosTarea(Tarea, PuntosTarea).

puntosTarea(vigilar(Negocios), Puntos):-
    length(Negocios, Puntos).
puntosTarea(ingerir(_,Tamanio, Longitud), Puntos):-
    Puntos is (-10) * Tamanio * Longitud.
puntosTarea(apresar(_,Recompensa), Puntos):-
    Puntos is Recompensa / 2.
puntosTarea(asuntosInternos(AgenteInvestigado), PuntosAgente):-
    puntuacionAgente(AgenteInvestigado, PuntosAgente).

