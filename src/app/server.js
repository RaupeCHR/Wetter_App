const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const AWS = require('aws-sdk');

AWS.config.update({
  region: "eu-central-1",
  endpoint: "dynamodb.eu-central-1.amazonaws.com"
});

const dynamodb = new AWS.DynamoDB.DocumentClient();

const app = express();

app.use(cors());
app.use(express.json());

app.post('/users/register', async (req, res) => {
  try {
    const { email, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 8);

    const params = {
      TableName: 'Users',
      Item: {
        'email': email,
        'password': hashedPassword
      }
    };

    dynamodb.put(params, (err, data) => {
      if (err) {
        res.status(400).send(err);
      } else {
        const token = jwt.sign({ email: email }, 'secret');
        res.status(201).send({ user: params.Item, token });
      }
    });
  } catch (error) {
    res.status(400).send(error);
  }
});

app.post('/users/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const params = {
      TableName: 'Users',
      Key: {
        'email': email
      }
    };

    dynamodb.get(params, async (err, data) => {
      if (err) {
        res.status(400).send(err);
      } else {
        if (!data.Item) {
          return res.status(401).send({error: 'Login failed! Check authentication credentials'});
        }
        const isMatch = await bcrypt.compare(password, data.Item.password);
        if (!isMatch) {
          return res.status(401).send({error: 'Login failed! Check authentication credentials'});
        }
        const token = jwt.sign({ email: email }, 'secret');
        res.send({ user: data.Item, token });
      }
    });
  } catch (error) {
    res.status(400).send(error);
  }
});

app.listen(3001, () => {
  console.log('Server is running on port 3001');
});