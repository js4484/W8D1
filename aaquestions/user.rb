class User
    attr_accessor :id, :fname, :lname

    def self.all
        data = QuestionDBConnection.instance.execute(<<-SQL)
            SELECT
                *
            FROM
                users
        SQL

        data.map { |datum| User.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname'] 
    end

    def self.find_by_id(id)
        user = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        user.length > 0 ? User.new(user.first) : nil
    end

    def self.find_by_name(fname, lname)
        user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        user.length > 0 ? User.new(user.first) : nil
    end
    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end
    def followed_questions
        QuestionFollow.followed_questions_for_user_id(@id)
    end
    def liked_questions
        QuestionLike.liked_questions_for_user_id(@id)
    end

    def average_karma
        questions_and_likes = QuestionDBConnection.instance.execute(<<-SQL, @id )

        SELECT
            CAST(COUNT(DISTINCT(questions.id)) AS FLOAT), COUNT(question_likes.id) 
        FROM
            questions
        LEFT OUTER JOIN
            question_likes on question_id = questions.id
        WHERE
            author_id = ?;
        SQL

        questions_and_likes.first / questions_and_likes.last
    end
    
    def save
        if @id
            insertion = QuestionDBConnection.instance.execute(<<-SQL, @id, @fname, @lname)
            UPDATE
                users
            SET
                id = ?,
                fname = ?,
                lname = ?
            SQL
            self
        else
            insertion = QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname)
            INSERT INTO 
                users(fname, lname)
            VALUES
                (?, ?)
            SQL

            @id = QuestionDBConnection.instance.last_insert_row_id
        end
    end
    def update

    end
    
end