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

    def self.followers_for_question_id(question_id)
        question_followers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                users.id, users.fname, users.lname
            FROM
                question_follows
            JOIN
                users ON user_id = users.id
            WHERE
                question_id = ?
        SQL

        question_followers.length > 0 ? question_followers.map {|person| User.new(person)} : nil
    end

    def self.followed_questions_for_user_id(user_id)
        questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                questions.id, questions.title, questions.body, questions.author_id
            FROM
                question_follows
            JOIN
                questions ON question_id = questions.id
            WHERE
                user_id = ?
        SQL
        questions.length > 0 ? questions.map {|quest| Question.new(quest)} : nil
    end

    def self.most_followed_questions(n)
        questions = QuestionDBConnection.instance.execute(<<-SQL, n)
            SELECT
                questions.id, questions.title, questions.body, questions.author_id    
            FROM
                question_follows
            JOIN
                questions ON question_id = questions.id
            GROUP BY
                question_id
            ORDER BY
                COUNT(question_id) DESC
            LIMIT 
                ?
        SQL
        questions.length > 0 ? questions.map {|quest| Question.new(quest)} : nil
    end
end