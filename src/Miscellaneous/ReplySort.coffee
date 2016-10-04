ReplySort =
  init: ->
    return unless Conf['Sort by Replies'] and g.VIEW is 'thread'
    @sortedPosts: [[]]
    Post.callbacks.push
      name: 'Reply Sort'
      cb:   @node

  node: ->
    return if !@isReply or @isClone or @isFetchedQuote
    # Initializing values
    @replies ?= 0
    ReplySort.sortedPosts[0].push @fullID
    # Sort posts into a tiered array
    for quote in @quotes
      post = g.posts[quote]
      # Only handle valid quoted posts and don't sort the OP
      continue unless post and post.isReply
      # Remove from previous tier
      if (i = ReplySort.sortedPosts[post.replies].indexOf quote) isnt -1
        ReplySort.sortedPosts[post.replies].splice i, 1
      # Add to new tier
      ReplySort.sortedPosts[++post.replies] ?= []
      ReplySort.sortedPosts[post.replies].push quote
      # Insert before first post of lower tier. Don't insert if tier gap
      if ReplySort.sortedPosts[post.replies-1].length
        $.before g.posts[ReplySort.sortedPosts[post.replies-1][0]].nodes.root, post.nodes.root
    return
