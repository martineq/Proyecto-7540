program citassigno;    { ..::: ENCABEZAMIENTO DEL PROGRAMA :::.. }


uses crt;          { ..::: LISTA DE UNIDADES EXTERNAS :::.. }


const      { ..::: DECLARACION DE CONSTANTES :::.. }
        maxlista = 100;
        totalsignos = 12;
        edadmaxima = 79;
        edadminima = 15; {no es algo pedido, pero es logico y sirve como
                        comprobacion de que no se ingrese una fecha ilogica}
        lineasdepantalla = 25; {lo usaremos para partes del programa que
                                impriman listas largas, asi no se pierde
                                informacion}


type         { ..::: DECLARACION DE TIPOS DE CONSTANTES :::.. }
        t_signos = (Piscis, Aries, Tauro, Geminis, Cancer, Leo, Virgo, Libra, Escorpio, Sagitario, Capricornio, Acuario);
        t_rangolista = 1..maxlista;
        t_rangosignos = 1..totalsignos;
        t_dia = 1..31;
        t_mes = 1..12;
        t_vecnombresyapellidos = array [t_rangolista] of string;
        t_vecdianac = array [t_rangolista] of t_dia;
        t_vecmesnac = array [t_rangolista] of t_mes;
        t_vecanionac = array [t_rangolista] of integer;
        t_veclistasignos = array [t_rangolista] of t_signos;
        t_vecsexo = array [t_rangolista] of boolean;
        t_vecdatossignos = array [t_rangosignos] of integer;
        t_incompsignos = array [t_rangosignos, t_rangosignos] of boolean;
        t_vecsignos = array [t_rangosignos] of t_signos;


var     { ..::: DEFINICION DE VARIABLES :::.. }
        listnombres, listapellidos:t_vecnombresyapellidos;
        listdianac:t_vecdianac;
        listmesnac:t_vecmesnac;
        listanionac:t_vecanionac;
        listsigno:t_veclistasignos;
        listhombres:t_vecsexo; {utilizamos un vector booleano, si el cliente
                                almacenado es hombre, guardara true, si es
                                mujer, guardara false}
        listaincompsignos:t_incompsignos;
        tamaniolista, indice, cotainf, cotasup:t_rangolista;
        tarea, i, j, contadorlineas:integer;
        sino:char;
        nombre, apellido:string;
        signo:t_signos;
        sexo:boolean;
        diahoy, dianac:t_dia;
        meshoy, mesnac:t_mes;
        aniohoy, anionac:integer;
        cantsignos:t_vecdatossignos;
        vecsignos:t_vecsignos;
        validante, datosenlista, datosincomp:boolean;
        salir:char;




        { ..::: DECLARACIONES DE SUBPROGRAMAS INTERNOS :::.. }


procedure validacionSN (var sino:char);
   var
     aux:char;
   begin
     sino := 'a';
     repeat
      readln (aux);
      case aux of
        's', 'S' : sino := 's';
        'n', 'N' : sino := 'n';
      else
         writeln ('respuesta invalida, por favor intente de nuevo');
      end;
     until (sino = 's') or (sino = 'n');
end;



procedure leerindicevalido (var indice:t_rangolista; tamaniolista:t_rangolista);
    var
        aux:integer;
     begin
       repeat
         readln (aux);
          if (aux < 1) or (aux > tamaniolista) then
         writeln ('indice invalido, el indice maximo posible es', tamaniolista);
       until (aux >= 1) and (aux <= tamaniolista);
     indice := aux;
end;



procedure leersigno (var signo:t_signos);
    var
        aux:string;
        validante:boolean;
     begin
      validante := false;
      repeat
         readln (aux);
         if (aux = 'piscis') or (aux = 'Piscis') or (aux = 'PISCIS') then
           begin signo := Piscis; validante := true; end
         else
          if (aux = 'aries') or (aux = 'Aries') or (aux = 'ARIES') then
         begin signo := Aries; validante := true; end
         else
         if (aux = 'tauro') or (aux = 'Tauro') or (aux = 'TAURO') then
         begin signo := Tauro; validante := true; end
         else
         if (aux = 'geminis') or (aux = 'Geminis') or (aux = 'GEMINIS') then
         begin signo := Geminis; validante := true; end
         else
         if (aux = 'cancer') or (aux = 'Cancer') or (aux = 'CANCER') then
         begin signo := Cancer; validante := true; end
         else
         if (aux = 'leo') or (aux = 'Leo') or (aux = 'LEO') then
         begin signo := Leo; validante := true; end
         else
         if (aux = 'virgo') or (aux = 'Virgo') or (aux = 'VIRGO') then
         begin signo := Virgo; validante := true; end
         else
         if (aux = 'libra') or (aux = 'Libra') or (aux = 'LIBRA') then
         begin signo := Libra; validante := true; end
         else
         if (aux = 'escorpio') or (aux = 'Escorpio') or (aux = 'ESCORPIO') then
         begin signo := Escorpio; validante := true; end
         else
         if (aux = 'sagitario') or (aux = 'Sagitario') or (aux = 'SAGITARIO') then
         begin signo := Sagitario; validante := true; end
         else
         if (aux = 'capricornio') or (aux = 'Capricornio') or (aux = 'CAPRICORNIO') then
         begin signo := Capricornio; validante := true; end
         else
         if (aux = 'acuario') or (aux = 'Acuario') or (aux = 'ACUARIO') then
         begin signo := Acuario; validante := true; end
         else
                writeln ('no se reconoce "',aux,'" como un signo valido, intente nuevamente');
      until validante;
end;


function imprimirsigno (signo:t_signos) : string;
   begin
    case signo of
        Piscis : imprimirsigno := 'Piscis';
        Aries : imprimirsigno := 'Aries';
        Tauro : imprimirsigno := 'Tauro';
        Geminis : imprimirsigno := 'Geminis';
        Cancer : imprimirsigno := 'Cancer';
        Leo : imprimirsigno := 'Leo';
        Virgo : imprimirsigno := 'Virgo';
        Libra : imprimirsigno := 'Libra';
        Escorpio : imprimirsigno := 'Escorpio';
        Sagitario : imprimirsigno := 'Sagitario';
        Capricornio : imprimirsigno := 'Capricornio';
        Acuario : imprimirsigno := 'Acuario';
    end;
end;


function signoporindice (indice:integer) : t_signos;
   begin
     case indice of
        1 : signoporindice := Piscis;
        2 : signoporindice := Aries;
        3 : signoporindice := Tauro;
        4 : signoporindice := Geminis;
        5 : signoporindice := Cancer;
        6 : signoporindice := Leo;
        7 : signoporindice := Virgo;
        8 : signoporindice := Libra;
        9 : signoporindice := Escorpio;
        10 : signoporindice := Sagitario;
        11 : signoporindice := Capricornio;
        12 : signoporindice := Acuario;
     end;
end;



procedure leerfechavalida (var dia:t_dia; var mes:t_mes; var anio:integer);
     var
        d, m:integer;
        validante:boolean;
      begin
       validante := false;
       repeat
         writeln ('ingrese el dia');
         readln (d);
         if (d < 1) or (d > 31) then
                repeat
                writeln ('numero de dia incorrecto por favor ingrese otro');
                readln (d);
                until (d >= 1) and (d <= 31);
         writeln ('ingrese el mes');
         readln (m);
         if (m < 1) or (m > 12) then
                repeat
                begin
                writeln ('mes invalido, por favor ingrese otro');
                readln (m);
                end;
                until (m >= 1) and (m <= 12);
        {para los meses de 31 dias, la validacion ya esta hecha al ingresar el dia,
        pero para los meses de menos dias, tengo que agregar una validacion extra}
         case m of
                1, 3, 5, 8, 10, 12 : validante := true;
                2 : if (d <= 29) then validante := true;
                4 : if (d <= 30) then validante := true;
                6 : if (d <= 30) then validante := true;
                7 : if (d <= 30) then validante := true;
                9 : if (d <= 30) then validante := true;
                11 : if (d <= 30) then validante := true;
         end;
         if not validante then
         writeln ('fecha invalida, no existe el ',d,'/',m,' ingrese otra')
         else
         begin
         writeln ('ingrese el a¤o');
         readln (anio);
         if (m = 2) and (d = 29) then
                if ((anio - 2004) mod 4 <> 0) then
                        begin
                        writeln ('ingreso 29 de febrero para un a¤o no bisiesto, fecha invalida');
                        validante := false;
                        end;
         end;
until validante;
dia := d;
mes := m;
end;



function edad ( dianac:t_dia; mesnac:t_mes; anionac:integer; diahoy:t_dia; meshoy:t_mes; aniohoy:integer) : integer;
   begin
    if (meshoy <= mesnac) and (diahoy < dianac) then
        edad := (aniohoy - anionac - 1)
    else
        edad := aniohoy - anionac;
    end;


function calculosigno (dianac:t_dia; mesnac:t_mes) : t_signos;
   begin
    case mesnac of
        1 : case dianac of
                1..20 : calculosigno := Capricornio;
                21..31 : calculosigno := Acuario;
            end;
        2 : case dianac of
                1..21 : calculosigno := Acuario;
                22..29 : calculosigno := Piscis;
            end;
        3 : case dianac of
                1..20 : calculosigno := Piscis;
                21..31 : calculosigno := Aries;
            end;
        4 : case dianac of
                1..20 : calculosigno := Aries;
                21..30 : calculosigno := Tauro;
                end;
        5 : case dianac of
                1..21 : calculosigno := Tauro;
                22..31 : calculosigno := Geminis;
                end;
        6 : case dianac of
                1..21 : calculosigno := Geminis;
                22..30 : calculosigno := Cancer;
                end;
        7 : case dianac of
                1..22 : calculosigno := Cancer;
                23..30 : calculosigno := Leo;
                end;
        8 : case dianac of
                1..23 : calculosigno := Leo;
                24..31 : calculosigno := Virgo;
                end;
        9 : case dianac of
                1..23 : calculosigno := Virgo;
                24..30 : calculosigno := Libra;
                end;
        10 : case dianac of
                1..23 : calculosigno := Libra;
                24..31 : calculosigno := Escorpio;
                end;
        11 : case dianac of
                1..22 : calculosigno := Escorpio;
                23..30 : calculosigno := Sagitario;
                end;
        12 : case dianac of
                1..21 : calculosigno := Sagitario;
                22..31 : calculosigno := Capricornio;
                end;
   end;
end;



procedure leersexo (var sexo:boolean);
   var
     aux:string;
     validante:boolean;
   begin
    validante := false;
    repeat
        writeln ('Ingrese el sexo ("m" para masculino, "f" para femenino)');
        readln (aux);
        if (aux = 'f') or (aux = 'F') then
         begin
          sexo := false;
          validante := true;
         end
        else
         if (aux = 'm') or (aux = 'M') or (aux = 'HOMBRE') then
          begin
           sexo := true;
            validante := true;
          end
         else
                writeln ('no se reconoce "',aux,'" como un sexo valido, por favor intente de nuevo');
     until validante;
end;



procedure leerfechavalidacompania (var dianac:t_dia; var mesnac:t_mes;
                                   var anionac:integer; diahoy:t_dia; meshoy:t_mes; aniohoy:integer);
  begin
    repeat
     leerfechavalida (dianac, mesnac, anionac);
      if edad (dianac, mesnac, anionac, diahoy, meshoy, aniohoy) > edadmaxima then
               begin
               writeln ('la fecha introducida no es valida, ya que excede la edad maxima fijada por la compa¤ia');
               end
      else
               if edad (dianac, mesnac, anionac, diahoy, meshoy, aniohoy) < edadminima then
               writeln ('la fecha introducida no es valida, ya que no excede la edad minima fijada por la compa¤ia');
    until (edad (dianac, mesnac, anionac, diahoy, meshoy, aniohoy) <= edadmaxima) and
          (edad (dianac, mesnac, anionac, diahoy, meshoy, aniohoy) >= edadminima);;
end;



procedure leerdatoscliente (var nombre, apellido:string; var dianac:t_dia;
                            var mesnac:t_mes; var anionac:integer; var signo:t_signos;
                            var sexo:boolean; diahoy:t_dia; meshoy:t_mes; aniohoy:integer);
  begin
    writeln ('ingrese la fecha de nacimiento del cliente');
    leerfechavalidacompania (dianac, mesnac, anionac, diahoy, meshoy, aniohoy);
    signo := calculosigno (dianac, mesnac);
    writeln ('ingrese el/los nombre/s del cliente');
    readln (nombre);
    writeln ('ingrese el/los apellido/s del cliente');
    readln (apellido);
    leersexo (sexo);
end;


procedure ordenarultimoporsign (var listsigno:t_veclistasignos; var listnombres, listapellidos:t_vecnombresyapellidos;
                                var listdianac:t_vecdianac; var listmesnac:t_vecmesnac; var listanionac:t_vecanionac;
                                var listhombres:t_vecsexo; tamaniolista:integer);
   var
        auxsigno:t_signos;
        auxnombre, auxapellido:string;
        auxdia:t_dia;
        auxmes:t_mes;
        auxanio:integer;
        auxsexo:boolean;
        posicion:integer;
        validante:boolean;
   begin
     posicion := tamaniolista - 1;
     auxsigno := listsigno [tamaniolista];
     auxnombre := listnombres [tamaniolista];
     auxapellido := listapellidos [tamaniolista];
     auxdia := listdianac [tamaniolista];
     auxmes := listmesnac [tamaniolista];
     auxanio := listanionac [tamaniolista];
     auxsexo := listhombres [tamaniolista];
     validante := auxsigno < listsigno [posicion];
   while (posicion >= 1) and validante do
        begin
        listsigno [posicion + 1] := listsigno [posicion];
        listnombres [posicion + 1] := listnombres [posicion];
        listapellidos [posicion +1] := listapellidos [posicion];
        listdianac [posicion + 1] := listdianac [posicion];
        listmesnac [posicion + 1] := listmesnac [posicion];
        listanionac [posicion + 1] := listanionac [posicion];
        listhombres [posicion +1] := listhombres [posicion];
        posicion := posicion - 1;
        if posicion >= 1 then
                validante := auxsigno < listsigno [posicion];
     end;
     listsigno [posicion + 1] := auxsigno;
     listnombres [posicion + 1] := auxnombre;
     listapellidos [posicion + 1] := auxapellido;
     listdianac [posicion + 1] := auxdia;
     listmesnac [posicion + 1] := auxmes;
     listanionac [posicion + 1] := auxanio;
     listhombres [posicion + 1] := auxsexo;
end;



procedure ordiniporsign (var listsigno:t_veclistasignos; var listnombres, listapellidos:t_vecnombresyapellidos;
                         var listdianac:t_vecdianac; var listmesnac:t_vecmesnac; var listanionac:t_vecanionac;
                         var listhombres:t_vecsexo; inicio, tamaniolista:integer);
   var
        auxsigno:t_signos;
        auxnombre, auxapellido:string;
        auxdia:t_dia;
        auxmes:t_mes;
        auxanio:integer;
        auxsexo:boolean;
        posicion:integer;
        validante:boolean;
   begin
    posicion := inicio + 1;
    auxsigno := listsigno [inicio];
    auxnombre := listnombres [inicio];
    auxapellido := listapellidos [inicio];
    auxdia := listdianac [inicio];
    auxmes := listmesnac [inicio];
    auxanio := listanionac [inicio];
    auxsexo := listhombres [inicio];
    validante := auxsigno > listsigno [posicion];
   while (posicion <= tamaniolista) and validante do
        begin
        listsigno [posicion - 1] := listsigno [posicion];
        listnombres [posicion - 1] := listnombres [posicion];
        listapellidos [posicion - 1] := listapellidos [posicion];
        listdianac [posicion - 1] := listdianac [posicion];
        listmesnac [posicion - 1] := listmesnac [posicion];
        listanionac [posicion - 1] := listanionac [posicion];
        listhombres [posicion - 1] := listhombres [posicion];
        posicion := posicion + 1;
        if posicion <= tamaniolista then
                validante := auxsigno > listsigno [posicion];
        end;
     listsigno [posicion - 1] := auxsigno;
     listnombres [posicion - 1] := auxnombre;
     listapellidos [posicion - 1] := auxapellido;
     listdianac [posicion - 1] := auxdia;
     listmesnac [posicion - 1] := auxmes;
     listanionac [posicion - 1] := auxanio;
     listhombres [posicion - 1] := auxsexo;
end;


procedure ordmedporsign (var listsigno:t_veclistasignos; var listnombres, listapellidos:t_vecnombresyapellidos;
                         var listdianac:t_vecdianac; var listmesnac:t_vecmesnac; var listanionac:t_vecanionac;
                         var listhombres:t_vecsexo; indice, tamaniolista:integer);
     begin
      if listsigno [indice] < listsigno [indice - 1] then
         ordenarultimoporsign (listsigno, listnombres, listapellidos,
         listdianac, listmesnac, listanionac, listhombres, indice)
      else
        if listsigno [indice] > listsigno [indice + 1] then
        ordiniporsign (listsigno, listnombres, listapellidos, listdianac, listmesnac, listanionac, listhombres,
                       indice, tamaniolista);
end;




procedure busquedasignobinaria (signo:t_signos; var indiceencontrado:t_rangolista;
                                var listsigno:t_veclistasignos; tamaniolista:t_rangolista;
                                var encontrado:boolean);
      {paso la lista de signos como valor para no correr riesgos de que
      sobrepase el stack}
      var
        medio, desde, hasta:t_rangolista;
       begin
         encontrado := true;
         desde := 1;
         hasta := tamaniolista;
       repeat
             medio := (desde + hasta) div 2;
             if (listsigno [medio] > signo) then
                hasta := medio - 1
             else
                 if (listsigno [medio] < signo) then
                 desde := medio + 1;
             if (desde > hasta) then
             encontrado := false;
       until (listsigno [medio] = signo) or not encontrado;
       if encontrado then
       indiceencontrado := medio;
end;



procedure busquedarangosigno (signo:t_signos; tamaniolista:t_rangolista;
                              var cotainf, cotasup:t_rangolista; var listsigno:t_veclistasignos;
                              var encontrado:boolean);
    {paso la lista de signos como valor para no correr riesgos de que
      sobrepase el stack}
    begin
      busquedasignobinaria (signo, cotainf, listsigno, tamaniolista, encontrado);
      cotasup := cotainf;
      if encontrado then
        begin
        repeat
        if (cotainf > 1) then
        if listsigno [cotainf] = listsigno [cotainf - 1] then
        cotainf := cotainf - 1;
        until (listsigno [cotainf] > listsigno [cotainf - 1]) or (cotainf = 1);
        repeat
        if (cotasup < tamaniolista) then
        if listsigno [cotasup] = listsigno [cotasup + 1] then
        cotasup := cotasup + 1;
        until (listsigno [cotasup] < listsigno [cotasup + 1]) or (cotasup = tamaniolista);
        end;
end;



procedure contarsignosporincomp (var listincompsignos:t_incompsignos; var cantsignos:t_vecdatossignos);
    {paso la lista de incompatibilidades como valor para no correr riesgos
    de que sobrepase el stack}
    var
        i, j:integer;
    begin
     for i := 1 to totalsignos do
         begin
         cantsignos [i] := 0;
         for j := 1 to totalsignos do
                if listincompsignos [i, j] then
                cantsignos [i] := cantsignos [i] + 1;
         end;
end;



procedure ordenarsignosporcant (var cantsignos:t_vecdatossignos; var vecsignos:t_vecsignos);
     var
        auxcant, i, j:integer;
        auxsigno:t_signos;
        continuar:boolean;
     begin
      for i := 1 to totalsignos do
       vecsignos [i] := (signoporindice (i));
        for i := 2 to totalsignos do
        begin
        j := i - 1;
        auxsigno := vecsignos [i];
        auxcant := cantsignos [i];
        continuar := (auxcant < cantsignos [j]);
        while (j >= 1) and continuar do
                begin
                cantsignos [j + 1] := cantsignos [j];
                vecsignos [j + 1] := vecsignos [j];
                j := j - 1;
                if j >= 1 then
                        continuar := (auxcant < cantsignos [j]);
                end;
        cantsignos [j + 1] := auxcant;
        vecsignos [j + 1] := auxsigno;
        end;
end;

procedure eliminarporindice (var listsigno:t_veclistasignos; var listnombres, listapellidos:t_vecnombresyapellidos;
                                var listdianac:t_vecdianac; var listmesnac:t_vecmesnac; var listanionac:t_vecanionac;
                                var listhombres:t_vecsexo; var tamaniolista:t_rangolista; indice:t_rangolista;
                                var datosenlista:boolean);
var
   j:integer;
begin
for j := indice to (tamaniolista - 1) do
    begin
    listsigno [j] := listsigno [j + 1];
    listnombres [j] := listnombres [j + 1];
    listapellidos [j] := listapellidos [j + 1];
    listdianac [j] := listdianac [j + 1];
    listmesnac [j] := listmesnac [j + 1];
    listanionac [j] := listanionac [j + 1];
    listhombres [j] := listhombres [j + 1];
    end;
if tamaniolista > 1 then
tamaniolista := tamaniolista - 1
else
datosenlista := false;
end;

begin          { ..::: BLOQUE PRINCIPAL DE CODIGO :::.. }
clrscr;
tamaniolista := 1;
for i := 1 to totalsignos do
        for j := 1 to totalsignos do
                listaincompsignos [i, j] := false;

writeln ('ingrese dia, mes y a¤o actual');
leerfechavalida (diahoy, meshoy, aniohoy);

repeat
clrscr;
writeln ('Ingrese la tarea que desea realizar por su numero de tarea');
writeln ('');
writeln ('1)  Agregar datos a la lista de clientes');
writeln ('2)  Corregir dato de la lista de clientes');
writeln ('3)  Eliminar dato de la lista de clientes');
writeln ('4)  Imprimir por pantalla la lista de clientes');
writeln ('5)  Cargar incompatibilidades para los signos');
writeln ('6)  Imprimir por pantalla las incompatibilidades de los signos');
writeln ('7)  Armar parejas posibles para cliente de la lista');
writeln ('8)  Armar parejas posibles para cliente externo a la lista');
writeln ('9)  Imprimir signos ordenados por cantidad de incompatibilidades');
writeln ('10)  Imprimir signos ordenados por el Nø de clientes registrados de dicho signo');
writeln ('11) Corregir la fecha actual');
writeln ('12) Salir del programa');
writeln ('');
readln (tarea);

        if (tarea = 1) then
                repeat
                clrscr;
                leerdatoscliente (listnombres [tamaniolista], listapellidos [tamaniolista], listdianac [tamaniolista],
                                  listmesnac [tamaniolista], listanionac [tamaniolista], listsigno [tamaniolista],
                                  listhombres [tamaniolista], diahoy, meshoy, aniohoy);
                ordenarultimoporsign (listsigno, listnombres, listapellidos, listdianac, listmesnac, listanionac,
                                      listhombres, tamaniolista);
                datosenlista := true;
                writeln ('desea ingresar otro dato? S/N');
                validacionSN (sino);
                if (sino = 's') then
                        tamaniolista := (tamaniolista + 1);
                until (sino = 'n') or (tamaniolista=maxlista)
        else

        if (tarea=2) then
                begin
                clrscr;
                if datosenlista then
                        begin
                        repeat
                        writeln ('ingrese el indice del cliente que desea modificar');
                        leerindicevalido (indice, tamaniolista);
                        writeln ('¨Este es el cliente que desea modificar? (s/n)');
                        writeln (indice,') ',listapellidos [indice],', ',listnombres [indice],' ',
                                 listdianac [indice],'/',listmesnac [indice],'/',listanionac [indice],' ',
                                 imprimirsigno (listsigno [indice]));
                        validacionSN (sino);
                            if (sino= 'n') then
                               begin
                                 Writeln ('¨Desea salir al men£? ("s" para salir, otra tecla para seguir)');
                                 readln (salir);
                              end
                        until (sino = 's') or (salir='s') or (salir='S');

                        if (sino='s') then
                        begin
                        leerdatoscliente (listnombres [indice], listapellidos [indice], listdianac [indice],
                                          listmesnac [indice], listanionac [indice], listsigno [indice], listhombres [indice],
                                          diahoy, meshoy, aniohoy);
                        ordmedporsign (listsigno, listnombres, listapellidos, listdianac, listmesnac, listanionac, listhombres,
                                       indice, tamaniolista);
                        writeln ('Pulse enter para volver al menu');
                        readln ;
                        end;
                        end
                else
                        begin
                        writeln ('no hay ningun dato en la lista, presione enter para volvar al menu');
                        readln ;
                        end;
        end
        else
        if (tarea = 3) then
        begin
                clrscr;
                if datosenlista then
                        begin
                        repeat
                        writeln ('ingrese el indice del cliente que desea eliminar');
                        leerindicevalido (indice, tamaniolista);
                        writeln ('¨Este es el cliente que desea eliminar? (s/n)');
                        writeln (indice,') ',listapellidos [indice],', ',listnombres [indice],' ',
                                 listdianac [indice],'/',listmesnac [indice],'/',listanionac [indice],' ',
                                 imprimirsigno (listsigno [indice]));
                        validacionSN (sino);
                            if (sino= 'n') then
                               begin
                                 Writeln ('¨Desea salir al men£? ("s" para salir, otra tecla para seguir)');
                                 readln (salir);
                              end
                        until (sino = 's') or (salir='s') or (salir='S');
                        if (sino = 's') then
                        begin
                        eliminarporindice (listsigno, listnombres, listapellidos, listdianac, listmesnac,
                                          listanionac, listhombres, tamaniolista, indice, datosenlista);
                        writeln ('Pulse enter para volver al menu');
                        readln ;
                        end;
                end
                else
                        begin
                        writeln ('no hay ningun dato en la lista, presione enter para volvar al menu');
                        readln ;
                        end;

        end
        else
        if (tarea = 4) then
                begin
                clrscr;
                if datosenlista then
                begin
                for i := 1 to tamaniolista do
                begin
                        writeln (i,') ',listapellidos [i],', ',listnombres [i],' ',listdianac [i],'/',listmesnac [i],'/',
                        listanionac [i],' ',imprimirsigno (listsigno [i]));
                        if ((i + 1) mod lineasdepantalla = 0) then {hace una pausa cuando se termina la pantalla para no
                                                                    perder datos,
                                                                    uso i+1 para dejar lugar a la linea del write}
                        begin
                        write ('pulse enter para continuar');
                        readln ;
                        end;
                end;
                writeln ('pulse enter para volver al menu');
                readln ;
                end
                else
                        begin
                        writeln ('no hay ningun dato en la lista, presione enter para volvar al menu');
                        readln ;
                        end;
                end
        else
        if (tarea = 5) then
        begin
                clrscr;
                for i := 1 to totalsignos do
                begin
                writeln ('desea ingresar incompatibilidades para el signo ',imprimirsigno (signoporindice (i)),' ? S/N');
                writeln ('si ingresa un signo que ya esta marcado como incompatible, este pasara a ser compatible');
                validacionSN (sino);
                while (sino = 's') do
                        begin
                        writeln ('actualmente las incompatibilidades del signo son: ');
                        for j := 1 to totalsignos do
                            if listaincompsignos [i, j] then
                            write (imprimirsigno (signoporindice (j)),' ');
                        writeln ('');
                        Writeln ('Ingrese el signo');
                        leersigno (signo);
                        listaincompsignos [i, (ord(signo) + 1)] := not listaincompsignos [i, (ord(signo) + 1)];
                        writeln ('desea cargar otro para ',imprimirsigno (signoporindice (i)),'? S/N');
                        validacionSN (sino);
                        end;
                end;
                writeln ('pulse enter para volver al menu');
                readln ;
        end
        else
        if (tarea = 6) then
        begin
                clrscr;
                for i := 1 to totalsignos do
                begin
                write ('Las incompatibilidades del signo ',imprimirsigno (signoporindice (i)),' son: ');
                        for j := 1 to totalsignos do
                        if listaincompsignos [i, j] then
                        write (imprimirsigno (signoporindice (j)),' ');
                writeln ('');
                end;
                writeln ('pulse enter para volver al menu');
                readln ;
        end
        else
        if (tarea = 7) then
        begin
                clrscr;
                if datosenlista then
                begin
                repeat
                contadorlineas := 0;
                writeln ('ingrese el indice del cliente que desea emparejar');
                leerindicevalido (indice, tamaniolista);
                writeln ('este es el cliente que desea emparejar? S/N');
                writeln (indice,') ',listapellidos [indice],', ',listnombres [indice],' ',listdianac [indice],'/',
                         listmesnac [indice],'/',listanionac [indice],' ',imprimirsigno (listsigno [indice]));;
                validacionSN (sino);
                until (sino = 's');
                for i := 1 to totalsignos do
                        begin
                        if not (listaincompsignos [(ord(listsigno [indice]) + 1), i]) then
                        begin
                                busquedarangosigno (signoporindice (i), tamaniolista, cotainf, cotasup, listsigno, validante);
                                if validante then
                                for j := cotainf to cotasup do
                                begin
                                        if (listhombres [indice] <> listhombres [j])
                                            and (listapellidos [indice] <> listapellidos [j]) then
                                                begin
                                                writeln (j,') ',listapellidos [j],', ',listnombres [j],' ',listdianac [j],'/',
                                                         listmesnac [j],'/',listanionac [j],' ',imprimirsigno (listsigno [j]));
                                                contadorlineas := contadorlineas + 1;
                                                if ((contadorlineas+1) mod lineasdepantalla) = 0 then
                                                        begin
                                                        writeln ('pulse una tecla para continuar');
                                                        readln ;
                                                        clrscr;
                                                        end;
                                                end;
                                end;
                        end;

                        end;
                writeln ('pulse enter para volver al menu');
                readln ;
                end
                else
                        begin
                        writeln ('no hay ningun dato en la lista, presione enter para volvar al menu');
                        readln ;
                        end;
        end
        else
        if (tarea = 8) then
        begin
                clrscr;
                contadorlineas := 0;
                if datosenlista then
                begin
                writeln ('ingrese los datos del cliente que desea emparejar');
                leerdatoscliente (nombre, apellido, dianac, mesnac, anionac, signo, sexo, diahoy, meshoy, aniohoy);
                for i := 1 to totalsignos do
                        if not (listaincompsignos [(ord(signo) + 1), i]) then
                        begin
                                busquedarangosigno (signoporindice (i), tamaniolista, cotainf, cotasup, listsigno, validante);
                                if validante then
                                for j := cotainf to cotasup do
                                        if (sexo <> listhombres [j]) and (apellido <> listapellidos [j]) then
                                        begin
                                        writeln (j,') ',listapellidos [j],', ',listnombres [j],' ',listdianac [j],'/',
                                                 listmesnac [j],'/',listanionac [j],' ',imprimirsigno (listsigno [j]));
                                        contadorlineas := contadorlineas + 1;
                                                if ((contadorlineas+1) mod lineasdepantalla) = 0 then
                                                        begin
                                                        writeln ('pulse enter para continuar');
                                                        readln ;
                                                        clrscr;
                                                        end;
                                        end;
                        end;
                writeln ('pulse enter para volver al menu');
                readln ;
                end
                else
                        begin
                        writeln ('no hay ningun dato en la lista, presione enter para volvar al menu');
                        readln ;
                        end;
        end
        else
        if (tarea = 9) then
        begin
                clrscr;
                contarsignosporincomp (listaincompsignos, cantsignos);
                ordenarsignosporcant (cantsignos, vecsignos);
                for i := totalsignos downto 1 do
                writeln (imprimirsigno (vecsignos [i]),' ',cantsignos [i]);
                writeln ('pulse enter para volver al menu');
                readln ;
        end
        else
        if (tarea = 10) then
                begin
                clrscr;
                if datosenlista then
                        begin
                        for i := 1 to totalsignos do
                        begin
                                busquedarangosigno (signoporindice (i), tamaniolista, cotainf, cotasup, listsigno, validante);
                                if validante then
                                begin
                                cantsignos [i] := (cotasup - cotainf + 1);
                                end
                                else
                                cantsignos [i] := 0;
                        end;
                        ordenarsignosporcant (cantsignos, vecsignos);
                        for i := totalsignos downto 1 do
                        begin
                        writeln (imprimirsigno (vecsignos [i]),' ',cantsignos [i]);
                        end;
                writeln ('pulse enter para volver al menu');
                readln ;
                end
                else
                        begin
                        writeln ('no hay ningun dato en la lista, presione enter para volvar al menu');
                        readln ;
                        end;
                end
        else
        if (tarea = 11) then
        begin
                clrscr;
                writeln ('si corrige la fecha, se perderan los datos que pasen a ser invalidos por edad');
                writeln ('seguro que desea corregir la fecha? S/N');
                validacionSN (sino);
                if (sino = 's') then
                begin
                writeln ('ingrese la fecha actual');
                leerfechavalida (diahoy, meshoy, aniohoy);
                if datosenlista then
                for i := 1 to tamaniolista do
                    if (edad (listdianac [i], listmesnac [i], listanionac [i], diahoy, meshoy, aniohoy) > edadmaxima) or
                       (edad (listdianac [i], listmesnac [i], listanionac [i], diahoy, meshoy, aniohoy) < edadminima) then
                       eliminarporindice (listsigno, listnombres, listapellidos, listdianac, listmesnac,
                                          listanionac, listhombres, tamaniolista, i, datosenlista);
                end;
        end
        else
        if (tarea <> 12) then
        begin
                clrscr;
                writeln ('esa tarea no existe, pulse enter para volver al menu');
                readln ;
        end;
until (tarea = 12);
end.
