# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Seth Chisamore
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "mixlib/log"
require "rubygems"
require "eventmachine"
require 'logging'

module EventMachine
  module WinRS
    NAME    = 'em-winrs'
    LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
    PATH    = ::File.dirname(LIBPATH) + ::File::SEPARATOR
    class Log
      extend Mixlib::Log
    end
  end
end

require File.join(EventMachine::WinRS::LIBPATH, "em-winrs/session")
require File.join(EventMachine::WinRS::LIBPATH, "em-winrs/server")
require File.join(EventMachine::WinRS::LIBPATH, "em-winrs/shell")
require File.join(EventMachine::WinRS::LIBPATH, "em-winrs/version")
