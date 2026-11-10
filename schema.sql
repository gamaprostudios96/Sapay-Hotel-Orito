-- SAPAY HOTEL · esquema de Supabase (pega todo en SQL Editor > Run)
create table if not exists habitaciones(numero text primary key,categoria text not null check(categoria in('sencilla','matrimonial','dos_camas')),estado text not null default 'libre' check(estado in('libre','limpieza','ocupada')),ocupada_hasta date,huesped text);
create table if not exists reservas(id uuid primary key default gen_random_uuid(),creada timestamptz not null default now(),origen text not null default 'app' check(origen in('app','manual')),habitacion text references habitaciones(numero),nombres text not null,apellidos text not null,tipo_doc text,documento text,ciudad text,departamento text,profesion text,telefono text,llegada date,hora_llegada time,noches int not null check(noches>0),clima text check(clima in('aire','ventilador')),total int,metodo_pago text,titular text,referencia text,estado text not null default 'pendiente' check(estado in('pendiente','confirmada','cancelada')),acepta_politica boolean not null default false,comision_pct numeric not null default 10,comision_valor int,comision_pagada boolean not null default false);
create table if not exists opiniones(id uuid primary key default gen_random_uuid(),creada timestamptz not null default now(),mensaje text not null check(length(mensaje)<=1000));
create table if not exists resenas(id uuid primary key default gen_random_uuid(),creada timestamptz not null default now(),estrellas int not null check(estrellas between 1 and 5),comentario text check(length(comentario)<=1000));
create table if not exists comisiones_periodos(id uuid primary key default gen_random_uuid(),desde date not null,hasta date not null,acumulado int not null default 0,pagado int not null default 0,vence date not null,recargo_aplicado boolean not null default false);
alter table habitaciones enable row level security;alter table reservas enable row level security;alter table opiniones enable row level security;alter table resenas enable row level security;alter table comisiones_periodos enable row level security;
-- Público: ver estado de habitaciones, crear reservas (solo si acepta la política), enviar opiniones y reseñas, ver reseñas.
create policy hab_ver on habitaciones for select to anon,authenticated using(true);
create policy hab_admin on habitaciones for all to authenticated using(true) with check(true);
create policy res_crear on reservas for insert to anon with check(acepta_politica=true and origen='app');
create policy res_admin on reservas for all to authenticated using(true) with check(true);
create policy op_crear on opiniones for insert to anon,authenticated with check(true);
create policy op_admin on opiniones for select to authenticated using(true);
create policy rs_crear on resenas for insert to anon,authenticated with check(true);
create policy rs_ver on resenas for select to anon,authenticated using(true);
create policy com_admin on comisiones_periodos for all to authenticated using(true) with check(true);
insert into habitaciones(numero,categoria) values('101','sencilla'),('102','sencilla'),('103','sencilla'),('104','sencilla'),('105','matrimonial'),('106','matrimonial'),('107','matrimonial'),('108','matrimonial'),('109','matrimonial'),('110','dos_camas'),('111','dos_camas'),('112','dos_camas') on conflict do nothing;
