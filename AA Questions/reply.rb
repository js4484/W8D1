
class Reply
    attr_accessor :id, :question_id, :user_id, :body, :parent_id

    def self.all
        data = QuestionDBConnection.instance.execute(<<-SQL)
            SELECT
                *
            FROM
                replies
        SQL

        data.map { |datum| Reply.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
        @body = options['body']
        @parent_id = options['parent_id']
    end

    def self.find_by_id(id)
        reply = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        reply.length > 0 ? Reply.new(reply.first) : nil
    end
    def self.find_by_user_id(user_id)
        replies = QuestionDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
        replies.length > 0 ? replies.map{ |reply| Reply.new(reply)} : nil
    end
     def self.find_by_question_id(question_id)
        replies = QuestionDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        replies.length > 0 ? replies.map{ |reply| Reply.new(reply)} : nil
    end
    def author
        User.find_by_id(@author_id)
    end
    
    def question
        Question.find_by_id(@question_id)
    end

    def parent_reply
        raise "#{self} has no parent" unless @parent_id
        Reply.find_by_id(@parent_id)
    end

    def child_replies
        replies = QuestionDBConnection.instance.execute(<<-SQL, @id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_id = ?
        SQL

        replies.length > 0 ? replies.map {|reply| Reply.new(reply)} : nil
    end
end
