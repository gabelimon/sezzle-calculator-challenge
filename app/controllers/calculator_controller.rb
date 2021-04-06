FLOAT_PATTERN = /\d*\.?\d+/

def match_all(needle, haystack)
  # This code was from SO so we can get the match data https://stackoverflow.com/a/35964234
  needle.to_enum(:scan, haystack).map { Regexp.last_match }
end

# Helper method
def parse_equation_results(formula)
  simple_formula = formula
  matches = match_all(simple_formula, /\(([^()]+)\)/)

  while matches.any? do
    matches.each do |match|
      simple_formula.gsub!(match[0], parse_equation_results(match[1]).to_s)
    end

    matches = match_all(simple_formula, /\([^()]+\)/)
  end

  %i(* + -).each do |op|
    escaped_op = %i(* +).include?(op) ? ('\\' + op.to_s).to_sym : op
    formula_pattern = /(#{FLOAT_PATTERN})#{escaped_op}(#{FLOAT_PATTERN})/

    # This code was from SO so we can get the match data https://stackoverflow.com/a/35964234
    matches = match_all(simple_formula, formula_pattern)

    while matches.any? do
      matches.each do |match|
        result = match[1].to_f.public_send(op, match[2].to_f).to_s
        simple_formula.gsub!(match[0], result)
      end

      matches = match_all(simple_formula, formula_pattern)
    end
  end

  simple_formula.to_f
end


class CalculatorController < ApplicationController
  before_action :authenticate_user!

  def index
    @calculations = Calculation.order(created_at: :desc).limit(10)
  end

  def calculate
    # Switch from x and X to *
    converted_formula = params['formula'].gsub(' ', '').gsub(/x/i, '*')
    result = parse_equation_results(converted_formula)

    Calculation.create(
        formula: params['formula'],
        result: result,
        user_id: current_user.id
    )
    redirect_to '/'
  end
end
