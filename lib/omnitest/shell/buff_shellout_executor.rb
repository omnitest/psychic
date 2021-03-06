require 'buff/shell_out'

module Omnitest
  module Shell
    class BuffShellOutExecutor
      include Omnitest::Core::Logger
      attr_reader :shell

      def execute(command, opts) # rubocop:disable Metrics/AbcSize
        @logger = opts.delete(:logger) || logger
        cwd = opts[:cwd] || Dir.pwd
        env = opts[:env] || {}
        # @shell.live_stream = IOToLog.new(@logger)
        shell_result = Dir.chdir(cwd) do
          Bundler.with_clean_env do
            Buff::ShellOut.shell_out(command, env)
          end
        end
        fail Errno::ENOENT, shell_result.stderr if shell_result.exitstatus == 127
        execution_result(command, shell_result)
      rescue SystemCallError => e
        execution_error = ExecutionError.new(e)
        execution_error.execution_result = execution_result(command, shell_result)
        raise execution_error
      end

      private

      def execution_result(command, shell_result)
        return nil if shell_result.nil?

        ExecutionResult.new(
          command: command,
          exitstatus: shell_result.exitstatus,
          stdout: shell_result.stdout,
          stderr: shell_result.stderr
        )
      end
    end
  end
end
