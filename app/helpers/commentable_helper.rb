module CommentableHelper
  def render_commentable_children(commentable_node, children_depth = 0)
    current_node = render(commentable_node, class_append: "child_depth_#{children_depth}")

    children_nodes = commentable_node.replies.map do |reply|
      render_commentable_children(reply, children_depth + 1)
    end

    current_node + children_nodes.join.html_safe
  end
end
