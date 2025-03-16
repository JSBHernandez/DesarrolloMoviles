const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { User } = require('../models');
const router = express.Router();

router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ where: { username } });
  if (user && bcrypt.compareSync(password, user.password)) {
    const token = jwt.sign({ id: user.id }, 'secret', { expiresIn: '7d' });
    res.json({ token });
  } else {
    res.status(401).send('Invalid credentials');
  }
});

router.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const hashedPassword = bcrypt.hashSync(password, 10);
  const user = await User.create({ username, password: hashedPassword });
  res.json(user);
});

module.exports = router;