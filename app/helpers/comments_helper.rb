module CommentsHelper
  def render_comments_and_boosts(bubble)
    combined_collection = (
      bubble.comments +
      bubble.boosts +
      bubble.assignments
    ).sort_by(&:created_at)

    safe_join([
      render_creator_summary(bubble, combined_collection),
      render_remaining_items(combined_collection)
    ])
  end

  private
    def render_comments_and_boosts(bubble)
      combined_collection = (
        bubble.comments +
        bubble.boosts +
        bubble.assignments
      ).sort_by(&:created_at)

      safe_join([
        render_creator_summary(bubble, combined_collection),
        render_remaining_items(combined_collection)
      ])
    end

    def render_creator_summary(bubble, combined_collection)
      content_tag(:div, class: "comment--upvotes flex-inline flex-wrap align-start gap fill-white border-radius center position-relative") do
        summary = "Added by #{bubble.creator.name} #{time_ago_in_words(bubble.created_at)} ago"

        initial_assignment = combined_collection.find { |item| item.is_a?(Assignment) }
        summary += ", assigned to #{initial_assignment.user.name}" if initial_assignment

        summary += render_initial_boosts(combined_collection)
        summary.html_safe
      end
    end

    def render_initial_boosts(combined_collection)
      grouped_boosts = []
      combined_collection.each do |item|
        break unless item.is_a?(Boost)
        grouped_boosts << item
      end

      if grouped_boosts.any?
        user_boosts = grouped_boosts.group_by(&:creator).transform_values(&:count)
        boost_summaries = user_boosts.map { |user, count| "#{user.name} +#{count}" }
        ", #{boost_summaries.to_sentence}"
      else
        ""
      end
    end

    def render_remaining_items(combined_collection)
      grouped_items = []
      safe_join(combined_collection.drop(initial_items_count(combined_collection)).map do |item|
        case item
        when Boost, Assignment
          grouped_items << item
          next if combined_collection[combined_collection.index(item) + 1].is_a?(Boost) || combined_collection[combined_collection.index(item) + 1].is_a?(Assignment)
          render_grouped_items(grouped_items.dup).tap { grouped_items.clear }
        when Comment
          render partial: "comments/comment", object: item
        end
      end.compact)
    end

    def render_grouped_items(items)
      return if items.empty?

      boosts = items.select { |item| item.is_a?(Boost) }
      assignments = items.select { |item| item.is_a?(Assignment) }

      content_tag(:div, class: "comment--upvotes flex-inline flex-wrap align-start gap fill-white border-radius center position-relative") do
        combined_summaries = [
          render_grouped_boosts(boosts),
          render_grouped_assignments(assignments)
        ].flatten.compact

        combined_summaries.to_sentence.html_safe
      end
    end

    def render_grouped_boosts(boosts)
      return if boosts.empty?
      user_boosts = boosts.group_by(&:creator).transform_values(&:count)
      user_boosts.map { |user, count| "#{user.name} +#{count}" }
    end

    def render_grouped_assignments(assignments)
      return if assignments.empty?
      assignments.map { |assignment| "Assigned to #{assignment.user.name} #{time_ago_in_words(assignment.created_at)} ago" }
    end

    def initial_items_count(combined_collection)
      count = 0
      combined_collection.each do |item|
        break if item.is_a?(Comment)
        count += 1
      end
      count
    end

    def initial_boosts_count(combined_collection)
      combined_collection.take_while { |item| item.is_a?(Boost) }.count
    end
end
