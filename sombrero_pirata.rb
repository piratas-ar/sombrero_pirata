#!/usr/bin/env ruby
#   Sombrero Pirata by Ppar
#   Copyright (C) 2016  Saico elsaico@partidopirata.com.ar

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as
#   published by the Free Software Foundation, either version 3 of the
#   License, or (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.

#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>
require 'sinatra'
require 'sqlite3'
require 'mini_record'
require 'sinatra/form_helpers'
#require 'pry'
require 'sinatra/flash'
require 'mail'
require 'securerandom'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: 'sombrero.sqlite')
require './models/tarea'
require './models/responsable'
require './models/grupo'

ActiveRecord::Base.auto_upgrade!

enable :sessions

get '/' do
  @tareas = Tarea.all.order(created_at: :desc)

  # Filtros
    if params[:grupo].present?
    grupo = Grupo.find_by(nombre: params[:grupo])
    @tareas = @tareas.where(grupo: grupo)
    end
  haml :index
end

post '/tareas/new' do
  nueva_tarea = Tarea.new params[:tarea]
<<<<<<< HEAD
  nueva_tarea.uuid = SecureRandom.uuid
=======
  nueva_tarea.grupo = Grupo.find_or_create_by!(nombre: params[:grupo][:nombre])
>>>>>>> b2d46253da76d73300b51b40adb05eb2ef9ef970
  nueva_tarea.save
  redirect '/'
end

post '/tareas/asignar' do
  responsable = Responsable.find_or_create_by!(email: params[:responsable][:email])
  if responsable.tarea && responsable.tarea.estado != 'completada'
    responsable.tarea.estado = 'pendiente'
    responsable.tarea.responsable = nil
  end
  tarea = Tarea.where(estado: 'pendiente').sample
  if tarea
# binding.pry
    responsable.tarea.save if responsable.tarea
    tarea.responsable = responsable
    tarea.estado = 'asignada'
    tarea.save
    mail = Mail.new do
      from     'sombrero@partidopirata.com.ar'
      to       responsable.email
      subject  'Se te ha asignado una tarea'
      body   <<eof
#{tarea.asunto}

Avast!!
Se te ha asignado una tarea!
Si no tenes idea de que es este mensaje, entra al link posterior para
desasignarte la tarea.

https://sombrero.partidopirata.com.ar/tareas/desasignar/#{tarea.uuid}
             
eof
    end
    mail.delivery_method :sendmail
    mail.deliver
  else
    flash[:error] = "No hay tareas disponibles"
  end
  redirect '/'
end
get '/tareas/desasignar/:uuid' do
  @tarea = Tarea.find_by(uuid: params[:uuid]) 
  haml :'tareas/desasignar'
end
post '/tareas/desasignar' do 
  @tarea = Tarea.find(params[:id])
  @tarea.responsable = nil
  @tarea.estado = 'pendiente'
  @tarea.save
  redirect '/'




end
