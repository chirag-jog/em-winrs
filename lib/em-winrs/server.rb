#
# Author:: Chirag Jog (<chirag.jog@gmail.com>)
# Copyright:: Copyright (c) 2012 Chirag Jog
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

require 'uuidtools'

module EventMachine
  module WinRS
    class Server
      include EM::Deferrable

      attr_accessor :master, :host, :options, :transport

      def initialize(master, host, options)
        @master = master
        @host = host
        @transport = options[:transport] || :plaintext
        @options = options
        @options[:user] = @options.delete(:user) || ENV['USER'] || ENV['USERNAME'] || "unknown"
        @options[:pass] = @options.delete(:password)
        @options[:port] = @options.delete(:port) || 5985
        @options[:basic_auth_only] = true unless defined? @options[:basic_auth_only]
      end

      #
      # create a shell and run command
      #
      def run_command(data)
        cid = UUIDTools::UUID.random_create.to_s
        EM.epoll
        EM.run do
          EM.defer(proc do
            WinRS::Log.debug("#{@host} => :run_command")
            @shell = Shell.new(self)
            @shell.on_output do |out|
              @master.relay_output_from_backend(@host, out)
            end
            @shell.on_error do |error|
              @master.relay_error_from_backend(@host, error)
            end
            @shell.on_close do |exit_code|
              @master.command_complete(@host, cid, exit_code)
            end
            @shell.run_command(data)
          end)
        end
        cid
      end

      #
      # Notify upstream master that the backend server is done
      # processing the request
      #
      def unbind
        WinRS::Log.debug("#{@host} => :unbind")
        @master.unbind_backend(@host)
      end
    end
  end
end
