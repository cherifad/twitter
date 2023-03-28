import { apolloProvider } from "./apolloProvider";
import { gql } from "graphql-tag";
import bcrypt from "bcryptjs";

const GET_TWEETS = async () => {
  const query = gql`
    query {
      tweet {
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

  try {
    const response = await apolloProvider.query({ query });
    const tweets = response.data.tweet;
    return tweets;
  } catch (error) {
    console.error(error);
    return [];
  }
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
      }
    }
  `;
  try {
    const response = await apolloProvider.query({ query });
    const users = response.data.user;
    if(users.length == 0) return null;
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


export { GET_TWEETS, GET_USER, GET_USER_WITH_PASSWORD, CREATE_NEW_USER };