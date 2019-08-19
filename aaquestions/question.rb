class Question
    attr_accessor :id, :title, :body, :author_id

    def self.all
        data = QuestionDBConnection.instance.execute(<<-SQL)
            SELECT
                *
            FROM
                questions
        SQL

        data.map { |datum| Question.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def self.find_by_id(id)
        question = QuestionDBConnection.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        question.length > 0 ? Question.new(question.first) : nil
    end

    def self.find_by_title(title)
        question = QuestionDBConnection.instance.execute(<<-SQL, title)
            SELECT
                *
            FROM
                questions
            WHERE
                title = ?
        SQL
        question.length > 0 ? Question.new(question.first) : nil
    end

    def self.find_by_author_id(author_id)
        questions = QuestionDBConnection.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        questions.length > 0 ? questions.map {|question| Question.new(question)} : nil
    end

    def author
        User.find_by_id(@author_id)
    end
    
    def replies
        Reply.find_by_question_id(@id)
    end

    def followers
        QuestionFollow.followers_for_question_id(@id)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end
    
    def likers
        QuestionLike.likers_for_question_id(@id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(@id)
    end

    def self.most_liked(n)
        QuestionLikes.most_liked_questions(n)
    end
end