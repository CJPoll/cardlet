require 'securerandom'
require 'cardlet/cards/card'

module Cardlet
	module Cards
		class FacetedQuestion < Card
			attr_accessor :prompt
			attr_reader :facets, :uuid, :tags

			def initialize(hash)
				@uuid = hash['uuid'] || SecureRandom.uuid
				@prompt = hash['prompt']
				@facets = hash['facets']
				@tags = hash['tags'] || []
			end

			def correct?(response)
				(response - @facets).empty? && (@facets - response).empty?
			end

			def answer
				@facets
			end

			def as_json
				{
					'uuid' => @uuid,
					'type' => type,
					'prompt' => @prompt,
					'facets' => @facets,
					'tags' => @tags
				}
			end

			def type
				'faceted_question'
			end
		end
	end
end
