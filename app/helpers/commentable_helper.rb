module CommentableHelper
  def render_deleted_content(content)
    content_tag(:div, "This is a fragment of time, this #{content.class.name} was deleted")
  end

  def render_visible_content(content)
    safe_join([
                render("commentable/heading", content: content),
                render("commentable/content", content: content),
                render("commentable/interactions", content: content)
              ])
  end

  def render_thread_from(commentable_node, children_depth = 0)
    current_node = render(commentable_node, class_append: "child_depth_#{children_depth}")

    children_nodes = commentable_node.replies.map do |reply|
      render_thread_from(reply, children_depth + 1)
    end

    safe_join([current_node, children_nodes])
  end
end
