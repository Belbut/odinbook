module CommentableHelper
  def render_deleted_content(content)
    content_tag(:div, "This is a fragment of time, this #{content.model_name} was deleted")
  end

  def render_visible_content(content)
    safe_join([
                render("commentable/heading", content: content),
                render("commentable/content", content: content),
                render("commentable/interactions", content: content)
              ])
  end

  def render_replies_tree(content)
    trees = render_tree_from(content, render_first_node: false)

    content_tag(:section, trees, class: "replies tree")
  end

  def edit_link_for(content)
    return unless content.author == current_user

    link_to "Edit #{content.model_name}", edit_polymorphic_path(content)
  end

  private

  def render_tree_from(commentable_node, children_depth = 0, render_first_node: true)
    current_node = render(commentable_node, class_append: "child_depth_#{children_depth}") if render_first_node

    children_nodes = commentable_node.replies.map do |reply|
      render_tree_from(reply, children_depth + 1)
    end

    safe_join([current_node, children_nodes].compact)
  end
end
