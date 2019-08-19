class QuestionLike
    attr_accessor :id, :question_id, :user_id

    def self.all
        data = QuestionDBConnection.instance.execute(<<-SQL)
            SELECT
                *
            FROM
                question_likes
        SQL

        data.map { |datum| QuestionLike.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        question_like = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *   
            FROM
                question_likes
            WHERE
                id = ?
        SQL
        question_like.length > 0 ? QuestionLike.new(question_like.first) : nil
    end
end