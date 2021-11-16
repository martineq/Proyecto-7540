Program TP2_Empleados;

uses crt,dos;

const{los valores están de acuerdo a nuestros archivos de prueba}
     max_provincia=12;{2000}
     max_aumento=10;  {5000}

     emp_aum=5; {la cantidad de empleados con m s aumento que queremos
                 mostrar en el punto c}

type
    T_Dias = (Lunes,Martes,Miercoles,Jueves,Viernes,Sabado,Domingo);
    T_Dias_Trabajo = Set of T_Dias;
    T_rango = 1..max_provincia;
    T_rango_aumento=1..max_aumento;
    TREG_EMP = Record
               Legajo: Longint;
               Nombre: String[50];
               FechaIngreso: String[8];
               Domicilio_Calle: String[50];
               Domicilio_Localidad: String[15];
               Domicilio_Provincia: String[15];
               Telefono: String[15];
               Dias_Trabajo: T_Dias_Trabajo;
               Sueldo: real;
               end;
    T_Arch_Emp = File of Treg_Emp;

    TREG_Aum =  record
                legajo: Longint;
                Porcentaje: Real;
                end;

    T_ARCH_Aum = File of TREG_Aum;

    TREG_Indice = Record
                  Localidad: String[15];
                  Legajo: Longint;
                  Prr: word;
                  end;

    T_Arch_List= text;
    Tvec_indice = Array[T_rango] of TREG_Indice;
    Tvec_aux = Array[T_Dias] of boolean;
    Tvec_Aumento = Array[T_rango_aumento] of TREG_Aum;

    {para el punto c}
    Treg_indice_aum = record
                    	    aum:real;
			    prr:word;
                      end;
    TVec_indice_aum = array [T_rango_aumento] of Treg_indice_aum;

Procedure Leer(Var F: T_Arch_emp; var R: TREG_Emp; var Fin: boolean);
begin
     Fin:=Eof(F);
     If (not fin) then
        read(F,R);
end;

Procedure Intercambiar_Dias(Var Archivo: T_ARCH_Emp);

var
   Dia: T_Dias;
   Dia_Trabajo_aux: T_Dias_trabajo;
   Registro: TREG_Emp;
   Fin: Boolean;

Begin
     Reset(Archivo);

     Leer(Archivo, registro, fin);

     While (not fin) do
           begin
                Dia_Trabajo_aux:=[];

                for dia:=Lunes to Domingo do
                    begin
                         if (not (dia in registro.dias_trabajo)) then
                            dia_trabajo_aux:=dia_trabajo_aux + [Dia];
                    end;

                registro.dias_trabajo:=Dia_trabajo_aux;
                seek(archivo,filepos(archivo)-1);{para que lo guarde en el que lee, y no en el siguiente}
                write(archivo, registro);

                leer(Archivo, registro, fin);
           end;

     Close(Archivo);
end;

Procedure Inicialar_Boolean(Var vector: Tvec_aux);
var
   dia: T_Dias;

Begin
     For dia:=Lunes to Domingo do
         Vector[Dia]:=False;
end;

Function chequeo (Vector: Tvec_Aux):Boolean;
var
   Dia:T_Dias;
   contador: byte;

begin
     Contador:=0;

     For dia:=Lunes to domingo do
         begin
              if vector[dia]=true then
                 inc(contador);
         end;

     if contador = 7 then
        chequeo:=True
     else
         chequeo:=false;
end;

Function convierte(dia:T_Dias):String;

begin

     case dia of
     Lunes:             Convierte:='Lunes';
     Martes:            Convierte:='Martes';
     Miercoles:         Convierte:='Miercoles';
     Jueves:            Convierte:='Jueves';
     Viernes:           Convierte:='Viernes';
     Sabado:            Convierte:='Sabado';
     Domingo:           Convierte:='Domingo';
     end;
end;

Procedure Dia_Libre(var Archivo: T_Arch_emp);

var
   registro: TReg_Emp;
   Fin: Boolean;
   Dia: T_Dias;
   Vec: Tvec_Aux;
   Contador: byte;

Begin
     Reset(Archivo);
     Contador:=0;
     Inicialar_Boolean(Vec);
     Leer(Archivo, registro, fin);

     While ((not fin) and (not chequeo(vec))) do
           begin
                For dia:=Lunes to Domingo do
                    begin
                         if (dia in registro.Dias_Trabajo) then
                            vec[Dia]:=true;
                    end;

                Leer(archivo, registro, fin);
           end;

     Writeln('DIAS NO TRABAJADOS');

     for dia:=Lunes to Domingo do
         begin
              If (vec[Dia] = false) then
                 writeln(convierte(dia))
              else
                  inc(contador);
         end;

     If contador=7 then
        writeln('TODOS LOS DIAS SE TRABAJAN');

     Close(Archivo);

End;

Procedure Interordena(var Vector: Tvec_indice; n:integer);
var
   i,j,pivot: integer;
   aux: treg_indice;
begin
     for i:=1 to n-1 do
     begin
          pivot:=i;
          for j:=i+1 to n do
             if (Vector[pivot].Localidad > Vector[j].Localidad) or
                ( (Vector[pivot].Localidad = Vector[j].Localidad) and
                  (vector[pivot].legajo > vector[j].legajo) ) then
                  pivot:=j;

          {intercambio}
                Aux:=Vector[pivot];
                Vector[pivot]:=Vector[i];
                Vector[i]:=Aux;
          {fin intercambio}
     end;
end;

Procedure Escribir_Cabeza(var Arch_List:T_Arch_List);
  Var
           A,M,D,DS:word;
  Begin
           GetDate(A,M,D,DS);
           writeln(Arch_List,' ':20,'LISTADO PROVINCIA BS. AS. - A¤o ',A);
           writeln(Arch_List,' ');
           writeln(Arch_List,'LOCALIDAD',' ':5,
                                    'LEGAJO':15,'NOMBRE':15,'CALLE':15,'TELEFONO':15);
           writeln(Arch_List,' ');
           write  (Arch_List,'------------------------------':30);
           write  (Arch_List,'------------------------------':30);
           writeln(Arch_List,'-----------------':17);
           writeln(Arch_List,' ');
  End;

Procedure Inicialar_Indice(Var Vector: Tvec_indice);
var
   registro: treg_indice;
   i:integer;
begin
        with registro do
               begin
                    localidad:='';
                    Legajo:=0;
                    Prr:=0;
               end;
        for i:=1 to max_provincia do
                Vector[i]:=registro;
end;


Procedure ListadoI(Var Archivo: T_Arch_emp; var Lista: T_Arch_list);
var
   Vec_indice: Tvec_indice;
   reg_indice:Treg_indice;
   cant_elem:integer;


   registro: Treg_emp; {el registro receptor para leer el archivo}

   fin: boolean;
   i:integer;

   localidadprev:string[15]; {para el corte de control para subtotales}
   subtot_localidad:integer;

begin

     Reset(Archivo);
     Rewrite(Lista);

     Inicialar_Indice(Vec_Indice);
     cant_elem:=0;
     Leer(Archivo, registro, fin);

     While (not fin) do
           begin
                if (registro.Domicilio_Provincia='Buenos Aires') then
                   begin
                        inc(cant_elem);
                        reg_indice.legajo:=registro.legajo;
                        reg_indice.localidad:=registro.Domicilio_localidad;
                        reg_indice.prr:=filepos(Archivo)-1;
                        Vec_Indice[cant_elem]:=reg_indice;{estaba afuera}
                   end;
                Leer(Archivo, registro, fin);
           end;

     {Ordenaremos este vector de ¡ndices por su clave en este caso dos campos,
     primero por localidad y luego por padr¢n}

     INTERORDENA(Vec_indice,cant_elem);
     Escribir_cabeza(Lista);

     (*Comienza el cuerpo del listado*)

     i:=1;
     seek(Archivo,vec_indice[i].prr);
     Read(Archivo,registro);

     while (i<= cant_elem) do
     begin
           subtot_localidad:=0;
           localidadprev:=vec_indice[i].localidad;
           while ((localidadprev=vec_indice[i].localidad) and (i<= cant_elem)) do

                 begin
                        inc(subtot_localidad);
                        writeln(Lista, registro.domicilio_localidad,'':10,registro.legajo,'':15,registro.nombre,'':6,
                        registro.Domicilio_calle,'':15,registro.Telefono);

                        inc(i);
                        if (i<= cant_elem) then {para que no tire error si i=max_provincia}
                        begin
                              seek(Archivo,vec_indice[i].prr);
                              Read(Archivo,registro);
                        end;
                 end;
            writeln(Lista,'Cantidad de empleados ',localidadprev,'...........',subtot_localidad);
            writeln(Lista,'');
     end;
     (*Termina el cuerpo listado*)
     Close(Archivo);
     Close(Lista);

end;

Procedure Inicialar_Aumento(Var Vector:Tvec_Aumento);
var
   registro: Treg_aum;
   i:integer;
begin
     for i:=1 to max_Aumento do
     begin
          registro.Legajo:=0;
          registro.Porcentaje:=0.0;
          Vector[i]:=registro;
     end;
end;

Procedure Leer_Aumento(Var F: T_arch_aum; var R: Treg_Aum; var Fin:boolean);
begin
     fin:=Eof(F);
     if (not fin) then
        read(F,R);
end;

Procedure Interordena2(var Vector: Tvec_Aumento; n: integer);
var
   Aux:Treg_Aum;
   i,j:integer;
Begin
     For i:=1 to n-1 do
         for j:=i+1 to n do
             begin
                  if Vector[i].legajo > Vector[j].Legajo then
                     begin
                          Aux:=Vector[i];
                          Vector[i]:=Vector[j];
                          Vector[j]:=Aux;
                     end;
             end;
end;


Procedure Actualizar(var Arch_primario: T_Arch_emp; var Arch_secundario: T_Arch_aum);

var
   Vec_aux: Tvec_Aumento;
   reg_aum: Treg_Aum;
   reg_emp: Treg_emp;
   i,cant_elem:integer;
   Fin_Aumento,Fin_empleados: Boolean;

Begin
     Reset(Arch_primario);
     Reset(Arch_secundario);

     Inicialar_Aumento(Vec_aux);
     Cant_elem:=0;
     Leer_Aumento(Arch_secundario,reg_aum, fin_Aumento);

     While (not fin_Aumento) do
           begin
                inc(Cant_elem);
                Vec_aux[cant_elem]:=Reg_Aum;
                Leer_Aumento(Arch_secundario, reg_aum, fin_Aumento);
           end;

     Interordena2(Vec_aux,cant_elem);{Ordena por legajo ascendente}
     Leer(Arch_primario,reg_emp,fin_empleados);
     i:=1;

     While (not fin_empleados) or (i<=cant_elem) do
           begin
                if (reg_emp.legajo = Vec_aux[i].legajo) then
                   begin
                        reg_emp.sueldo:=reg_emp.sueldo+((reg_emp.sueldo*Vec_aux[i].porcentaje)/100);
                        write(Arch_primario,reg_emp);
                        leer(Arch_primario, reg_emp, fin_empleados);
                        inc(i);
                   end

                else
                    leer(Arch_primario,reg_emp,fin_empleados);
           end;

     Close(Arch_primario);
     Close(Arch_secundario);
end;

Procedure Inicialar_indice_aum(Var Vector: Tvec_indice_aum);
var
   i: integer;
   registro: Treg_indice_aum;
begin
     for i:=1 to emp_aum do
         begin
              with registro do
                   begin
                        aum:=0.0;
                        prr:=0;
                   end;
         end;
end;

Procedure Ordena_indice_aum(var Vector: Tvec_indice_aum; n: integer);
var
   Aux:Treg_indice_aum;
   i,j:integer;
Begin
     For i:=1 to n-1 do
         for j:=i+1 to n do
             begin
                  if Vector[i].aum < Vector[j].aum then
                     begin
                          Aux:=Vector[i];
                          Vector[i]:=Vector[j];
                          Vector[j]:=Aux;
                     end;
             end;
end;


Procedure mas_aumento(var Arch_primario: T_Arch_emp; var Arch_secundario: T_Arch_aum);

var
   Vec_aux: Tvec_Aumento;
   reg_aum: Treg_Aum;
   reg_emp: Treg_emp;
   i,j,cant_elem:integer;
   Fin_Aumento,Fin_empleados: Boolean;

   indice_aum:tvec_indice_aum;


Begin
     Reset(Arch_primario);
     Reset(Arch_secundario);

     Inicialar_Aumento(Vec_aux);
     Inicialar_indice_aum(indice_aum);

     Cant_elem:=0;
     Leer_Aumento(Arch_secundario,reg_aum, fin_Aumento);

     While (not fin_Aumento) do
           begin
                inc(Cant_elem);
                Vec_aux[cant_elem]:=Reg_Aum;
                Leer_Aumento(Arch_secundario, reg_aum, fin_Aumento);
           end;

     Interordena2(Vec_aux,cant_elem);{Ordena por legajo ascendente}

     Leer(Arch_primario,reg_emp,fin_empleados);
     i:=1;

     While (not fin_empleados) and (i<=cant_elem) do
           begin
                if (reg_emp.legajo = Vec_aux[i].legajo) then
                   begin
                        indice_aum[i].aum:=(reg_emp.sueldo*Vec_aux[i].porcentaje) /100;   (****)
			indice_aum[i].prr:=filepos(arch_primario);				(****)
                        inc(i);
                   end
                else
                    leer(Arch_primario,reg_emp,fin_empleados);
           end;

	ordena_indice_aum(indice_aum,i); {Ordena por Aumento descendente}


	writeln('Los ',emp_aum,' empleados que más aumento tienen son:');

	for j:=1 to emp_aum do
	  begin
                seek(Arch_primario,indice_aum[j].prr - 1);
		Leer(Arch_primario,reg_emp,fin_empleados);
		if ((j mod 3)= 0 ) then
                begin
		     writeln('Presione una tecla para continuar');
                     readln;
                end;
		writeln('**********************');
		writeln('Legajo: ',reg_emp.Legajo);
		writeln('Nombre: ',reg_emp.nombre);
		writeln('Sueldo Anterior: ',reg_emp.Sueldo);
		writeln('Sueldo con aumento: ', reg_emp.Sueldo + indice_aum[j].aum);
		writeln('**********************');
          end;

     Close(Arch_primario);
     Close(Arch_secundario);
end;


VAR
   Aumentos: T_Arch_Aum;
   Empleados: T_Arch_emp;
   Informe: T_arch_List;

BEGIN
     Assign(Aumentos,'Aumentos.dat');
     Assign(Empleados,'Empleados.dat');
     Assign(Informe,'Listado.txt');

      clrscr;
      writeln('':10,'Se listan los empleados de Buenos Aires');
      LISTADOI(Empleados,Informe);
      readkey;


      writeln('':10,'¿Qué días no trabaja nadie?');
      DIA_LIBRE(Empleados);
      readkey;


      writeln('':10,'Se intercambian los d¡as de trabajo');
      INTERCAMBIAR_DIAS(Empleados);
      readkey;

      writeln('':10,'Se listan los ',emp_aum,' que reciben más aumento');
      mas_aumento(Empleados,Aumentos);
      readkey;

      writeln('':10,'Se actualiza el archivo de empleados con el de aumentos');
      ACTUALIZAR(Empleados,Aumentos);
      readkey;
END. 
