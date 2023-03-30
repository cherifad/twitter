import { apolloProvider } from "./apolloProvider";
import { gql } from "graphql-tag";
import bcrypt from "bcryptjs";
import { extractHashTags } from "../utils/helpers";

const GET_TWEETS = () => {
  const query = gql`
    subscription {
      tweet(order_by: { created_at: desc }) {
        created_at
        content
        id
        image_url
        tweet_likes_aggregate {
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
        }
      }
    }
  `;

  return apolloProvider.subscribe({ query });
};

const GET_USER = async (id) => {
  const query = gql`
    query {
      user(where: { id: { _eq: ${id} } }) {
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
      user(where: { username: { _eq: "${username}" } }) {
        id
        name
        username
        profile_picture_url
        bio
        location
        website
        created_at
        password
        premium
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
    hashtags ? hashtags.forEach(async (hashtag) => {
      const hashtagResponse = await CREATE_HASHTAG(hashtag);
      console.log(tweet, hashtagResponse);
      await CREATE_TWEET_HASHTAG(tweet.id, hashtagResponse.id);
    }) : null;
    return tweet;
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
    mutation {
      insert_retweet(
        objects: {
          tweet_id: "${tweet_id}"
          user_id: "${user_id}"
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
    const retweet = response.data.insert_retweet.returning[0];
    return retweet;
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
};
