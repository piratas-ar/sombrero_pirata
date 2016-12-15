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

ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: 'sombrero.sqlite')
require './models/tarea'
require './models/responsable'

ActiveRecord::Base.auto_upgrade!

enable :sessions

get '/' do
  @tareas = Tarea.all.order(created_at: :desc)
  haml :index
end

post '/tareas/new' do
  nueva_tarea = Tarea.new params[:tarea]
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
      from     'sombreo@partidopirata.com.ar'
      to       responsable.email
      subject  'Se te ha asignado una tarea'
      body     tarea.asunto
    end
    mail.delivery_method :sendmail
    mail.deliver
  else
    flash[:error] = "No hay tareas disponibles"
  end
  redirect '/'
end
