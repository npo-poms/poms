module Poms
  # Mixin for classes with a title and description.
  module HasBaseAttributes
    def title
      return @title if @title
      main_title = select_title_by_type 'MAIN'
      sub_title = select_title_by_type 'SUB'
      if sub_title && sub_title.match(main_title)
        @titel = sub_title
      else
        @titel = [main_title, sub_title].compact.join(': ')
      end
    end

    def description
      @description ||= begin
                         descriptions.first.value
                       rescue
                         nil
                       end
    end

    private

    def select_title_by_type(type)
      titles.select { |t| t.type == type }.map(&:value).first
    end
  end
end
