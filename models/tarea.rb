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
class Tarea < ActiveRecord::Base
  belongs_to :responsable
# validates_format_of :responsable,
#                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/,
#                     on: :update
  field :asunto, as: :text
  field :estado, as: :string, default: 'pendiente'
  field :vencimiento, as: :date
  field :uuid, as: :string
  timestamps
end
