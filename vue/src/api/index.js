import { apolloProvider } from "./apolloProvider";
import { gql } from "graphql-tag";
import bcrypt from "bcryptjs";

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
    return tweet;
  } catch (error) {
    console.error(error);
    return [];
  }
};

const CREATE_NEW_LIKE = async (tweet_id, user_id) => {
  const mutation = gql`
    mutation {
      insert_like(
        objects: {
          tweet_id: "${tweet_id}"
          user_id: "${user_id}"
        },
        on_conflict: {
          constraint: like_user_id_tweet_id_key,
          update_columns: []
        }
      ) {
        affected_rows
      }
    }
  `;
  try {
    const response = await apolloProvider.mutate({ mutation });
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
};
