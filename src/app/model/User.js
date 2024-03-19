const AWS = require('aws-sdk');

AWS.config.update({
  region: "us-west-2",
  endpoint: "http://localhost:8000"
});

const dynamodb = new AWS.DynamoDB.DocumentClient();

const createUser = async (name, email, password) => {
  if (!name || !email || !password) {
    throw new Error('Name, email and password are required');
  }

  const user = {
    TableName: 'Users',
    Item: {
      'name': name,
      'email': email,
      'password': password,
      'createdAt': Date.now(),
      'updatedAt': Date.now()
    }
  };

  try {
    await dynamodb.put(user).promise();
    return user.Item;
  } catch (error) {
    throw new Error('Error creating user');
  }
};

module.exports = createUser;