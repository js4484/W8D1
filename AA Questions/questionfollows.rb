class QuestionFollow
    attr_accessor :id, :user_id, :question_id

    def self.all
        data = QuestionDBConnection.instance.execute(<<-SQL)
            SELECT
                *
            FROM
                question_follows
        SQL

        data.map { |datum| QuestionFollow.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.find_by_id(id)
        question_follow = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL
        question_follow.length > 0 ? QuestionFollow.new(question_follow.first) : nil
    end

    
end