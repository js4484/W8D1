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

end