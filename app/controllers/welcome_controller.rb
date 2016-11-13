class WelcomeController < ApplicationController

  def initialize
    @fields = %w{ first_name^4 last_name^4 email^5 hdc^3
                  address^2 profile_url^4 avatar^1 phone_number^4
                  fav_color^3 company_name^3 company_city^2}
    @slop_factor = 20
    @min_score = 0.01
    @default_operator = 'OR'
    @function_score = [
        {
            filter: {
                exists: {
                    field: 'email'
                }
            },
            script_score: {
                script: "2"
            }
        },
        {
            filter: {
                exists: {
                    field: 'company_name'
                }
            },
            script_score: {
                script: "2"
            }
        },
        {
            filter: {
                exists: {
                    field: 'profile_url'
                }
            },
            script_score: {
                script: '2'
            }
        },
        {
            filter: {
                exists: {
                    field: 'first_name'
                }
            },
            script_score: {
                script: '3'
            }
        }
    ]
  end

  def perform_search(query)
    parameters = {
        query: {
            function_score: {
                min_score: @min_score,
                query: {
                    query_string: {
                        fields: @fields,
                        query: query,
                        default_operator: @default_operator,
                        phrase_slop: @slop_factor,
                        auto_generate_phrase_queries: true
                    }
                },
                functions: @function_score,
                score_mode: 'sum'
            }
        }
    }
  end

  def index
    if params[:search_string]
      search_string = params[:search_string].strip
      @response =  FullTextSearch.search(perform_search(search_string), :size => 100)
    end
  end


end

