# Proof of concept right now.
# Would like to add more sorting options and improve performance.
PostSort =
  sortedPosts: []
  init: ->
    return unless g.VIEW is 'thread'

    @sortedPosts[0] = []
    Post.callbacks.push
      name: 'Post Sort'
      cb:   @node

  node: ->
    return if !@isReply or @isClone or @isFetchedQuote
    @replies ?= 0
    PostSort.sortedPosts[0].push @fullID
    for quote in @quotes
      post = g.posts[quote]
      # Only handle valid quoted posts and don't sort the OP
      continue unless post and post.isReply
      # Remove from previous tier
      if (i = PostSort.sortedPosts[post.replies].indexOf quote) isnt -1
        PostSort.sortedPosts[post.replies].splice i, 1
      # Add to new tier
      PostSort.sortedPosts[++post.replies] ?= []
      PostSort.sortedPosts[post.replies].push quote
      # Move element
      if PostSort.sortedPosts[post.replies-1].length
        $.before g.posts[PostSort.sortedPosts[post.replies-1][0]].nodes.root, post.nodes.root
    return
