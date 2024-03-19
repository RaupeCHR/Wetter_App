const AWS = require('aws-sdk');

// Set the region 
AWS.config.update({
  region: "eu-central-1",
  endpoint: "dynamodb.eu-central-1.amazonaws.com"
});

// Create the DynamoDB service object
const ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

const DBconnection = async () => {
  try {
    // Call DynamoDB to list the tables
    const tables = await ddb.listTables({}).promise();
    console.log("Database connected successfully");
    console.log("Tables", tables.TableNames);
  } catch (err) {
    console.log("Getting Error from DB connection", err);
  }
};

module.exports = DBconnection;