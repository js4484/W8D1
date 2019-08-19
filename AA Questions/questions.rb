require 'sqlite3'
require 'singleton'
require_relative 'user.rb'
require_relative 'reply.rb'
require_relative 'questionlikes.rb'
require_relative 'question.rb'
require_relative 'questionfollows.rb'

class QuestionDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true;
        self.results_as_hash = true;
    end
end