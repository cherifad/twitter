import { apolloProvider } from "./apolloProvider";
import { gql } from "graphql-tag";

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
    const user = response.data.user;
    if (bcrypt.compareSync(password, user.password)) {
      return user;
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
  const query = gql`
    mutation {
      insert_user(
        objects: {
          name: "${name}"
          email: "${email}"
          password: "${encryptedPassword}"
          username: "${username}"
          dateOfBirth: "${dateOfBirth}"
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
    const response = await apolloProvider.query({ query });
    const user = response.data.user;
    return user;
  } catch (error) {
    console.error(error);
    return [];
  }
};


export { GET_TWEETS, GET_USER, GET_USER_WITH_PASSWORD, CREATE_NEW_USER };