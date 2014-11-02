
module Barthes
	class Reporter
		class Default
			def initialize(options)
				@options = options
			end

			def before_feature(num, name)
				puts "#{name} (##{num})"
			end

			def before_scenario(num, name, scenario, scenarios)
				puts ("\t" * scenarios.size) + "#{name} (##{num})"
			end

			def before_action(num, name, action, scenarios)
				print ("\t" * scenarios.size) + "#{name} (##{num})"
			end

			def after_action(num, name, action, scenarios, result)
				if @options[:verbose]
					puts
					puts indent scenarios.size + 1, "request:"
					puts indent scenarios.size + 2, JSON.pretty_generate(action['request'])
					puts indent scenarios.size + 1, "response:"
					puts indent scenarios.size + 2, JSON.pretty_generate(action['response'])
				end
				expectations = result['expectations']
				expectations.each do |expectation|
					if expectation['result'] == false
						puts indent scenarios.size + 1, "failed expectation:"
						puts indent scenarios.size + 2, JSON.pretty_generate(expectation)
					end
				end
				flag = ''
				if expectations.empty? || expectations.all? {|r| r['result'] == true }
					flag = 'success'
				else
					flag = 'failure'
				end
				puts indent(scenarios.size, " -> #{flag}")
			end

			def indent(num, string)
				string.split("\n").map do |line|
					("\t" * num) + line
				end.join("\n")
			end
		end
	end
end