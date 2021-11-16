Program materias;
{----------DECLARACIONES----------}
USES
    crt;
const
     MAXMATERIAS = 256;
     CANTINDICES = 3;
     MAXRENGLONES = 25;
     TAG1 = 8; {tag <codigo>}
     TAG2 = 8; {tag <nombre>}
     TAG3 = 10; {tag <profesor>}
     TAG4 = 5; {tag <dia>}
     TAG5 = 14; {tag <horaComienzo>}
     TAG6 = 9; {tag <horaFin>}
     TAG7 = 6; {tag <aula>} 
type
    tr_materia = record cod : string[7];
                        nom : string[40];
                        prof : string[20];
                        dia : string[9];
                        horac : string[4];
                        horaf : string[4];
                        aula : string [3];
                        end;
    tr_indice = record num : integer;
                       dat : string[40];
                       end;
    ta_materias = file of tr_materia;
    tat_materias = text;
    tv_indice = array [1..MAXMATERIAS] of tr_indice;
    {utilizamos un unico tipo de vector para los indices, lo que nos facilita los procedmientos de generacion de indices
    finales, ya que el orden de importancia se define por el orden de entrada al procedimiento}
    tv_indicefin = array [1..MAXMATERIAS] of integer;
    tv_ordindices = array [1..CANTINDICES] of integer;
var
   amaterias : ta_materias;
   atmaterias : tat_materias;
   indnom, inddia, indcod : tv_indice;
   tarea, tamlista : integer;

{-------------PROCEDURES--------------}

function validacionSN : char;
{valida una respuesta del usuario, afirmativa o negativa}
var
     aux:char;
   begin
     aux:='a';
     while (aux<>'s') and (aux<>'n') do
      begin
      readln (aux);
      if (aux<>'s') and (aux<>'n') then
      writeln ('respuesta invalida, por favor intente de nuevo');
      end;
   validacionSN:=aux;
end;

function diaanum (dia:string) :string;
{transforma un dia en su valor numerico, para que el ordenador de indices string no los ordene alfabeticamente.
De todos modos es string ya que los indices asi lo piden}
begin
if (dia='domingo') or (dia='Domingo') or (dia= 'DOMINGO') then
	diaanum:='1'
else
if (dia='Lunes') or (dia='LUNES') or (dia='lunes') then
	diaanum:='2'
else
if (dia='martes') or (dia='Martes') or (dia='MARTES') then
	diaanum:='3'
else
if (dia='miercoles') or (dia='Miercoles') or (dia='MIERCOLES') then
	diaanum:='4'
else
if (dia='jueves') or (dia='Jueves') or (dia='JUEVES') then
	diaanum:='5'
else
if (dia='viernes') or (dia='Viernes') or (dia='VIERNES') then
	diaanum:='6'
else
if (dia='sabado') or (dia='Sabado') or (dia='SABADO') then
	diaanum:='7'
else
diaanum:='8'
end;

procedure validarcod (cod:string; var valido:boolean);
{verifica si un valor dado es un codigo valido}
var
   punto:byte;
   aux1:string;
   aux2, i:integer;
begin
punto:= pos (cod, '.');
if (punto <> 0) then
   begin
   aux1 := copy (cod, 1, (punto - 1));
   val (aux1, aux2, i);
   if (i=0) and (aux2>60) and (aux2<79) then {condiciones sacadas de los codigos de los departamentos de ingenieria}
      begin
      aux1 := copy (cod, (punto + 1), (length(cod) - punto));
      val (aux1, aux2, i);
      if (i=0) and (aux2>0) and (aux2<100) then
         valido := true
      else
         begin
         valido := false;
         if i=0 then
         writeln ('el codigo de materia no puede ser menor que 1 no mayor que 99')
         else
         writeln ('el codigo de materia tiene que ser numerico');
         end;
      end
   else
   begin
   valido := false;
   if i=0 then
      writeln ('el codigo de departamento debe estar entre 61 y 78')
   else
       writeln ('el codigo de departamento tiene que ser numerico');
   end;
   end
else
if (cod='') then
valido := true {si no, no se podria cargar un parametro de bsuqueda sin codigo}
else
begin
valido := false;
writeln ('el formato del codigo debe ser XX.YY');
end;
end;

function leercodigo : string;
{valida un codigo que carga el usuario}
var
   aux:string;
   corte:boolean;
begin
repeat
readln (aux);
validarcod (aux, corte);
if not corte then
writeln ('no se interpreta ',aux,' como un codigo valido, intente de nuevo');
until corte;
end;

function cargarcodigo (cod:string) :string;
{valida un codigo que se esta por cargar}
var
   valido: boolean;
begin
validarcod (cod, valido);
if valido then
   cargarcodigo := cod
else
   begin
   writeln ('no se interpreta ',cod,' como un codigo valido, por favor cargue uno nuevo');
   cargarcodigo := leercodigo;
   end;
end;

procedure validarhora (hora:string; var valido:boolean);
var
   aux1:string;
   aux2, i : integer;
begin
if length(hora)=4 then
   begin
   aux1 := copy (hora, 1, 2);
   val (aux1, aux2, i);
   if (i=0) and (aux2>=0) and (aux2<24) then
      begin
      aux1 := copy (hora, 3, 2);
      val (aux1, aux2, i);
      if (i=0) and (aux2=0) and (aux2<60) then
         valido:=true
      else
          begin
          writeln (aux1,' no es una cantidad valida de minutos');
          valido:=false;
          end;
      end
   else
       begin
       writeln (aux1,' no es una cantidad valida de horas (formato 24hs)');
       valido:= false;
       end;
end
else
if (hora='') then
valido:=true {valida un parametro de busqueda vacio}
else
    begin
    writeln ('utilize el formato de horario HHMM');
    valido:= false;
    end;
end;

function leerhora : string;
var
   aux:string;
   corte:boolean;
begin
repeat
readln (aux);
validarhora (aux, corte);
if not corte then
   writeln (aux,' no corresponde a una hora valida, por favor intente nuevamente');
until corte;
leerhora:=aux;
end;

function cargahora (hora:string) : string;
var
   aux:integer;
   valido:boolean;
begin
validarhora (hora, valido);
if valido then
cargahora := hora
else
begin
writeln (hora,' no corresponde a una hora valida, por favor cargue una nueva');
cargahora := leerhora;
end;
end;

function leerdia : string;
var
   aux, dia:string;
   corte:boolean;
begin
repeat
readln (dia);
aux:=diaanum(dia);
if (aux<>'8') then
corte:=true
else
if dia='' then
leerdia := ''
else
begin
writeln ('dia invalido, intente nuevamente');
corte:=false;
end;
until corte;
leerdia:=dia;
end;

function cargardia (dia:string) : string;
var
aux:string;
begin
aux:=diaanum(dia);
if aux<>'8' then
cargardia:=dia
else
begin
writeln ('dia invalido, cargue uno nuevo');
cargardia:= leerdia;
end;
end;
Procedure leerregistro (var reg:tr_materia);
{lee un registro completo de una materia}
begin
      writeln ('ingrese el codigo de la materia');
      reg.cod := leercodigo;
      writeln ('ingrese el nombre de la materia');
      readln (reg.nom);
      writeln ('ingrese el nombre del profesor');
      readln (reg.prof);
      writeln ('ingrese el dia de la clase');
      reg.dia := leerdia;
      writeln ('ingrese el horario de comienzo de la clase (formato hhmm)');
      reg.horac := leerhora;
      writeln ('ingrese el horario de fin de la clase (formato hhmm)');
      reg.horaf := leerhora;
      writeln ('ingrese el aula de la clase');
      readln (reg.aula);
end;

function buscarpos (var indice:tv_indice; busqueda, n:integer) : integer;
{busca un puntero especifico dentro de un indice, para hacer las comparaciones para el ordenamiento}
var min, max, pos: integer;
begin
min:=1;
max:=n;
pos:= n div 2;
while (pos>0) and (pos<n) and (indice[pos].num<>busqueda) do
	if indice[pos].num<busqueda then
	begin
	min := pos + 1;
	pos := pos + ((max - pos) div 2);
	end
	else
	begin
	max:=pos-1;
	pos := pos - ((pos - min) div 2);
	end;
if (pos<=0) or (pos>=n) then
buscarpos := 0
else
buscarpos := pos;
end;

procedure ordult (var indice:tv_indice; n:integer);
{ordena el ultimo elementro agregado al indice, por insercion}
var i:integer;
    corte:boolean;
    aux:tr_indice;
begin
if n>1 then
begin
i:=n-1;
aux:=indice[n];
corte:=indice[n].dat<indice[i].dat;
while (i>0) and corte do
begin
indice[i+1] := indice [i];
dec (i);
if i>0 then
corte:= indice[i].dat > aux.dat;
end;
indice [i+1] := aux;
end;
end;


procedure generar1 (var indice:tv_indice; var indicefin:tv_indicefin;
n:integer);
{genera un indice final a partir de un solo indice inicial}
var i:integer;
begin
for i:=1 to n do
indicefin[i]:= indice[i].num;
end;

Procedure Generar2 (var indice1, indice2:tv_indice; var indicefin:tv_indicefin; n:integer);
{genera un indice final a partir de dos indices iniciales. Como los dos indices tienen la misma estructura, se puede variar el
orden de entrada y eso varia el ordenamiento final}
var aux1, aux2, pos, i:integer;
corte:boolean;
begin
indicefin[1] := indice1[1].num;
for i:=2 to n do
begin
pos:=i - 1;
corte := indice1[pos].dat=indice1[i].dat;{utilizamos igualdad ya que es el unico caso en el que puede hacer falta "desempatar"
con los suscesivos parametros de ordenamiento. si no se da la igualdad, al estar el indice ordenado, no hace falta otro
control}
while (pos>0) and corte do
begin
aux1 := buscarpos (indice2, indice1[i].num, n);
aux2 := buscarpos (indice2, indice1[pos].num, n);
if (aux1 = 0) or (aux2 = 0) then
	begin
writeln ('hubo un error en la generacion de indices, no se puede continuar la operacion. Se recomienda reiniciar el programa');
	corte := false;
	{es una precaucion de improbable utilidad, por como se generan los indices, no es posible que haya una posicion de memoria en
        un indice y no en otro. De todos modos, para que el subprograma sea modular, la agregamos}
	end
	else
if indice2[aux2].dat > indice2[aux1].dat then
	begin
	indicefin[pos+1] := indicefin [pos];
	dec (pos);
	corte := indice1[pos].dat=indice1[i].dat;
	end
	else
	corte := false;
end;
indicefin[pos+1]:=indice1[i].num;
end;
end;

Procedure Generar3 (var indice1, indice2, indice3:tv_indice; var indicefin:tv_indicefin; n:integer);
{idem generar2 pero con 3 indices iniciales}
var aux1, aux2, pos, i:integer;
corte:boolean;
begin
indicefin[1] := indice1[1].num;
for i:=2 to n do
begin
pos:=i - 1;
corte := indice1[pos].dat=indice1[i].dat;
while (pos>0) and corte do
	begin
	aux1 := buscarpos (indice2, indice1[i].num, n);
	aux2 := buscarpos (indice2, indice1[pos].num, n);
	if (aux1=0) or (aux2=0) then
	begin
writeln ('hubo un error en la generacion de indices, no se puede continuar la operacion. Se recomienda reiniciar el programa');
	corte := false;
	{es una precaucion de improbable utilidad, por como se generan los indices, no es posible que haya una posicion de memoria en
        un indice y no en otro. De todos modos, para que el subprograma sea modular, la agregamos}
	end
	else
	if indice2[aux2].dat > indice2[aux1].dat then
	begin
	indicefin[pos+1] := indicefin [pos];
	dec (pos);
	corte := indice1[pos].dat=indice1[i].dat;
	end
	else
	if indice2[aux2].dat = indice2[aux1].dat then
		begin
		aux1 := buscarpos (indice3, indice1[i].num, n);
		aux2 := buscarpos (indice3, indice1[pos].num, n);
		if (aux1=0) or (aux2=0) then
		begin
writeln ('hubo un error en la generacion de indices, no se puede continuar la operacion. Se recomienda reiniciar el programa');
		corte := false;
		{es una precaucion de improbable utilidad, por como se generan los indices, no es posible que haya una posicion de memoria
                en un indice y no en otro. De todos modos, para que el subprograma sea modular, la agregamos}
		end
		else
		if indice3[aux2].dat > indice3[aux1].dat then
		begin
		indicefin[pos+1] := indicefin [pos];
		dec (pos);
		corte := indice1[pos].dat=indice1[i].dat;
		end
		else
		corte:= false;
		end
	else
	corte := false;
	end;
indicefin[pos+1]:=indice1[i].num;
end;
end;

function leerordenvalido (orden:tv_ordindices; n:integer): integer;
{lee un valor que se desea usar para un ordenamiento, valida que no se haya ingresado previamente}
var control:boolean;
    i, aux:integer;
    sino:char;
begin
repeat
sino:='n';
control := true;
writeln ('ingrese el ordenamiento (materia, codigo, dia)');
writeln ('(materia=1 dia=2 codigo=3)');
readln (aux);
if (aux>=1) and (aux<=CANTINDICES) then
begin
	for i:=1 to n do
		if orden [i] = aux then control:= false;
	if control then
	leerordenvalido := aux
	else
	writeln ('ya se cargo ese ordenamiento');
end
else
begin
writeln ('no se reconoce ',aux,' como un orden valido, desea intentar de nuevo?');
sino := validacionSN;
if sino='n' then leerordenvalido:= 0;
end;
until sino='n';
end;

Procedure Prioridades (var Orden:tv_ordindices; var i:integer);
var
	sino:char;
begin
writeln ('desea ingresar un ordenamiento especifico?');
sino:= validacionSN;
while (i<CANTINDICES) and (sino='s') do
      begin
      orden [i+1] := leerordenvalido (orden, i);
      if (orden [i+1] <> 0) then
      inc (i);
      if (i<CANTINDICES) then
         begin
         writeln ('desea ingresar un ordenamiento posterior?');
         sino:=validacionSN;
         end;
      end;
end;

Procedure Genindicefin (var indnom, inddia, indcod:tv_indice; var indfinal:tv_indicefin; var orden:tv_ordindices;
                       i,tamlista:integer);
var
	j:integer;
begin
case i of
     0 : for j:=1 to tamlista do indfinal[j]:=j - 1;
     1 : case orden[1] of
              1 : generar1 (indnom, indfinal, tamlista);
              2 : generar1 (inddia, indfinal, tamlista);
              3 : generar1 (indcod, indfinal, tamlista);
         end;
     2 : case orden[1] of
              1 : case orden[2] of
                       2 : generar2 (indnom, inddia, indfinal, tamlista);
                       3 : generar2 (indnom, indcod, indfinal, tamlista);
                  end;
              2 : case orden[2] of
                       1 : generar2 (inddia, indnom, indfinal, tamlista);
                       3 : generar2 (inddia, indcod, indfinal, tamlista);
                  end;
              3 : case orden [2] of
                       1 : generar2 (indcod, indnom, indfinal, tamlista);
                       2 : generar2 (indcod, inddia, indfinal, tamlista);
                  end;
         end;
     3 : case orden[1] of
              1 : case orden[2] of
                       2 : generar3 (indnom, inddia, indcod, indfinal, tamlista);
                       3 : generar3 (indnom, indcod, inddia, indfinal, tamlista);
                  end;
              2 : case orden[2] of
                       1 : generar3 (inddia, indnom, indcod, indfinal, tamlista);
                       3 : generar3 (inddia, indcod, indnom, indfinal, tamlista);
                  end;
              3 : case orden [2] of
                       1 : generar3 (indcod, indnom, inddia, indfinal, tamlista);
                       2 : generar3 (indcod, inddia, indnom, indfinal, tamlista);
                  end;
         end;
end;
end;

procedure cargaord (var indnom,inddia,indcod:tv_indice; var indfinal:tv_indicefin; tamlista:integer);
{pide un ordenamiento y genera un indice final para dicho ordenamiento}
var i:integer;
    orden:tv_ordindices;
begin
i:=0;
Prioridades (orden, i);
Genindicefin (indnom, inddia, indcod, indfinal, orden, i, tamlista);
end;

procedure imprpindice (var amaterias:ta_materias; var indicefin:tv_indicefin; tamlista:integer);
{imprime el archivo dat a partir de un ordenamiento dado}
var
reg:tr_materia;
i:integer;
begin
for i:=1 to tamlista do
begin
seek (amaterias, indicefin[i]);
read (amaterias, reg);
writeln (reg.cod,' ':5, reg.nom,' ':5,'prof. ',reg.prof,' ':5,reg.dia,' ':5,reg.horac,' ':5,reg.horaf,' ':5,reg.aula);
end;
end;

Procedure Carga (var amaterias:ta_materias; var indnom, inddia, indcod : tv_indice; var tamlista:integer);
{carga datos al archivo dat}
var
   reg:tr_materia;
   sino:char;
begin
seek (amaterias, tamlista);
sino:='s';
while (sino = 's') and (tamlista<MAXMATERIAS) do
      begin
      clrscr;
      leerregistro (reg);
      inc (tamlista);
      indnom[tamlista].num := tamlista - 1;
      indnom[tamlista].dat := reg.nom;
      inddia[tamlista].num := tamlista - 1;
      inddia[tamlista].dat := diaanum(reg.dia);
      indcod[tamlista].num := tamlista - 1;
      indcod[tamlista].dat := reg.cod;
      ordult (indnom, tamlista);
      ordult (inddia, tamlista);
      ordult (indcod, tamlista);
      write (amaterias, reg);
      writeln ('desea ingresar otra clase? (S/N)');
      sino := validacionSN;
      end;
if tamlista>=MAXMATERIAS then
   begin
   writeln ('se ha alcanzado el maximo posible de materias. Pulse enter para volver al menu');
   readln;
   end;
end;

procedure impxml(var amaterias:ta_materias; var indnom,
                      inddia, indcod:tv_indice;
                      var tamlista:integer);
{importa un archivo XML al archivo binario. Valida los campos a ingresar y se fija que no se exceda el tamaño logico de los
indices}
var reg:tr_materia;
    txt:tat_materias;
    c:string;
    dir:string;
begin
  clrscr;
  seek(amaterias,tamlista);
  writeln('ingrese la ruta del archivo XML');
  readln(dir);
  assign(txt,dir);
  {$I-}reset(txt);{$I+}
  if IOresult <> 0 then
	begin
	writeln ('no se puede cargar el archivo especificado, pulse enter para volver al menu');
	readln;
	end
  else
  begin
 if (tamlista<MAXMATERIAS) then
 begin
  readln(txt,c); {* LEE "<MATERIAS>"', LO HARµ UNA SOLA VEZ POR ARCH DE TEXTO *}
  readln(txt,c);
  while (c<>'</materias>') and (tamlista<MAXMATERIAS) do
      begin
      readln(txt,c);
      c:=copy(c,(TAG1 + 1),(length(c) - 2*TAG1 - 1));
      reg.cod:=cargarcodigo (c); writeln (reg.cod);
      readln(txt,c);
      reg.nom:=copy(c,(TAG2 + 1),(length(c) - 2*TAG2 - 1)); writeln(reg.nom);
      readln(txt,c);
      reg.prof:=copy(c,(TAG3 + 1),(length(c) - 2*TAG3 - 1)); writeln(reg.prof);
      readln(txt,c); {* LEE "<HORARIOS>" LO HARA UNA VEZ POR MATERIA *}
      readln(txt,c);
      while (c<>'</horarios>') and (tamlista<MAXMATERIAS) do
	begin
	readln(txt,c);
        c:=copy(c,(TAG4 + 1),(length(c) - 2*TAG4 -1));
        reg.dia:=cargardia (c); writeln (reg.dia);
        readln(txt,c);
        c:=copy(c,(TAG5 + 1),(length(c) - 2*TAG5 - 1));
        reg.horac:= cargahora (c); writeln(reg.horac);
        readln(txt,c);
        c:=copy(c,(TAG6 + 1),(length(c) - 2*TAG6 - 1));
        reg.horaf:=cargahora(c); writeln(reg.horaf);
        readln(txt,c);
        reg.aula:=copy(c,(TAG7 + 1),(length(c) - 2*TAG7 - 1));  writeln(reg.aula);
        readln(txt,c);
        readln(txt,c);
	inc(tamlista);
	indnom[tamlista].num:=tamlista-1;
	indnom[tamlista].dat:=reg.nom;
	inddia[tamlista].num:=tamlista-1;
	inddia[tamlista].dat:=diaanum(reg.dia);
	indcod[tamlista].num:=tamlista-1;
	indcod[tamlista].dat:=reg.cod;
	ordult(indnom,tamlista);
	ordult(inddia,tamlista);
	ordult(indcod,tamlista);
	write(amaterias,reg);
      end;
     readln(txt,c);
     readln(txt,c);
   end;
 end;
if tamlista >= MAXMATERIAS then
   begin
    writeln('se alcanzo el maximo de materias, se truncó el archivo, enter para continuar');
    readln;
    end
   else
    begin
    writeln('Datos cargados');
    readln;
    end;
close(txt);
end;
end;

procedure expxml(var amaterias:ta_materias; var indnom, inddia, indcod : tv_indice;
                  tamlista:integer);
{genera un archivo XML a partir del archivo binario con un ordenamiento especificado}
var
reg,regaux:tr_materia;
indfinal:tv_indicefin;
txt:tat_materias;
i:integer;
c,dir:string;

begin
  clrscr;
  writeln('ingrese la ruta del archivo XML que desea crear');
  readln(dir);
  assign(txt,dir);
  {$I-}rewrite(txt);{$I+}
  if IOresult<>0 then
	begin
	writeln ('no se puede generar dicho archivo, presione enter para volver al menu');
	readln;
	end
  else
  begin
  cargaord (indnom, inddia, indcod,indfinal,tamlista);
  writeln(txt,'<materias>');
  for i:=1 to tamlista do
    begin
    seek(amaterias, indfinal[i]);
    read(amaterias,reg);
    writeln(txt,'<materia>');
    write(txt,'<codigo>');
    write(txt,reg.cod); 
    writeln(txt,'</codigo>');
    write(txt,'<nombre>');
    write(txt,reg.nom); 
    writeln(txt,'</nombre>');
    write(txt,'<profesor>');
    write(txt,reg.prof); 
    writeln(txt,'</profesor>');
    writeln(txt,'<horarios>');
    writeln(txt,'<horario>');
    write(txt,'<dia>');
    write(txt,reg.dia); 
    writeln(txt,'</dia>');
    write(txt,'<horacomienzo>');
    write(txt,reg.horac); 
    writeln(txt,'</horacomienzo>');
    write(txt,'<horafin>');
    write(txt,reg.horaf); 
    writeln(txt,'</horafin>');
    write(txt,'<aula>');
    write(txt,reg.aula); 
    writeln(txt,'</aula>');
    writeln(txt,'</horario>');
    writeln(txt,'</horarios>');
    writeln(txt,'</materia>');
    end;
  writeln(txt,'</materias>');
close(txt);
writeln('el archivo de texto ha sido escrito');
readln;
end;
end;

Procedure ListMat (var amaterias:ta_materias; var indnom, inddia, indcod : tv_indice; tamlista:integer);
{lista por pantalla los datos del archivo binario a partir de un ordenamiento pedido}
var
   indfinal : tv_indicefin;
begin
clrscr;
cargaord (indnom, inddia, indcod, indfinal,tamlista);
imprpindice (amaterias, indfinal, tamlista);
writeln ('pulse enter para volver al menu');
readln;
end;

Procedure Repmat (var amaterias:ta_materias);
{filtra el archivo binario a partir de una serie de parametros de busqueda especificados por el usuario}
var
   reg, parametros:tr_materia;
   renglones:integer;
begin
seek (amaterias, 0);
renglones:=0;
writeln ('ingrese los parametros de busqueda (deje en blanco si no desea usar un campo)');
leerregistro (parametros);
while not eof(amaterias) do
begin
read (amaterias, reg);
if (parametros.cod='') or (reg.cod=parametros.cod) then
   if (parametros.nom='') or (reg.nom=parametros.nom) then
      if (parametros.prof='') or (reg.prof=parametros.prof) then
         if (parametros.dia='') or (reg.dia=parametros.dia) then
            if (parametros.horac='') or (reg.horac=parametros.horac) then
               if (parametros.horaf='') or (reg.horaf=parametros.horaf) then
                  if (parametros.aula='') or (reg.aula=parametros.aula) then
                     begin
                     writeln (reg.cod,' ':5, reg.nom,' ':5,'prof. ',reg.prof,' ':5,reg.dia,' ':5,reg.horac,' ':5,reg.horaf,' '
                     :5,reg.aula);
                     inc(renglones);
                     end;
if (renglones = MAXRENGLONES-2) then
   begin
   renglones := 0;
   writeln ('pulse enter para continuar');
   readln;
   clrscr;
   end;
end;
writeln ('pulse enter para volver al menu');
readln;
end;

procedure genindices (var amaterias:TA_materias; var indnom, india, indcod :tv_indice; var tamlista:integer);
{genera los indices del archivo binario. se utiliza al principio del programa cuando se re abre el archivo binario, si es que
se pudo re abrir}
var reg : tr_materia;
begin
tamlista := 0;
seek (amaterias,0);
while not eof(amaterias) and (tamlista<MAXMATERIAS) do
begin
read (amaterias,reg);
inc (tamlista);
indnom[tamlista].dat:=reg.nom;
inddia[tamlista].dat:=diaanum(reg.dia);
indcod[tamlista].dat:=reg.cod;
indnom[tamlista].num:=tamlista-1;
inddia[tamlista].num:=tamlista-1;
indcod[tamlista].num:=tamlista-1;
ordult (indnom, tamlista);
ordult (inddia, tamlista);
ordult (indcod, tamlista);
end;
if not eof(amaterias) then
begin
writeln ('no se completo la carga de datos, no se utilizaran todos');
writeln ('pulse enter para volver al menu');
readln;
end;
end;

procedure Menu (var tarea:integer);
{imprime el menu y solicita la eleccion de una tarea}
begin
clrscr;
writeln ('ingrese el numero de tarea que desea ejecutar');
writeln ('1) Carga de datos');
writeln ('2) Importar datos desde XML');
writeln ('3) Exportar datos a XML');
writeln ('4) Listar cursos');
writeln ('5) Buscar cursos');
writeln ('6) Salir');
readln (tarea);
end;

{-------------CODIGO PRINCIPAL------------}

begin
tamlista:=0;
assign (amaterias,'materias.dat');
{$I-}reset (amaterias);{$I+}
if (ioresult<>0) then
   begin
   rewrite (amaterias);
   end
else
    genindices (amaterias, indnom, inddia, indcod, tamlista);
repeat
Menu (tarea);
case tarea of
     1 : if tamlista<MAXMATERIAS then Carga (amaterias, indnom, inddia, indcod, tamlista)
     else
     begin
     writeln ('se ha excedido la capacidad de datos, no se pueden cargar mas, pulse enter para volver al menu');
     readln;
     end;
     2 : if tamlista<MAXMATERIAS then ImpXML (amaterias, indnom, inddia, indcod, tamlista)
     else
     begin
     writeln ('se ha excedido la capacidad de datos, no se pueden cargar mas, pulse enter para volver al menu');
     readln;
     end;
     3 : ExpXML (amaterias, indnom, inddia, indcod, tamlista);
     4 : Listmat (amaterias, indnom, inddia, indcod, tamlista);
     5 : Repmat (amaterias);
else
if (tarea <>6) then
begin
clrscr;
writeln ('no existe esa tarea, pulse enter para volver al menu');
readln;
end;
end
until (tarea = 6);
close (amaterias);
end.

