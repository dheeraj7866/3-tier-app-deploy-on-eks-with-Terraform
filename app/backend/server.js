const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());

const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/simpleapp';

mongoose.connect(MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB error:'));
db.once('open', () => console.log('Connected to MongoDB'));

const Item = mongoose.model('Item', new mongoose.Schema({ name: String }));

app.get('/', (req, res) => res.send('Hello from Backend'));
app.get('/test', (req, res) => res.send('Backend Test Successful'));
app.get('/db', async (req, res) => {
  const items = await Item.find();
  res.json(items);
});

app.listen(PORT, () => {
  console.log(`Backend running on port ${PORT}`);
});
