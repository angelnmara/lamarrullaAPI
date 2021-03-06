
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
drop table if exists tbPelicualasCartelera;
drop table if exists tbCartelera;

drop table if exists tbBoletos;

drop table if exists tbPeliculaHorario;
drop table if exists tbSucursalSalaPelicula;
drop table if exists tbPeliculas;

drop table if exists tbSalasButacas;

drop table if exists tbSalas;
drop table if exists tbSucursales;
drop table if exists tbGenero;
drop table if exists tbClasificacion;
drop table if exists tbHoras;

drop table if exists tbStatBoletos;


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
                            
create table if not exists tbGenero(fiIdGenero int not null auto_increment primary key,
									fcGeneroDesc varchar(100));
                                    
create table if not exists tbClasificacion(fiIdClasificacion int not null auto_increment primary key,
									fcClasificacionDesc varchar(100));
                            
create table if not exists tbPeliculas(fiIdPelicula int not null auto_increment primary key,
									fcPeliculaDesc char(100),
                                    fiIdGenero int,
                                    fiPeliculaDuracion int,                                    
                                    fiIdClasificacion int,
                                    fcPeliculaSinopsis varchar(2000),
                                    fcPeliculaActores varchar(2000),
                                    fcPeliculaDirectores varchar(1000),
                                    fcPeliculaURL char(200),
                                    fnPeliculaStat bit default 1,
                                    constraint foreign key(fiIdGenero)
                                    references tbGenero(fiIdGenero),
                                    constraint foreign key(fiIdClasificacion)
                                    references tbClasificacion(fiIdClasificacion));								
                                    
create table if not exists tbSucursales(fiIdSucursal int not null auto_increment primary key,
									fcSucursalDesc varchar(500),
                                    fcSucursalDir varchar(1000),
                                    fdSucursalLat decimal(18,10),
                                    fdSucursalLong decimal(18,10),
                                    fnSucursalStat bit default 1);                                    
                                    
create table if not exists tbCartelera(fiIdCartelera int not null auto_increment primary key,
									fcCarteleraDesc char(200),                                    
                                    fdCarteleraFecIni datetime default CURRENT_TIMESTAMP,
                                    fdCarteleraFecFin datetime default CURRENT_TIMESTAMP,
                                    fiIdSucursal int,
                                    fnCarteleraStat bit default 1,
                                    constraint foreign key(fiIdSucursal)
                                    references tbSucursales(fiIdSucursal));
                                    
create table if not exists tbPelicualasCartelera(fiIdPelicualasCartelera int not null auto_increment primary key,
												fiIdCartelera int,
												fiIdPelicula int,                                                
                                                fnPelicualasCartelera bit default 1,
                                                constraint foreign key(fiIdPelicula)
                                                references tbPeliculas(fiIdPelicula),
                                                constraint foreign key(fiIdCartelera)
                                                references tbcartelera(fiIdCartelera));
/*                                    
create table if not exists tbTpSala(fiIdTpSala int not null auto_increment primary key,
									fcTpSalaNom varchar(50),
									fcTpSalaDesc varchar(500),
                                    fcTpSalaTam int,
                                    fcTpSalaStat bit default 1);
*/
                                    
create table if not exists tbSalas(fiIdSala int not null auto_increment primary key,								                                
								fcSalaNom varchar(50),
								fcSalaDesc varchar(500),
                                fiSalaTam int);
                                
create table if not exists tbSalasButacas(fiIdSalaButaca int not null auto_increment primary key,
										fiIdSala int,
										fcSalaButacaFila varchar(2),
                                        fiSalaButacaColumna int,
                                        fnSalaButacaStat bit default 1,
                                        constraint foreign key (fiIdSala)
                                        references tbSalas(fiIdSala));
                                        
create table if not exists tbStatBoletos(fiIdStatBoleto int not null auto_increment primary key,
										fcStatBoletoDesc varchar(50),
                                        fnStatBoletoStat bit default 1);

/*falta constraint para que no se repita sucursal sala y pelicula*/                                    
create table if not exists tbSucursalSalaPelicula(fiIdSucursalSalaPelicula int not null auto_increment primary key,
												fiIdSucursal int,
												fiIdSala int,
                                                fiIdPelicula int,
												constraint foreign key(fiIdSucursal)
												references tbSucursales(fiIdSucursal),
												constraint foreign key(fiIdSala)
												references tbSalas(fiIdSala),
                                                constraint foreign key(fiIdPelicula)
                                                references tbPeliculas(fiIdPelicula));
/*                                    
create table if not exists tbSala(fiIdSala int not null auto_increment primary key,
								fiIdSucursal int,
                                fiIdTpSala int,
								fcSalaDesc varchar(500),
                                constraint foreign key(fiIdSucursal)
                                references tbSucursal(fiIdSucursal), 
                                constraint foreign key(fiIdTpSala)
                                references tbTpSala(fiIdTpSala));
*/

create table if not exists tbHoras(fiIdHora int not null auto_increment primary key,
								fdHora time);
                                                                
create table if not exists tbPeliculaHorario(fiIdPeliculaHorario int not null auto_increment primary key,												
											fiIdSucursalSalaPelicula int,                                            
                                            fiIdHora int,
                                            fnPeliculaHorarioSemanaDiaEspecial bit default false,
                                            fnPeliculaHorarioSemanaStat bit default true,                                                
                                            constraint foreign key(fiIdSucursalSalaPelicula)
                                            references tbSucursalSalaPelicula(fiIdSucursalSalaPelicula),
                                            constraint foreign key(fiIdHora)
                                            references tbHoras(fiIdHora));
                                            
create table if not exists tbBoletos(fiIdBoleto int not null auto_increment primary key,
									fdBoletoCompra datetime default CURRENT_TIMESTAMP,
                                    fdBoletoFechaPelicula date not null,                                    
                                    fiIdPeliculaHorario int,
                                    fiIdSalaButaca int,
                                    fiIdStatBoleto int,
                                    fnBoletoStat bit default 1,
                                    constraint foreign key(fiIdPeliculaHorario)
                                    references tbPeliculaHorario(fiIdPeliculaHorario),
                                    constraint foreign key(fiIdSalaButaca)
                                    references tbSalasButacas(fiIdSalaButaca),
                                    constraint foreign key(fiIdStatBoleto)
                                    references tbStatBoletos(fiIdStatBoleto));                                            
                                                                                        
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
insert tbCatCampo(fcCampo, fcDescCampo) values('Dir', 'Direccion');

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

insert tbGenero(fcGeneroDesc)
values('Comedia');

insert tbGenero(fcGeneroDesc)
values('Accion');

insert tbGenero(fcGeneroDesc)
values('Drama');

insert tbGenero(fcGeneroDesc)
values('Terror');

insert tbClasificacion(fcClasificacionDesc)
values('A');

insert tbClasificacion(fcClasificacionDesc)
values('B');

insert tbClasificacion(fcClasificacionDesc)
values('B-15');

insert tbClasificacion(fcClasificacionDesc)
values('R');

insert tbClasificacion(fcClasificacionDesc)
values('R-18');

insert tbClasificacion(fcClasificacionDesc)
values('C');

insert tbPeliculas(fcPeliculaDesc, fiIdGenero, fiPeliculaDuracion, fiIdClasificacion, fcPeliculaSinopsis, fcPeliculaActores, fcPeliculaDirectores, fcPeliculaURL) 
values('Deseo de Matar', 
	1,
    108,
    6,
	'Paul Kersey (Bruce Willis) es un cirujano felizmente casado, (Elisabeth Shue) y con una hija adorable en edad universitaria (Camila Morrone). Pero la desgracia quiere que madre e hija sean brutalmente atacadas en su casa. La madre muere y su hija queda absolutamente traumatizada. Con la policía sobrecargada de crímenes, Paul, en busca de venganza persigue a los agresores de su familia para hacer justicia. Los asesinatos anónimos de delincuentes pronto captan la atención de los medios y la ciudad se pregunta si este mortal vengados en un ángel de la guarda o un demonio. La furia y el destino colisionan en el intenso y emocionante filme “Deseo de Matar”.',
    'Bruce Willis,Elisabeth Shue,Camila Morrone',
    'Eli Roth',
    'DeseoMatar');

insert tbPeliculas(fcPeliculaDesc, fiIdGenero, fiPeliculaDuracion, fiIdClasificacion, fcPeliculaSinopsis, fcPeliculaActores, fcPeliculaDirectores, fcPeliculaURL) 
values('PANTERA NEGRA', 
	1,
    126,
    3,
	'PANTERA NEGRA, de Marvel Studios, sigue a T''Challa, quien regresa a Wakanda, su solitaria nación africana de tecnología avanzada, para asumir como rey. Pero cuando un antiguo y poderoso enemigo reaparece, la fortaleza de T''Challa como rey y superhéroe es puesta a prueba cuando se ve involucrado en un gran conflicto que pone en riesgo el destino de Wakanda y del mundo entero.',
    'Michael B. Jordan,Lupita Nyong''o,Chadwick Boseman,Danai Gurira',
    'Ryan Coogler',
    'PanteraNegra');
    
insert tbPeliculas(fcPeliculaDesc, fiIdGenero, fiPeliculaDuracion, fiIdClasificacion, fcPeliculaSinopsis, fcPeliculaActores, fcPeliculaDirectores, fcPeliculaURL) 
values('La Forma Del Agua', 
	3,
    126,
    1,
	'Del experto escritor Guillermo del Toro, viene LA FORMA DEL AGUA – un cuento de hadas místico, que tiene como fondo la época de la Guerra Fría en los Estados Unidos, hacia 1963. En el laboratorio oculto de alta seguridad del gobierno donde trabaja, la solitaria Elisa (Sally Hawkins) está atrapada en una vida de silencio y aislamiento. La vida de Elisa cambia para siempre cuando ella y su compañera de trabajo Zelda (Octavia Spencer) descubren un experimento clasificado secreto. El reparto lo redondea Michael Shannon, Richard Jenkins, Michael Stuhlbarg y Doug Jones.',
    'Richard Jenkins,Sally Hawkins,Octavia Spencer,Michael Shannon,Doug Jones',
    'Guillermo Del Toro',
    'FormaAgua');
    
insert tbPeliculas(fcPeliculaDesc, fiIdGenero, fiPeliculaDuracion, fiIdClasificacion, fcPeliculaSinopsis, fcPeliculaActores, fcPeliculaDirectores, fcPeliculaURL) 
values('Las Aventuras de Lara Croft', 
	1,
    118,
    2,
	'Lara Croft, la independiente hija de un aventurero perdido, se esforzará más allá de sus límites cuando descubra la localización en la que su padre desapareció sin dejar rastro. Nueva película -reboot- sobre Lara Croft, la protagonista de la saga de videojuegos ''Tomb Raider''',
    'Alicia Vikander,Walton Goggins,Dominic West,Daniel Wu',
    'Roar Uthanug',
    'AventurasLara');
    
insert tbPeliculas(fcPeliculaDesc, fiIdGenero, fiPeliculaDuracion, fiIdClasificacion, fcPeliculaSinopsis, fcPeliculaActores, fcPeliculaDirectores, fcPeliculaURL) 
values('La Maldición de la Casa Winchester', 
	4,
    100,
    2,
	'Sarah Winchester, la heredera millonaria de la fortuna de Armas Winchester, esta convencida que ella y su familia son perseguidos por las almas de los asesinados por el cañón del infame rifle. Su obsesión la ha llevado a la construcción constante de la enorme mansión, diseñada para mantener a los espíritus controlados. Eric Price, un psiquiatra con un turbio pasado, es contratado para determinar el estado mental de la Sra. Winchester. Tras una serie de pruebas psicológicas el Dr. Price descubre el plan de la Sra. Winchester de expiar las almas de todos aquellos asesinados a manos del rifle. Éste peligroso plan libera a los espíritus determinados a vengarse de la familia Winchester; mientras que el Dr. Price se ve obligado a enfrentar fantasmas de su pasado.',
    'Helen Mirren,Jason Clarke',
    'Michael Spierig, Peter Spierig',
    'MaldicionWinchester');
    
insert tbPeliculas(fcPeliculaDesc, fiIdGenero, fiPeliculaDuracion, fiIdClasificacion, fcPeliculaSinopsis, fcPeliculaActores, fcPeliculaDirectores, fcPeliculaURL) 
values('Tropa de Héroes', 
	1,
    130,
    3,
	'Cuenta la historia del primer escuadrón de fuerzas especiales enviado a Afganistán después del 9/11. Bajo el mando de un nuevo capitán, deben trabajar junto con un criminal de guerra para derrotar al Talibán.',
    'Michael Peña,Chris Hemsworth,Michael Shannon,Navid Negahban',
    'Nicolai Fuglsig',
    'TropaHeroes');
    
insert tbsucursales(fcSucursalDesc, fcSucursalDir, fdSucursalLat, fdSucursalLong) values('Sucursal Ex Hacienda Santa Ines', 'Hacienda Santa Ines, Ex-Hacienda Santa Ines, 55790 Nextlalpan, Méx.', 19.7019244,-99.0735723);

insert tbsucursales(fcSucursalDesc, fcSucursalDir, fdSucursalLat, fdSucursalLong) values('Sucursal Plaza Coacalco', 'Av José López Portillo 220, Coacalco, 55714 San Francisco Coacalco, Méx.', 19.6258942,-99.0834886);

insert tbsucursales(fcSucursalDesc, fcSucursalDir, fdSucursalLat, fdSucursalLong) values('Multiplaza ojo de agua', 'Boulevard Santa Cruz Ojo de Agua 88, 55760 San Francisco, Méx.', 19.6627959,-99.0186709);

insert tbsucursales(fcSucursalDesc, fcSucursalDir, fdSucursalLat, fdSucursalLong) values('Plaza Bella Mexiquense', 'Calle Mexiquense 2, Col. Héroes de Tecamac, 55764 Ojo de Agua, Méx.', 19.6277473,-99.0236094);

insert tbsucursales(fcSucursalDesc, fcSucursalDir, fdSucursalLat, fdSucursalLong) values('Lindavista', 'Tepeyac Insurgentes, 07020 Ciudad de México, CDMX', 19.4857316,-99.1358689);

insert tbsucursales(fcSucursalDesc, fcSucursalDir, fdSucursalLat, fdSucursalLong) values('Bucareli', 'Bucareli 63, Juárez, 06600 Ciudad de México, CDMX', 19.4250874,-99.1701293);

insert tbCartelera(fcCarteleraDesc, fdCarteleraFecIni, fdCarteleraFecFin, fiIdSucursal)values('Cartelera sem 3 Marzo', '20180312', '20180318', 1);
insert tbCartelera(fcCarteleraDesc, fdCarteleraFecIni, fdCarteleraFecFin, fiIdSucursal)values('Cartelera sem 3 Marzo', '20180312', '20180318', 2);
insert tbCartelera(fcCarteleraDesc, fdCarteleraFecIni, fdCarteleraFecFin, fiIdSucursal)values('Cartelera sem 3 Marzo', '20180312', '20180318', 3);
insert tbCartelera(fcCarteleraDesc, fdCarteleraFecIni, fdCarteleraFecFin, fiIdSucursal)values('Cartelera sem 3 Marzo', '20180312', '20180318', 4);
insert tbCartelera(fcCarteleraDesc, fdCarteleraFecIni, fdCarteleraFecFin, fiIdSucursal)values('Cartelera sem 3 Marzo', '20180312', '20180318', 5);
insert tbCartelera(fcCarteleraDesc, fdCarteleraFecIni, fdCarteleraFecFin, fiIdSucursal)values('Cartelera sem 3 Marzo', '20180312', '20180318', 6);

insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(1, 1);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(1, 2);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(1, 3);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(1, 4);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(1, 5);

insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(2, 1);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(2, 2);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(2, 3);

insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(3, 1);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(3, 2);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(3, 3);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(3, 4);

insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(4, 2);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(4, 3);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(4, 4);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(4, 5);

insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(5, 1);
insert tbPelicualasCartelera(fiIdCartelera, fiIdPelicula)values(5, 5);

insert tbSalas(fcSalaNom, fcSalaDesc, fiSalaTam) values ('A', 'Sala con el mayor numero de lugares', 15);
insert tbSalas(fcSalaNom, fcSalaDesc, fiSalaTam) values ('B', 'Sala intermedia en numero de lugares', 10);
insert tbSalas(fcSalaNom, fcSalaDesc, fiSalaTam) values ('C', 'Sala mas baja en numero de lugares', 5);

insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(1,1,1);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(1,2,1);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(1,2,2);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(1,3,3);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(1,1,4);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(1,2,5);

insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(2,1,1);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(2,2,2);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(2,3,3);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(2,1,3);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(2,3,4);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(2,2,5);

insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(3,1,1);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(3,3,2);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(3,2,2);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(3,2,3);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(3,2,4);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(3,3,5);

insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(4,1,1);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(4,2,2);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(4,3,3);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(4,2,3);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(4,3,4);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(4,1,3);

insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(5,2,1);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(5,2,2);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(5,1,3);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(5,3,4);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(5,3,5);
insert tbSucursalSalaPelicula(fiIdSucursal, fiIdSala, fiIdPelicula) values(5,2,5);

insert tbHoras(fdHora)values('09:00');
insert tbHoras(fdHora)values('10:00');
insert tbHoras(fdHora)values('12:00');
insert tbHoras(fdHora)values('15:00');
insert tbHoras(fdHora)values('19:00');
insert tbHoras(fdHora)values('20:00');
insert tbHoras(fdHora)values('21:00');

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(1,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(1,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(1,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(1,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(1,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(1,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(2,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(2,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(2,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(2,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(2,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(2,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(3,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(3,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(3,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(3,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(3,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(3,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(4,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(4,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(4,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(4,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(4,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(4,5);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(5,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(5,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(5,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(5,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(5,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(5,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(6,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(6,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(6,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(6,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(6,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(6,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(7,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(7,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(7,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(7,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(7,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(7,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(8,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(8,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(8,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(8,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(8,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(8,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(9,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(9,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(9,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(9,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(9,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(9,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(10,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(10,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(10,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(10,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(10,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(10,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(11,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(11,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(11,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(11,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(11,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(11,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(12,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(12,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(12,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(12,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(12,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(12,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(13,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(13,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(13,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(13,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(13,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(13,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(14,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(14,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(14,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(14,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(14,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(14,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(15,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(15,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(15,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(15,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(15,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(15,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(17,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(17,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(17,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(17,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(17,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(17,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(18,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(18,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(18,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(18,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(18,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(18,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(19,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(19,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(19,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(19,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(19,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(19,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(20,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(20,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(20,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(20,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(20,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(20,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(21,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(21,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(21,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(21,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(21,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(21,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(22,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(22,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(22,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(22,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(22,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(22,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(23,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(23,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(23,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(23,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(23,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(23,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(24,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(24,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(24,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(24,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(24,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(24,6);

insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(25,1);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(25,2);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(25,3);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(25,4);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(25,5);
insert tbPeliculaHorario(fiIdSucursalSalaPelicula, fiIdHora)values(25,6);

insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'A', 1);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'A', 2);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'A', 3);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'A', 4);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'A', 5);

insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'B', 1);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'B', 2);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'B', 3);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'B', 4);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'B', 5);

insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'C', 1);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'C', 2);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'C', 3);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'C', 4);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (1,'C', 5);

insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'A', 1);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'A', 2);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'A', 3);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'A', 4);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'A', 5);

insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'B', 1);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'B', 2);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'B', 3);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'B', 4);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (2,'B', 5);

insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (3,'A', 1);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (3,'A', 2);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (3,'A', 3);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (3,'A', 4);
insert tbSalasButacas(fiIdSala, fcSalaButacaFila, fiSalaButacaColumna) values (3,'A', 5);

insert tbStatBoletos(fcStatBoletoDesc) values ('Comprado'); 
insert tbStatBoletos(fcStatBoletoDesc) values ('Apartado');
insert tbStatBoletos(fcStatBoletoDesc) values ('Cancelado');

insert tbBoletos(fdBoletoFechaPelicula, fiIdPeliculaHorario, fiIdSalaButaca, fiIdStatBoleto) values(CURRENT_TIMESTAMP, 1,1,1);
insert tbBoletos(fdBoletoFechaPelicula, fiIdPeliculaHorario, fiIdSalaButaca, fiIdStatBoleto) values(CURRENT_TIMESTAMP, 1,2,1);
insert tbBoletos(fdBoletoFechaPelicula, fiIdPeliculaHorario, fiIdSalaButaca, fiIdStatBoleto) values(CURRENT_TIMESTAMP, 1,7,1);
insert tbBoletos(fdBoletoFechaPelicula, fiIdPeliculaHorario, fiIdSalaButaca, fiIdStatBoleto) values(CURRENT_TIMESTAMP, 1,8,1);

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
from tbPeliculaHorario;