const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');
const articleRoutes = require('./routes/articles');
const favoriteRoutes = require('./routes/favorites');

const app = express();
app.use(bodyParser.json());

app.use('/auth', authRoutes);
app.use('/articles', articleRoutes);
app.use('/favorites', favoriteRoutes);

app.get('/', (req, res) => {
  res.send('Backend is running');
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});