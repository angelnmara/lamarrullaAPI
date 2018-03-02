
use dbMadeInChiconcuac;

/*	------------------------------------	*/
/*			borra tablas					*/
/*	------------------------------------	*/

drop table if exists tbDtPersonalesUsu;
drop trigger if exists trAddOneDay_tbUsuCveApi_fdFecFinCveAPI;
drop trigger if exists trAddOneYear_tbUsuPassw_fdFecFinPAssw;
drop table if exists tbUsuCveApi;
drop table if exists tbUsuRol;
drop table if exists tbUsuPassw;
drop table if exists tbUsu;
drop table if exists tbCatTpPer;
drop table if exists tbNacionalidad;
drop table if exists tbCodigoPostal;
drop table if exists tbCatObjeto;
drop table if exists tbCatCampo;
drop table if exists tbMemberRol;
drop table if exists tbCatRol;
drop table if exists tbPeliculas;
drop table if exists tbCartelera;

/*	------------------------------------	*/
/*			termina borra tablas			*/
/*	------------------------------------	*/

/*	------------------------------------	*/
/*			crea tablas						*/
/*	------------------------------------	*/

create table if not exists tbCatObjeto(fiIdObjeto int not null auto_increment primary key,
						fcObjeto varchar(4),
                        fcDescObjeto varchar(100));
                        
create table if not exists tbCatCampo(fiIdCampo int not null auto_increment primary key,
									fcCampo varchar(5),
                                    fcDescCampo varchar(100));

create table if not exists tbCatTpPer(fiIdTpPer int not null auto_increment primary key,
						fcDescTpPer char(50), 
                        fnStatTpPer bit);
                        
create table if not exists tbCatRol(fiIdRol int not null auto_increment primary key,
									fiDescRol varchar(100),
                                    fnStatRol bit);								

create table if not exists tbMemberRol(fiIdMemberRol int not null auto_increment primary key,
									fiIdRol int,
                                    fiIdRolMember int,
                                    fnStatMemberRol bit,
                                    constraint foreign key(fiIdRol) references tbCatRol(fiIdRol),
                                    constraint foreign key(fiIdRolMember) references tbCatRol(fiIdRol),
                                    unique(fiIdRol, fiIdRolMember));								

create table if not exists tbUsu (fiIdUsu int not null auto_increment primary key,
                    fcUsu char(10) unique not null,
                    fcCorreoElectronico char(100) unique not null,                    
                    fnStatUsu bit default 1);
                            
create table if not exists tbUsuRol(fiIdUsuRol int not null auto_increment primary key,
									fiIdUsu int,
									fiIdRol int,
                                    fnStatRol bit default true,
									constraint foreign key (fiIdUsu)
											references tbUsu(fiIdUsu)
											on delete cascade);
                            
create table if not exists tbUsuCveApi(fiIdUsuCveAPI int not null auto_increment primary key,
									fiIdUsu int,
                                    fcCveAPI varchar(1000) not null unique,
                                    fnStatCveAPI bit default true,
                                    fdFecIniCveAPI datetime default CURRENT_TIMESTAMP,
                                    fdFecFinCveAPI datetime default null,
                                    constraint foreign key(fiIdUsu)
                                    references tbusu(fiIdUsu)
                                    on delete cascade);                                    
                                    
create table if not exists tbUsuPassw(fiIdUsuPassw int not null auto_increment primary key,
									fiIdUsu int,
                                    fcUsuPassw varchar(200) not null default '1234',
                                    fdFecIniPassw datetime default CURRENT_TIMESTAMP,
                                    fdFecFinPassw datetime null,
                                    constraint foreign key(fiIdUsu)
                                    references tbusu(fiIdUsu)
                                    on delete cascade);																	

create table if not exists tbNacionalidad(fiIdNacionalidad mediumint not null auto_increment primary key,
						fcAbrNacionalidad char(4),
						fcDescNacionalidad char(50),
                        fnStatNaionalidad bit);

create table if not exists tbCodigoPostal(fcCodigoPostal varchar(8),
						fcColonia varchar(50),
                        fcMunicipio varchar(50),
                        fcEstado varchar(50),
						fnStatCodigoPostal bit);

create table if not exists tbDtPersonalesUsu(fiIdUsu int, 
						fcNombre char(50),
                        fcApPaterno char(50),
                        fcApMaterno char(50),
                        fiIdTpPer int,
                        fiIdNacionalidad int,
                        fcRFC char(10),                        
                        fcCalle char(200),
                        fcNumeroExterior char(10),
                        fcNumeroInterior char(10),
                        fcCodigoPostal char(8),
                        fcLada char(3),
                        fcTelefono char(10),
                        fcTelefonoCelular char(10),
						constraint foreign key (fiIdUsu) 
							references tbUsu(fiIdUsu)
                            on delete cascade);
                            
create table if not exists tbPeliculas(fiIdPelicula int not null auto_increment primary key,
									fcPeliculaDesc char(100),
                                    fnPeliculaStat bit default 1);
                                    
create table if not exists tbCartelera(fiIdCartelera int not null auto_increment primary key,
									fiIdPelicula int,
									fcCarteleraDesc char(200),                                    									
                                    fdCarteleraFecIni datetime default CURRENT_TIMESTAMP,
                                    fdCarteleraFecFin datetime default CURRENT_TIMESTAMP,
                                    fnCarteleraStat bit default 1,
                                    constraint foreign key(fiIdPelicula)
                                    references tbPeliculas(fiIdPelicula));
                                    
create table if not exists tbSucursal(fiIdSucursal int not null auto_increment primary key,
									fcSucursalDesc varchar(500),
                                    fcSucursalLat decimal(18,10),
                                    fcSucursalLong decimal(18,2),
                                    fnSucursalStat bit default 1);
                                    
create table if not exists tbTpSala(fiIdTpSala int not null auto_increment primary key,
									fcTpSalaDesc varchar(500),
                                    fcTpSalaTam int,
                                    fcTpSalaStat bit default 1);
                                    
create table if not exists tbSala(fiIdSala int not null auto_increment primary key,
								fiIdSucursal int,
                                fiIdTpSala int,
								fcSalaDesc varchar(500),
                                constraint foreign key(fiIdSucursal)
                                references tbSucursal(fiIdSucursal), 
                                constraint foreign key(fiIdTpSala)
                                references tbTpSala(fiIdTpSala));                         
                                                        
/*	------------------------------------	*/
/*		termina crea tablas					*/
/*	------------------------------------	*/

/*	------------------------------------	*/
/*				inserts						*/
/*	------------------------------------	*/

insert tbCatObjeto(fcObjeto, fcDescObjeto) values ('tb', 'tabla');
insert tbCatObjeto(fcObjeto, fcDescObjeto) values ('sp', 'store procedure');        
insert tbCatObjeto(fcObjeto, fcDescObjeto) values ('fn', 'funcion');
insert tbCatObjeto(fcObjeto, fcDescObjeto) values ('tr', 'trigger');

insert tbCatCampo(fcCampo, fcDescCampo) values('fi', 'formato entero');
insert tbCatCampo(fcCampo, fcDescCampo) values('fc', 'formato caracter');                                    
insert tbCatCampo(fcCampo, fcDescCampo) values('fn', 'formato boolean');
insert tbCatCampo(fcCampo, fcDescCampo) values('Desc', 'Descripcion campo');
insert tbCatCampo(fcCampo, fcDescCampo) values('Id', 'Campo Identificador');
insert tbCatCampo(fcCampo, fcDescCampo) values('Stat', 'Status del campo');
insert tbCatCampo(fcCampo, fcDescCampo) values('Tp', 'Tipo');
insert tbCatCampo(fcCampo, fcDescCampo) values('Ap', 'Apellido');
insert tbCatCampo(fcCampo, fcDescCampo) values('Per', 'Persona');
insert tbCatCampo(fcCampo, fcDescCampo) values('Cat', 'Catalogo');
insert tbCatCampo(fcCampo, fcDescCampo) values('Dt', 'Datos');
insert tbCatCampo(fcCampo, fcDescCampo) values('Cve', 'Clave');
insert tbCatCampo(fcCampo, fcDescCampo) values('API', 'Aplicacion');
insert tbCatCampo(fcCampo, fcDescCampo) values('Fec', 'fecha');
insert tbCatCampo(fcCampo, fcDescCampo) values('Ini', 'Inicial');
insert tbCatCampo(fcCampo, fcDescCampo) values('Passw', 'Contraseña / Password');
insert tbCatCampo(fcCampo, fcDescCampo) values('Abr', 'Abrebiado');
insert tbCatCampo(fcCampo, fcDescCampo) values('Lat', 'Latitud');
insert tbCatCampo(fcCampo, fcDescCampo) values('Long', 'Longitud');
insert tbCatCampo(fcCampo, fcDescCampo) values('Tam', 'Tamaño');

insert tbCatTpPer(fcDescTpPer, fnStatTpPer) values ('Fisica', 1);
insert tbCatTpPer(fcDescTpPer, fnStatTpPer) values ('Moral', 1);
insert tbCatTpPer(fcDescTpPer, fnStatTpPer) values ('Fisica con actividad empresarial', 1);

insert tbCatRol(fiDescRol, fnStatRol) values ('Admin', 1);
insert tbCatRol(fiDescRol, fnStatRol) values ('Gerente', 1);
insert tbCatRol(fiDescRol, fnStatRol) values ('Ejecutivo', 1);
insert tbCatRol(fiDescRol, fnStatRol) values ('Vendedor', 1);
insert tbCatRol(fiDescRol, fnStatRol) values ('Usuario', 1);

insert tbMemberRol(fiIdRol, fiIdRolMember, fnStatMemberRol) values (1,2, true);
insert tbMemberRol(fiIdRol, fiIdRolMember, fnStatMemberRol) values (1,3, true);

insert tbNacionalidad(fcAbrNacionalidad, fcDescNacionalidad, fnStatNaionalidad) values('MX', 'Mexicana', true);

insert tbCodigoPostal(fcCodigoPostal, fcColonia, fcMunicipio, fcEstado, fnStatCodigoPostal)                         
				values('55720', 'Parque Residencial Coacalco', 'Coacalco', 'Mexico', 1);
                
insert tbUsu(fcUsu, fcCorreoElectronico) values ('DAVER', 'angelnmara@hotmail.com');
insert tbDtPersonalesUsu(fcNombre, fcApPaterno, fcApMaterno, fiIdTpPer, fiIdNacionalidad, fcRFC, fcCalle, fcNumeroExterior, fcNumeroInterior, fcCodigoPostal, fcLada, fcTelefono, fcTelefonoCelular) 
				values('José David', 'Rincon', 'Angeles', 1, 1, 'RIAD801201', 'Sierra Dorada', '29', '', '55720', '55', '51073141', '');
insert tbUsuRol(fiIdUsu, fiIdRol, fnStatRol) values (1,1, true);
insert tbUsuPassw(fiIdUsu, fcUsuPassw) values (1, 'madaver');
insert tbUsuCveApi(fiIdUsu, fcCveAPI) values(1,'1234');                


/*	------------------------------------	*/
/*			termina inserts					*/
/*	------------------------------------	*/

/*	------------------------------------	*/
/*			crea triggers					*/
/*	------------------------------------	*/
                            

delimiter |
                                    
create trigger trAddOneDay_tbUsuCveApi_fdFecFinCveAPI before insert on tbUsuCveApi
for each row 
begin	
    set new.fdFecFinCveAPI = date_add(CURRENT_TIMESTAMP, interval 1 day);
end; 

| delimiter ;

delimiter |
                                    
create trigger trAddOneYear_tbUsuPassw_fdFecFinPAssw before insert on tbUsuPassw
for each row 
begin	
    set new.fdFecFinPAssw = date_add(CURRENT_TIMESTAMP, interval 1 month);
end; 

| delimiter ;

/*	------------------------------------	*/
/*		termina crea triggers				*/
/*	------------------------------------	*/

select *
from tbUsu;

select *
from tbUsuPassw;

select *
from tbUsuCveApi;
