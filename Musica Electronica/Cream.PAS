PROGRAM creamfields;         {ENCABEZAMIENTO DEL PROGRAMA}

USES crt;  {LISTA DE UNIDADES EXTERNAS}

CONST  {DECLRACION DE CONSATANTES}

   maxlista=250;
   maxdj=30;
   maxtemas=20;
   maxlineas=30; {Cantidad maxima de lineas que apareceran en pantalla al momento de mostrar el listado de canciones}
   altovalor='zzzzzzzzz';
TYPE   {DECLRACION DE TIPOS DE VARIABLES}

   trango_lista=1..maxlista;
   trango_dj=1..maxdj;
   trango_temas=1..maxtemas;

   td_cancion=string[30];
   td_dj=string[20];

   tv_Lista=array[trango_lista] of td_cancion;     {Lista de temas}
   tv_Duracion=array[trango_lista] of word;        {Duracion de los temas en segundos}
   tv_VecesPasado=array[trango_lista] of byte;     {Cantidad de veces que se paso este tema}
   tv_Dj=array[trango_dj] of td_dj;                {Nombres de los DJ}
   tv_TiempoTotal=array[trango_dj] of word;        {Tiempo total que uso cada DJ para pasr temas en segundos}
   tv_Temas=array[trango_dj,trango_temas] of byte; {Guarda el indice del tema}


VAR    {DEFINICION DE VARIABLES}

   lista:tv_Lista;
   durac:tv_Duracion;
   veces:tv_VecesPasado;
   dj:tv_Dj;
   tiempo:tv_Tiempototal;
   temas:tv_Temas;
   DjTemaLargo:byte;
   TemaLargo:byte;


                      {DECLRACIONES DE SUBPROGARMAS INTERNOS}

procedure LimpiarListas (var lista:tv_Lista; var durac:tv_Duracion; var veces:tv_VecesPasado; var dj:tv_Dj;
                         var tiempo:tv_Tiempototal; var temas:tv_Temas);
  var
     i,j,k:byte;

  begin
    for i:= 1 to maxlista do
     begin
      lista[i]:=altovalor; durac[i]:=0; veces[i]:=0;
     end;
    for j:=1 to maxdj do
     begin
      dj[j]:=altovalor; tiempo[j]:=0;
       for k:=1 to maxtemas do
        begin
         temas[j,k]:=0;
        end;
     end;
  end;



procedure iniciartodo(var lista:tv_Lista; var durac:tv_Duracion; var veces:tv_VecesPasado; var dj:tv_Dj;
                      var tiempo:tv_Tiempototal; var temas:tv_Temas; var DjTemaLargo:byte; var TemaLargo:byte);
 Begin
  clrscr;
  DjTemaLargo:=1;
  TemaLargo:=1;
  LimpiarListas(lista,durac,veces,dj,tiempo,temas);
 end;




Function ValidaTema (var tiempo:word):boolean;
   begin
    if tiempo > 900 then
     ValidaTema:=false
    else
     ValidaTema:=true;
   end;



Procedure OrdenarCancion (var lista:tv_Lista; var durac:tv_Duracion);
  var
      i,j,k:byte;
      aux1:td_cancion;
      aux2:word;
  begin
   for k:=2 to maxlista do
    begin
     j:= k;
     i:= k-1;
     while (i>=1) do
      begin
       if (lista[j] < lista[i]) then
        begin
          aux1:=lista[j];      aux2:=durac[j];
          lista[j]:=lista[i];  durac[j]:=durac[i];
          lista[i]:=aux1;      durac[i]:=aux2;
          dec(j); dec(i);
        end
       else i:=0;
       end;
    end;
   end;




Procedure CargaLista (var lista:tv_Lista; var durac:tv_Duracion);
 var
      i:byte; fin:boolean; min,seg:byte; tiempo:word; sino:char;

 begin
     i:=1; fin:=false;
    writeln('');
    writeln('INSCRIPCION DE CANCIONES EN LA LISTA GENERAL');
    writeln('');
    while (i<=maxlista) and (not fin) do
     begin
      writeln ('Ingrese la duracion del tema:');
      writeln('Minutos:');
      readln(min);
      writeln('Segundos:');
      readln(seg);
      tiempo:= (min * 60) + seg;

        if validatema(tiempo) then
          begin
           durac[i]:=min*60+seg;
           writeln('Ingrese el nombre del tema');
           readln(lista[i]);
           writeln('La cancion se ingreso sactisfactoriamente');
           readln;
           inc(i)
          end
        else
         writeln('la duracion del tema no debe exeder los 15 minutos');
       writeln('¨Quiere seguir ingresando canciones? ( "s" para confirmar, otra tecla para terminar)');
       readln(sino);
       if (sino='s') then fin:=false
       else
        begin
        OrdenarCancion(lista,durac);
        writeln('');
        writeln('FIN DE INSCRIPCION DE CANCIONES EN LA LISTA GENERAL');
        writeln('');
        fin:=true;
        end;
     end;
   end;




function buscacancion (var cancion:td_cancion; var lista:tv_Lista):byte; {DEVUELVE EL INDICE DEL VECTOR LISTA}
 var
   menor,medio,mayor:byte; encontrado:boolean;

 begin
  encontrado:=false;
  menor:=1; mayor:=maxlista;
  repeat
    begin
     medio:=(menor+mayor) div 2;
     if (lista[medio] = cancion) then
      encontrado:=true
     else
      if(lista[medio] < cancion) then
       menor:=medio+1
      else
       mayor:=medio-1;
    end;
   until ((encontrado) or (mayor<menor));

   if encontrado then buscacancion:=medio
   else buscacancion:=0;
 end;




function buscacanciondj(var indicecancion:byte; indicedj:byte; var temas:tv_Temas):boolean;
var
i:byte; encontrado:boolean;

begin
  encontrado:=false;
  i:=1;

  repeat
      if (temas[indicedj,i]=indicecancion) then
        encontrado:=true
      else inc(i);
  until ((i>maxtemas) or (encontrado));

  if (encontrado) then buscacanciondj:=true
  else buscacanciondj:=false;
end;


procedure cancionmasgrande(var indicecancion:byte; var indicedj:byte; var DjTemaLargo:byte; var TemaLargo:byte;
                           var duracion:tv_Duracion);
 begin
  if (duracion[indicecancion]>duracion[TemaLargo]) then
   begin
    temalargo:=indicecancion;
    DjTemaLargo:=indicedj;
   end;
 end;


procedure GuardarCancion(var indicedj:byte; var j:byte; var cancion:td_cancion; var lista:tv_Lista; var durac:tv_Duracion;
                         var veces:tv_VecesPasado; var dj:tv_Dj; var tiempo:tv_Tiempototal; var temas:tv_Temas;
                         var DjTemaLargo:byte; var TemaLargo:byte);
 var
     indicecancion:byte;
 begin
     indicecancion:=buscacancion(cancion,lista);
     if (indicecancion=0) then
       Writeln('La cancion no se encuentra en el listado general de temas')
     else
       if (buscacanciondj(indicecancion,indicedj,temas)) then
         writeln('La cancion ya esta en el listado de este DJ')
       else
         begin
          cancionmasgrande(indicecancion,indicedj,DjTemaLargo,TemaLargo,durac);
          temas[indicedj,j]:=indicecancion;
          inc(veces[indicecancion]);
          tiempo[indicedj]:=tiempo[indicedj]+durac[indicecancion];
          writeln('Cancion guardada'); readln;
          inc(j);
         end;
 end;


procedure IngresarDj (var lista:tv_Lista; var durac:tv_Duracion; var veces:tv_VecesPasado; var dj:tv_Dj;
                      var tiempo:tv_Tiempototal; var temas:tv_Temas; var DjTemaLargo:byte; var TemaLargo:byte);

 var
      i,j:byte; findj,fintema:boolean; sino:char; cancion:td_cancion;
 begin
    i:=1; findj:=false;
    writeln('');
    writeln('INSCRIPCION DE DJs EN LA LISTA');
    writeln('');
    while (i<=maxdj) and (not findj) do
     begin
      writeln ('Ingrese el nombre del DJ');
      readln(dj[i]);
      j:=1; fintema:=false;
      while (j<=maxtemas) and (not fintema) do
       begin
          writeln ('Ingrese el nombre de la cancion');
          readln(cancion);
          GuardarCancion(i,j,cancion,lista,durac,veces,dj,tiempo,temas,DjTemaLargo,TemaLargo);
          writeln('¨Quiere seguir ingresando canciones para este DJ? ( "s" para confirmar, otra tecla para terminar)');
          readln(sino);
          if (sino='s') then fintema:=false
          else fintema:=true;

       end;
       Writeln ('Se termino de guardar las canciones para este DJ, presione ENTER para continuar.');
       readln;
       inc(i);
       writeln('¨Quiere seguir ingresando DJs? ( "s" para confirmar, otra tecla para terminar)');
       readln(sino);
       if (sino='s') then findj:=false
       else findj:=true;

     end;

    writeln('');
    writeln('FIN DE INSCRIPCION DE DJs EN LA LISTA (ENTER para continuar)');
    readln;

 end;


procedure brec;
 begin
  write('');
  write('Presione ENTER para continuar...');
  WRITE('');
  readln;
 end;


procedure djmastiempo (var dj:tv_Dj; var tiempo:tv_TiempoTotal);
 var
    djtiempo:td_dj;
    mastiempo:word;
    horas,minutos,segundos:byte;
    i:byte;
 begin
   djtiempo:='';
   mastiempo:=0;
   i:=1;
   repeat
    begin
     if (tiempo[i]>=mastiempo) then
      begin
       mastiempo:=tiempo[i];
       djtiempo:=dj[i];
      end;
     inc(i);
    end;
   until (i>maxdj) or (tiempo[i]=0);
   horas:=mastiempo div 3600;
   minutos:=(mastiempo - (horas * 3600)) div 60;
   segundos:=(mastiempo - (horas * 3600) - (minutos * 60));
   Writeln('El DJ que mas tiempo toco es: ',djtiempo,'. Con un tiempo de: ',horas,' Hrs ',minutos,' Min ',segundos,' Seg.');
   brec;
 end;



function temamastocado(var lista:tv_Lista; var veces:tv_VecesPasado):td_cancion;
 var
   i:byte;
   cancion:td_cancion;
   masveces:byte;
 begin
   i:=1;
   cancion:='';
   masveces:=0;
  repeat
   begin
    if(veces[i]>masveces) then
     begin
     cancion:=lista[i];
     masveces:=veces[i];
     end;
    inc(i);
   end;
  until (i>maxlista);
  temamastocado:=cancion;
 end;


procedure mostrarlista(var lista:tv_Lista);
 var
  i,contadorlineas:byte; vacio:boolean;
 begin
  i:=1;
  contadorlineas:=0;
  writeln('');
  writeln('LISTA GENERAL DE TEMAS:');
  writeln('');
  vacio:=false;
  while (i<=maxlista) and  (not vacio) do
   begin
    writeln(lista[i]);
    inc(contadorlineas);
    if (lista[i+1]=altovalor) then vacio:=true;
    if((contadorlineas + 1) mod maxlineas)=0 then
     begin
      writeln('Presione ENTER para continuar la lista...');
      readln;
      clrscr;
     end;
    inc(i);
   end;

  writeln('');
  writeln('FIN DE LA LISTA GENERAL DE TEMAS.');
  writeln('');
  brec;
 end;



procedure temamaslargo(var lista:tv_Lista; var durac:tv_Duracion; var dj:tv_Dj; var DjTemaLargo:byte; var TemaLargo:byte);
 var
  minutos,segundos:byte;
 begin
  minutos:=durac[TemaLargo] div 60;
  segundos:=durac[TemaLargo]- (minutos * 60);
  Writeln('El tema mas largo que se tocara es: ',lista[TemaLargo],' ,con una duracion de ',minutos,' Min ',segundos,
         ' Seg, por el DJ ',dj[DjTemaLargo]);
  brec;
 end;


         (************** BLOQUE PRINCIPAL DE CODIGO *************)
BEGIN
 iniciartodo(lista,durac,veces,dj,tiempo,temas,DjTemaLargo,TemaLargo);
 cargalista(lista,durac);
 IngresarDj(lista,durac,veces,dj,tiempo,temas,DjTemaLargo,TemaLargo);
 djmastiempo(dj,tiempo);
 writeln('El tema mas tocado sera: ',temamastocado(lista,veces)); brec;
 mostrarlista(lista);
 temamaslargo(lista,durac,dj,DjTemaLargo,TemaLargo);
END.