import { apolloProvider } from "./apolloProvider";
import { gql } from "graphql-tag";
import bcrypt from "bcryptjs";
import { extractHashTags, extractMentions } from "../utils/helpers";

const GET_TWEETS = () => {
  const query = gql`
    subscription {
      tweet(order_by: { created_at: desc }) {
        created_at
        content
        id
        image_url
        parent_tweet_id
        tweet_likes_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
        tweet_replies_aggregate {
          aggregate {
            count
          }
        }
        tweet_user {
          name
          username
          profile_picture_url
          premium
          id
        }
        tweet_retweets_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
        tweet_replies {
          created_at
          content
          id
          image_url
          parent_tweet_id
          tweet_likes_aggregate {
            aggregate {
              count
            }
            nodes {
              user_id
            }
          }
          tweet_user {
            name
            username
            profile_picture_url
            premium
            id
          }
          tweet_retweets_aggregate {
            aggregate {
              count
            }
            nodes {
              user_id
            }
          }
        }
      }
    }
  `;

  return apolloProvider.subscribe({ query });
};

const LISTEN_TO_NOTIFICATIONS = (user_id) => {
  const query = gql`
    subscription getNotifications($user_id: uuid!) {
      notification(
        where: { receiver_id: { _eq: $user_id } }
        order_by: { created_at: desc }
      ) {
        id
        created_at
        type
        message
        read
        receiver_id
        sender_id
        notification_user {
          name
          username
          profile_picture_url
        }
      }
    }
  `;
  return apolloProvider.subscribe({ query, variables: { user_id } });
};

const GET_TRENDING_HASHTAGS = () => {
  const query = gql`
    subscription {
      hashtag(order_by: {number_of_tweets: desc}) {
        text
        id
        number_of_tweets
      }
    }
  `;
  return apolloProvider.subscribe({ query });
};

const SEARCH_USERS = (username) => {
  const query = gql`
    subscription searchUsers($username: String!) {
      user(where: { username: { _ilike: $username } }) {
        id
        name
        username
        profile_picture_url
        premium
      }
    }
  `;
  return apolloProvider.subscribe({ query, variables: { username } });
};

const SEARCH = (search) => {
  const query = gql`
    query {
      user(where: { username: { _ilike: "%${search}%" } }) {
        id
        name
        username
        profile_picture_url
        premium
      }
      hashtag(where: { text: { _ilike: "%${search}%" } }) {
        id
        text
        number_of_tweets
      }
      tweet(where: { content: { _ilike: "%${search}%" } }) {
        created_at
        content
        id
        image_url
        parent_tweet_id
        tweet_likes_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
        tweet_user {
          name
          username
          profile_picture_url
          premium
          id
        }
        tweet_retweets_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
      }
    }
  `;
  
  try {
    return apolloProvider.query({ query });
  } catch (error) {
    console.log(error);
  }
};


const GET_SINGLE_TWEET = (id) => {
  const query = gql`
    subscription getSingleTweet($id: uuid!) {
      tweet(where: { id: { _eq: $id } }) {
        created_at
        content
        id
        image_url
        parent_tweet_id
        tweet_likes_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
        tweet_replies_aggregate {
          aggregate {
            count
          }
        }
        tweet_user {
          name
          username
          profile_picture_url
          premium
          id
        }
        tweet_retweets_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
        tweet_replies {
          created_at
          content
          id
          image_url
          parent_tweet_id
          tweet_likes_aggregate {
            aggregate {
              count
            }
            nodes {
              user_id
            }
          }
          tweet_user {
            name
            username
            profile_picture_url
            premium
            id
          }
          tweet_retweets_aggregate {
            aggregate {
              count
            }
            nodes {
              user_id
            }
          }
        }
      }
    }
  `;
  return apolloProvider.subscribe({ query, variables: { id } });
};


const GET_TWEETS_BY_USER = (author_id) => {
  const query = gql`
    subscription getUnfollowedUsers($author_id: uuid!) {
      tweet(
        where: { author_id: { _eq: $author_id } }
        order_by: { created_at: desc }
      ) {
        created_at
        content
        id
        image_url
        tweet_likes_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
        tweet_user {
          name
          username
          profile_picture_url
          premium
          id
        }
        tweet_retweets_aggregate {
          aggregate {
            count
          }
          nodes {
            user_id
          }
        }
      }
    }
  `;
  return apolloProvider.subscribe({ query, variables: { author_id } });
};

const GET_TWEET_BY_USER_LIKE = (author_id) => {
  const query = gql`
    subscription getUnfollowedUsers($author_id: uuid!) {
      user_by_pk(id: $author_id) {
        likes(order_by: {created_at: desc}) {
          tweet {
            created_at
            content
            id
            image_url
            parent_tweet_id
            tweet_user {
              name
              username
              profile_picture_url
              premium
              id
            }
            tweet_retweets_aggregate {
              aggregate {
                count
              }
              nodes {
                user_id
              }
            }
            tweet_replies {
              created_at
              content
              id
              image_url
              parent_tweet_id
              tweet_likes_aggregate {
                aggregate {
                  count
                }
                nodes {
                  user_id
                }
              }
              tweet_user {
                name
                username
                profile_picture_url
                premium
                id
              }
              tweet_retweets_aggregate {
                aggregate {
                  count
                }
                nodes {
                  user_id
                }
              }
            }
            tweet_likes_aggregate {
              aggregate {
                count
              }
              nodes {
                user_id
              }
            }
          }
        }
      }
    }
  `;
  return apolloProvider.subscribe({ query, variables: { author_id } });
};

const GET_USER = async (id) => {
  console.log(id);
  const query = gql`
    query {
      user(where: { id: { _eq: "${id}" } }) {
        id
        name
        username
        profile_picture_url
        bio
        location
        website
        created_at
      }
    }
  `;
  try {
    const response = await apolloProvider.query({ query });
    const user = response.data.user;
    return user;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const GET_USER_WITH_USERNAME = async (username) => {
  const query = gql`
    query {
      user(where: { username: { _eq: "${username}" } }) {
        id
        name
        username
        profile_picture_url
        bio
        location
        website
        created_at
        date_of_birth
        followers_aggregate {
          aggregate {
            count(distinct: true)
          }
        }
        following_aggregate {
          aggregate {
            count
          }
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.query({ query });
    const user = response.data.user[0];
    return user;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const GET_USER_WITH_PASSWORD = async (username, password) => {
  const query = gql`
    query {
      user(where: {_or: [{email: {_eq: "${username}"}}, {username: {_eq: "${username}"}}, {phone: {_eq: "${username}"}}]}) {
        premium
        date_of_birth
        bio
        email
        location
        name
        password
        profile_picture_url
        username
        website
        created_at
        id
      }
    }
  `;
  try {
    const response = await apolloProvider.query({ query });
    const users = response.data.user;
    if (users.length == 0) return null;
    if (bcrypt.compareSync(password, users[0].password)) {
      return users;
    } else {
      return null;
    }
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_NEW_USER = async (
  name,
  email,
  password,
  username,
  dateOfBirth
) => {
  const encryptedPassword = bcrypt.hashSync(password, 10);
  const mutation = gql`
    mutation {
      insert_user(
        objects: {
          name: "${name}"
          email: "${email}"
          password: "${encryptedPassword}"
          username: "${username}"
          date_of_birth: "${dateOfBirth}"
        }
      ) {
        returning {
          id
          name
          username
          profile_picture_url
          bio
          location
          website
          created_at
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({ mutation });
    const user = response.data.insert_user.returning[0];
    return user;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_HASHTAG = async (hashtag) => {
  const mutation = gql`
    mutation {
      insert_hashtag(
        objects: {
          text: "${hashtag}"
        },
        on_conflict: {
          constraint: hashtag_text_key,
          update_columns: [text]
        }
      ) {
        returning {
          id
          text
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({ mutation });
    const hashtag = response.data.insert_hashtag.returning[0];
    return hashtag;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_TWEET_HASHTAG = async (tweet_id, hashtag_id) => {
  const mutation = gql`
    mutation {
      insert_tweet_hashtag(
        objects: { hashtag_id: "${hashtag_id}", tweet_id: "${tweet_id}" }
        on_conflict: {
          constraint: tweet_hashtag_pkey
          update_columns: hashtag_id
        }
      ) {
        returning {
          id
          hashtag_id
          tweet_id
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({ mutation });
    const tweet_hashtag = response.data.insert_tweet_hashtag.returning[0];
    return tweet_hashtag;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const GET_TWEETS_OF_HASHTAG = (hashtag) => {
  const query = gql`
    subscription {
      hashtag(where: { text: { _eq: "${hashtag}" } }) {
        id
        text
        tweet_hashtags {
          tweet {
            id
            content
            image_url
            created_at
            tweet_user {
              id
              name
              username
              profile_picture_url
              premium
            }
            tweet_likes_aggregate {
              aggregate {
                count
              }
            }
            tweet_retweets_aggregate {
              aggregate {
                count
              }
            }
          }
        }
      }
    }
  `;

  return apolloProvider.subscribe({ query });
};

const CREATE_NEW_TWEET = async (content, user_id, image_url) => {
  const mutation = gql`
    mutation {
      insert_tweet(
        objects: {
          content: "${content}"
          image_url: "${image_url}"
          author_id: "${user_id}"
        }
      ) {
        returning {
          id
          content
          image_url
          created_at
          author_id
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({ mutation });
    const tweet = response.data.insert_tweet.returning[0];
    const hashtags = extractHashTags(content);
    hashtags
      ? hashtags.forEach(async (hashtag) => {
          const hashtagResponse = await CREATE_HASHTAG(hashtag);
          console.log(tweet, hashtagResponse);
          await CREATE_TWEET_HASHTAG(tweet.id, hashtagResponse.id);
        })
      : null;
    const mentions = extractMentions(content);
    mentions
      ? mentions.forEach(async (mention) => {
          const username = mention.substring(1);
          const userResponse = await GET_USER_WITH_USERNAME(username);
          if (userResponse) {
            await CREATE_MENTION(tweet.id, userResponse.id);
          }
        })
      : null;
    return tweet;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_MENTION = async (tweet_id, user_id) => {
  const mutation = gql`
    mutation {
      insert_mention(
        objects: { tweet_id: "${tweet_id}", user_id: "${user_id}" }
        on_conflict: {
          constraint: mention_user_id_tweet_id_key
          update_columns: [tweet_id, user_id]
        }
      ) {
        returning {
          id
          tweet_id
          user_id
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({ mutation });
    const mention = response.data.insert_mention.returning[0];
    return mention;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_NEW_LIKE = async (tweet_id, user_id) => {
  const mutation = gql`
    mutation createNewLike($tweet_id: uuid!, $user_id: uuid!) {
      insert_like(
        objects: { tweet_id: $tweet_id, user_id: $user_id }
        on_conflict: {
          constraint: like_user_id_tweet_id_key
          update_columns: []
        }
      ) {
        affected_rows
      }
    }
  `;

  const deleteMutation = gql`
    mutation deleteLike($tweet_id: uuid!, $user_id: uuid!) {
      delete_like(
        where: { tweet_id: { _eq: $tweet_id }, user_id: { _eq: $user_id } }
      ) {
        affected_rows
      }
    }
  `;

  try {
    const response = await apolloProvider.mutate({
      mutation,
      variables: { tweet_id, user_id },
    });
    if (response.data.insert_like.affected_rows === 0) {
      // if there is a conflict, delete the conflicted row and create a new one
      await apolloProvider.mutate({
        mutation: deleteMutation,
        variables: { tweet_id, user_id },
      });
    }
    return response;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_NEW_RETWEET = async (tweet_id, user_id) => {
  const mutation = gql`
    mutation createNewRetweet($tweet_id: uuid!, $user_id: uuid!) {
      insert_retweet(
        objects: { tweet_id: $tweet_id, user_id: $user_id }
        on_conflict: {
          constraint: retweet_user_id_tweet_id_key
          update_columns: []
        }
      ) {
        affected_rows
      }
    }
  `;

  const deleteMutation = gql`
    mutation deleteRetweet($tweet_id: uuid!, $user_id: uuid!) {
      delete_retweet(
        where: { tweet_id: { _eq: $tweet_id }, user_id: { _eq: $user_id } }
      ) {
        affected_rows
      }
    }
  `;

  try {
    const response = await apolloProvider.mutate({
      mutation,
      variables: { tweet_id, user_id },
    });
    if (response.data.insert_retweet.affected_rows === 0) {
      // if there is a conflict, delete the conflicted row and create a new one
      await apolloProvider.mutate({
        mutation: deleteMutation,
        variables: { tweet_id, user_id },
      });
    }
    return response;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const UPLOAD_IMAGE = async (
  data,
  tweet_id,
  user_id,
  title = null,
  description = null
) => {
  const mutation = gql`
    mutation uploadImage(
      $data: bytea!
      $tweet_id: uuid!
      $user_id: uuid!
      $title: String
      $description: String
    ) {
      insert_image(
        objects: {
          data: $data
          tweet_id: $tweet_id
          user_id: $user_id
          title: $title
          description: $description
        }
      ) {
        returning {
          id
          image
          title
          description
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({
      mutation,
      variables: {
        data: new Uint8Array(data),
        tweet_id,
        user_id,
        title,
        description,
      },
    });
    const image = response.data.insert_image.returning[0];
    return image;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const GET_CONVERSATION_OF_USER = (user_id) => {
  const query = gql`
    subscription getConversationsOfUser($user_id: uuid!) {
      user_by_pk(id: $user_id) {
        user_conversations_2(
          order_by: {
            conversation_messages_aggregate: { max: { created_at: desc } }
          }
        ) {
          id
          user1_id
          user2_id
          conversation_messages(limit: 1, order_by: { created_at: desc }) {
            content
            created_at
          }
          conversation_user {
            id
            username
            profile_picture_url
            premium
            name
          }
          conversation_user2 {
            id
            name
            premium
            profile_picture_url
            username
          }
        }
        user_conversations(
          order_by: {
            conversation_messages_aggregate: { max: { created_at: desc } }
          }
        ) {
          id
          user1_id
          user2_id
          conversation_messages(limit: 1, order_by: { created_at: desc }) {
            content
            created_at
          }
          conversation_user {
            id
            username
            profile_picture_url
            premium
            name
          }
          conversation_user2 {
            id
            name
            premium
            profile_picture_url
            username
          }
        }
      }
    }
  `;

  return apolloProvider.subscribe({ query, variables: { user_id } });
};

const GET_MESSAGES_OF_CONVERSATION = (conversation_id) => {
  const query = gql`
    subscription getMessagesOfConversation($conversation_id: uuid!) {
      conversation_by_pk(id: $conversation_id) {
        conversation_messages {
          content
          created_at
          recipient_id
          sender_id
        }
        conversation_user {
          id
          bio
          created_at
          name
          premium
          profile_picture_url
          username
          followers_aggregate {
            aggregate {
              count
            }
          }
        }
        conversation_user2 {
          id
          bio
          created_at
          name
          premium
          profile_picture_url
          username
          followers_aggregate {
            aggregate {
              count
            }
          }
        }
      }
    }
  `;

  return apolloProvider.subscribe({ query, variables: { conversation_id } });
};

const POST_NEW_MESSAGE = async (
  content,
  sender_id,
  recipient_id,
  conversation_id
) => {
  const mutation = gql`
    mutation postNewMessage(
      $content: String!
      $sender_id: uuid!
      $recipient_id: uuid!
      $conversation_id: uuid!
    ) {
      insert_message(
        objects: {
          content: $content
          sender_id: $sender_id
          recipient_id: $recipient_id
          conversation_id: $conversation_id
        }
      ) {
        returning {
          content
          created_at
          recipient_id
          sender_id
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({
      mutation,
      variables: {
        content,
        sender_id,
        recipient_id,
        conversation_id,
      },
    });
    const message = response.data.insert_message.returning[0];
    return message;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_CONVERSATION = async (user1_id, user2_id) => {
  const mutation = gql`
    mutation createConversation($user1_id: uuid!, $user2_id: uuid!) {
      insert_conversation(
        objects: { user1_id: $user1_id, user2_id: $user2_id }
      ) {
        returning {
          id
        }
      }
    }
  `;
  const query = gql`
    query getConversation($user1_id: uuid!, $user2_id: uuid!) {
      conversation(
        where: {
          _or: [
            {
              _and: [
                { user1_id: { _eq: $user1_id } }
                { user2_id: { _eq: $user2_id } }
              ]
            }
            {
              _and: [
                { user1_id: { _eq: $user2_id } }
                { user2_id: { _eq: $user1_id } }
              ]
            }
          ]
        }
      ) {
        id
      }
    }
  `;
  try {
    const response = await apolloProvider.query({
      query,
      variables: {
        user1_id,
        user2_id,
      },
    });
    const conversation = response.data.conversation[0];
    if (conversation) {
      return conversation;
    }
    const response2 = await apolloProvider.mutate({
      mutation,
      variables: {
        user1_id,
        user2_id,
      },
    });
    const conversation2 = response2.data.insert_conversation.returning[0];
    return conversation2;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const FOLLOW_UNFOLLOW_USER = async (follower_id, user_id) => {
  const mutation = gql`
    mutation followUnfollowUser($follower_id: uuid!, $user_id: uuid!) {
      insert_follower(
        objects: { follower_id: $follower_id, user_id: $user_id }
        on_conflict: {
          constraint: follower_user_id_follower_id_key
          update_columns: []
        }
      ) {
        returning {
          created_at
          follower_id
          user_id
        }
      }
    }
  `;

  const mutation2 = gql`
    mutation followUnfollowUser($follower_id: uuid!, $user_id: uuid!) {
      delete_follower(
        where: {
          follower_id: { _eq: $follower_id }
          user_id: { _eq: $user_id }
        }
      ) {
        returning {
          created_at
          follower_id
          user_id
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({
      mutation,
      variables: {
        follower_id,
        user_id,
      },
    });
    const follow = response.data.insert_follower.returning[0];
    if (follow) {
      return follow;
    }
    const response2 = await apolloProvider.mutate({
      mutation: mutation2,
      variables: {
        follower_id,
        user_id,
      },
    });
    const unfollow = response2.data.delete_follower.returning[0];
    return unfollow;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const DOES_FOLLOW_USER = (follower_id, user_id) => {
  const query = gql`
    subscription doesFollowUser($follower_id: uuid!, $user_id: uuid!) {
      follower(
        where: {
          follower_id: { _eq: $follower_id }
          user_id: { _eq: $user_id }
        }
      ) {
        created_at
        follower_id
        user_id
      }
    }
  `;
  return apolloProvider.subscribe({
    query,
    variables: { follower_id, user_id },
  });
};

const GET_UNFOLLOWED_USERS = (user_id) => {
  const query = gql`
    subscription getUnfollowedUsers($user_id: uuid!) {
      user(
        where: {
          _and: [
            { id: { _neq: $user_id } }
            {
              _not: {
                _or: [
                  { followers: { follower_id: { _eq: $user_id } } }
                  { id: { _eq: $user_id } }
                ]
              }
            }
          ]
        }
        limit: 3
      ) {
        id
        username
        name
        profile_picture_url
      }
    }
  `;
  return apolloProvider.subscribe({ query, variables: { user_id } });
};

const POST_NEW_REPLY = async (content, user_id, tweet_id) => {
  const mutation = gql`
    mutation postNewReply(
      $content: String!
      $user_id: uuid!
      $tweet_id: uuid!
    ) {
      insert_tweet(
        objects: {
          content: $content
          author_id: $user_id
          parent_tweet_id: $tweet_id
        }
      ) {
        returning {
          content
          created_at
          id
          author_id
          parent_tweet_id
        }
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({
      mutation,
      variables: {
        content,
        user_id,
        tweet_id,
      },
    });

    return response.data.insert_tweet.returning[0];
  } catch (error) {
    console.error(error);
    return [];
  }
};

export {
  GET_TWEETS,
  GET_USER,
  GET_USER_WITH_PASSWORD,
  CREATE_NEW_USER,
  CREATE_NEW_TWEET,
  CREATE_NEW_LIKE,
  GET_USER_WITH_USERNAME,
  GET_TWEETS_OF_HASHTAG,
  CREATE_NEW_RETWEET,
  UPLOAD_IMAGE,
  GET_CONVERSATION_OF_USER,
  GET_MESSAGES_OF_CONVERSATION,
  POST_NEW_MESSAGE,
  CREATE_CONVERSATION,
  FOLLOW_UNFOLLOW_USER,
  DOES_FOLLOW_USER,
  GET_UNFOLLOWED_USERS,
  GET_TWEETS_BY_USER,
  GET_TWEET_BY_USER_LIKE,
  POST_NEW_REPLY,
  LISTEN_TO_NOTIFICATIONS,
  GET_SINGLE_TWEET,
  GET_TRENDING_HASHTAGS,
  SEARCH,
  SEARCH_USERS,
};
