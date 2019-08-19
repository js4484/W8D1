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

    def self.likers_for_question_id(question_id)
        users = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                user_id, users.fname, users.lname   
            FROM
                question_likes
            JOIN
                users ON user_id = users.id
            WHERE
                question_id = ?
           
        SQL
        users.length > 0 ? users.map {|user| User.new(user)} : nil
    end

    def self.num_likes_for_question_id(question_id)
        likes = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                COUNT(question_id) AS count
            FROM
                question_likes
            WHERE
                question_id = ?
        SQL

        likes[0]["count"]
    end

    def self.liked_questions_for_user_id(user_id)
        questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                questions.id, questions.title, questions.body, questions.author_id
            FROM
                question_likes
            LEFT OUTER JOIN
                questions ON question_id = questions.id
            WHERE
                user_id = ?
        SQL

        questions.length > 0 ? questions.map {|question| Question.new(question)} : nil
    end

    def self.most_liked_questions(n)
        questions = QuestionDBConnection.instance.execute(<<-SQL, n)
            SELECT
                questions.id, questions.title, questions.body, questions.author_id    
            FROM
                question_likes
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