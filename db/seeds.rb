# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Voter.delete_all
Jet.delete_all
Post.delete_all
Comment.delete_all

voter = Voter.create(username: 'test')

Jet.create(
  owner: voter,
  name: 'all',
  description: 'some description'
)

post = Post.create(
  title: 'First post',
  body: 'This is my first post',
  author: voter,
  jet_id: 'all'
)

comment = Comment.create(
  body: 'This is a comment of the first post',
  author: voter,
  post_id: post.id,
  commentable_type: Post,
  commentable_id: post.id,
  parent_id: nil
)
comment2 = Comment.create(
  body: 'This is a comment of the first comment',
  author: voter,
  post_id: post.id,
  commentable_type: Comment,
  commentable_id: comment.id,
  parent_id: comment.id
)
Comment.create(
  body: 'A glorius comment',
  author: voter,
  post_id: post.id,
  commentable_type: Comment,
  commentable_id: comment2.id,
  parent_id: comment2.id
)
Comment.create(
  body: 'This is a second comment of the first post',
  author: voter,
  post_id: post.id,
  commentable_type: Post,
  commentable_id: post.id,
  parent_id: nil
)
