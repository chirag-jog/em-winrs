#
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

module EventMachine
  module WinRS
    class Shell
      include EM::Deferrable

      attr_accessor :server

      def initialize(server)
        @server = server
        WinRS::Log.debug("#{server.host} => :shell_open")
        @out_channel = EM::Channel.new
        @err_channel = EM::Channel.new
      end

      #
      # called whenever the shell has output
      #
      def on_output(&block)
        @out_channel.subscribe block
      end

      #
      # called whenever the shell has error output
      #
      def on_error(&block)
        @err_channel.subscribe block
      end

      #
      # called whenever the shell is closed
      #
      def on_close(&block)
        @on_close = block
      end

      #
      # Open a shell and run a comamnd
      #
      def run_command(command)
	creds = ""
	transport = ""
        if server.options[:user] and server.options[:pass]
	  creds = " -u:#{server.options[:user]} -p:#{server.options[:pass]} "
	  if server.transport != :plaintext
	    transport = " -usessl"
	  end
	end
        winrs_command = "winrs -R:#{server.host} #{transport} #{creds} \"#{command}\" 2>&1"
        WinRS::Log.debug("Executing #{winrs_command}")
        output = IO.popen(winrs_command).read
        #XXX Using IO, we cannot capture stderr seperately 
        @out_channel.push(output)
        #XXX We dont know the exit status
        @last_exit_code = 0
	@on_close.call(@last_exit_code)
	0
      end
    end
  end
end
