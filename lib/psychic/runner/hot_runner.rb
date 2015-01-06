module Psychic
  class Runner
    class HotRunner
      include BaseRunner
      def initialize(opts = {})
        super
        @tasks = hints['tasks'] || {}
        @known_tasks = @tasks.keys
      end

      def task_for(task_name)
        return @tasks[task_name] if @tasks.include? task_name
        super
      end
    end
  end
end
