require 'hanoi/jane'

module Hanoi
  module Jane
    class CLI < ::Thor
      desc 'version', 'Print hanoi version'
      def version
        puts 'hanoi version #{VERSION}'
      end
      map %w(-v --version) => :version

      desc 'phat', "Solve the towers against the pHAT's webserver"
      option :phat, type: :string, required: true
      option :constrained, type: :boolean
      option :interval, type: :numeric, default: 0.1

      def phat
        at = AnimatedTowers.new do |a|
          a.towers = ConstrainedTowers
          a.discs = 5
          a.height = 7
        end

        at.each do |frame|
          Hanoi::Jane.hit_phat frame.stacks, frame.value, options[:phat]
          interval = options[:interval]
          if frame.type == :tween
            interval = interval * 0.1
          end
          sleep interval
        end
      end

      desc 'console', 'Solve the towers on the console'
      option :discs, type: :numeric, default: 3
      option :constrained, type: :boolean, default: true
      option :interval, type: :numeric, default: 0.5
      option :height, type: :numeric, default: 2
      option :fancy, type: :boolean, default: false

      def console
        at = AnimatedTowers.new do |a|
          a.towers = options[:constrained] ? ConstrainedTowers : Towers
          a.discs = options[:discs]
          a.height = options[:discs] + options[:height]
        end

        at.each do |frame|
          system('clear')

          c = Formatters::Console.new do |c|
            c.stacks = frame.stacks
            c.fancy = options[:fancy]
          end

          puts frame.value
          puts c

          interval = options[:interval]
          if frame.type == :tween
            interval = interval * 0.1
          end
          sleep interval
        end

        puts '%d moves to solve for %d discs' % [at.towers.total, at.discs]
      end
    end
  end
end
